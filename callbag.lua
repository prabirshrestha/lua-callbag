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

return {
    pipe = pipe,
    forEach = forEach,
    fromIPairs = fromIPairs
}
