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
        if type(listener) == 'function' then listener = { next = listener } end

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

return {
    pipe = pipe,
    forEach = forEach,
    fromIPairs = fromIPairs,
    subscribe = subscribe,
    filter = filter,
    map = map
}
