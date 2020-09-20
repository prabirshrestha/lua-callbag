local C = require("callbag")

print('pipe() example:')
local res = C.pipe(
    2,
    function (x) return x * 10 end,
    function (x) return x - 3 end,
    function (x) return x + 5 end
)

print(res)

res = C.pipe(
    2,
    function (s)
        return C.pipe(
            s,
            function (x) return x * 10 end,
            function (x) return x - 3 end
        )
    end
)

print(res)

----------------------

print('fromIPairs and forEach example:')
C.pipe(
    C.fromIPairs({ 1, 2, 3, 4, 5 }),
    C.forEach(function (x)
        print(x)
    end)
)

--------
print('subscribe example')
local dispose = C.pipe(
    C.fromIPairs({ 1, 2, 3, 4, 5 }),
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)
dispose()

----
print('filter example')
C.pipe(
    C.fromIPairs({ 1, 2, 3, 4, 5 }),
    C.filter(function (x) return x % 2 == 0 end),
    C.forEach(function (x) print(x) end)
)
