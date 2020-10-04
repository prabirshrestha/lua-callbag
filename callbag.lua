local t_string = 'string'
local t_function = 'function'

-- vim sepecific bootstrap
local callbag_id = 0
local vimcmd
local vimeval

local addListener
local removeListener

local initvim = function ()
    if vim.api ~= nil then
        vimcmd = vim.api.nvim_command
        vimeval = vim.api.nvim_eval
    else
        vimcmd = vim.command
        vimeval = vim.eval
    end

    callbag_id = vimeval('get(g:, "lua_callbag_id", 0)') + 1
    vimcmd('let g:lua_callbag_id = ' .. callbag_id)

    local globalAutoCmdHandlerName = 'lua_callbag_autocmd_handler_' .. callbag_id
    local autoCmdHandlers = {}
    _G[globalAutoCmdHandlerName] = function (name)
        autoCmdHandlers[name]()
    end

    addListener = function (name, events, cb)
        autoCmdHandlers[name] = cb
        vimcmd('augroup ' .. name)
        vimcmd('autocmd!')
        for _, v in ipairs(events) do
            local cmd = 'lua ' .. globalAutoCmdHandlerName .. '("' .. name ..'")'
            vimcmd('au ' .. v .. ' ' .. cmd)
        end
        vimcmd('augroup end')
    end

    removeListener = function (name)
        vimcmd('augroup ' .. name)
        vimcmd('autocmd!')
        vimcmd('augroup end')
        autoCmdHandlers[name] = nil
    end
end

if vim ~= nil then initvim() end
-- end vim specific bootstrap

local function pipe(...)
    local arg = {...}
    local res = arg[1]
    for i = 2,#arg do
        res = arg[i](res)
    end
    return res
end

local fromIPairs = function (values)
    return function (start, sink)
        if start ~= 0 then return end
        local disposed = false
        sink(0, function (type)
            if type ~= 2 then return end
            disposed = true
        end)

        for key, value in ipairs(values) do
            if disposed then return end
            sink(1, value)
        end

        if disposed then return end

        sink(2)
    end
end

local fromEventId = 0
local fromEvent = function (events, ...)
    local arg = {...}

    return function (start, sink)
        if start ~= 0 then return end
        local disposed = false
        local eventName
        local handler = function ()
            sink(1, nil)
        end
        sink(0, function (t)
            if t ~= 2 then return end
            disposed = true
            if eventName ~= nil then
                removeListener(eventName)
            end
        end)

        if disposed then return end

        if type(events) == t_string then
            events = { events }
        end

        local listenerEvents = {}
        for _, v in ipairs(events) do
            if type(v) == t_string then
                table.insert(listenerEvents, v .. ' * ')
            else
                table.insert(listenerEvents, table.join(v, ','))
            end
        end

        if #arg > 0 then
            eventName = arg[1]
        else
            fromEventId = fromEventId + 1
            eventName = '__lua_callbag_' .. callbag_id .. '_fromEvent_' .. fromEventId .. '__'
        end

        addListener(eventName, listenerEvents, handler)
    end
end

local forEach = function (operation)
    return function (source)
        local talkback
        source(0, function (t, d)
            if t == 0 then talkback = d end
            if t == 1 then operation(d) end
            if (t == 1 or t == 0) then talkback(1) end
        end)
    end
end

local subscribe = function (listener)
    return function (source)
        if type(listener) == t_function then listener = { next = listener } end

        local nextcb = listener['next']
        local errorcb = listener['error']
        local completecb = listener['complete']

        local talkback

        source(0, function (t, d)
            if t == 0 then talkback = d end
            if t == 1 and nextcb then nextcb(d) end
            if t == 1 or t == 0 then talkback(1) end -- pull
            if t == 2 and not d and completecb then completecb() end
            if t == 2 and d and errorcb then errorcb(d) end
        end)

        local dispose = function ()
            if talkback then talkback(2) end
        end

        return dispose
    end
end

local filter = function (condition)
    return function (source)
        return function (start, sink)
            if start ~= 0 then return end
            local talkback
            source(0, function (t, d)
                if t == 0 then
                    talkback = d
                    sink(t, d)
                elseif t == 1 then
                    if condition(d) then
                        sink(t, d)
                    else
                        talkback(1)
                    end
                else
                    sink(t, d)
                end
            end)
        end
    end
end

local map = function (f)
    return function (source)
        return function (start, sink)
            if start ~= 0 then return end
            source(0, function (t, d)
                if t == 1 then
                    sink(t, f(d))
                else
                    sink(t, d)
                end
            end)
        end
    end
end

local distinctUntilChangedDefaultComparator = function (previous, current)
    return previous == current
end

local distinctUntilChanged = function (compare)
    if not compare then compare = distinctUntilChangedDefaultComparator end
    return function (source)
        return function (start, sink)
            if start ~= 0 then return end
            local inited = false
            local previous
            local talkback
            source(0, function (t, d)
                if t == 0 then talkback= d end
                if t~= 1 then
                    sink(t, d)
                    return
                end
                if inited and compare(previous, d) then
                    talkback(1)
                    return
                end

                inited = 1
                previous = d
                sink(1, d)
            end)
        end
    end
end

local debounceTime = function (wait)
    return function (source)
        return function (start, sink)
            if start ~= 0 then return end
            local timeout
            source(0, function (t, d)
                if t == 1 or (t == 2 and d == nil) then
                    if not timeout and t == 2 then
                        sink(t, d)
                        return
                    end

                    if timeout then
                        vim.fn.timer_stop(timeout)
                    end

                    timeout = vim.fn.timer_start(wait, function ()
                        sink(t, d)
                        timeout = nil
                    end)
                else
                    sink(t, d)
                end
            end)
        end
    end
end

return {
    pipe = pipe,

    forEach = forEach,
    subscribe = subscribe,

    fromIPairs = fromIPairs,
    fromEvent = fromEvent,

    distinctUntilChanged = distinctUntilChanged,
    filter = filter,
    map = map,

    debounceTime = debounceTime,
}
