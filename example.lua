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

---
print('create example')
C.pipe(
    C.create(function (next, error, complete)
        next(1)
        next(2)
        next(3)
        complete()
    end),
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)

---
print('empty example')
C.pipe(
    C.empty(),
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)

---

print('never example')
C.pipe(
    C.never(),
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)

---

print('lazy example')
C.pipe(
    C.lazy(function () return 1 end),
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)


----
print('filter example')
C.pipe(
    C.fromIPairs({ 1, 2, 3, 4, 5 }),
    C.filter(function (x) return x % 2 == 0 end),
    C.forEach(function (x) print(x) end)
)

-----
print('map example')
C.pipe(
    C.fromIPairs({ 1, 2, 3 }),
    C.map(function (x) return x * 100 end),
    C.forEach(function (x) print(x) end)
)

-----
print('distinctUntilChanged')
C.pipe(
    C.fromIPairs({ 1, 2, 2, 3, 4, 4, 5, 5 }),
    C.distinctUntilChanged(),
    C.forEach(function (x) print(x) end)
)

---
print('fromEvent for vim')
if vim ~= nil then
    C.pipe(
        C.fromEvent('InsertEnter'),
        C.forEach(function (x) print('InsertEnter') end)
    )
end

---
print('debounceTime for vim')
if vim ~= nil then
    C.pipe(
        C.fromEvent({ 'TextChangedI', 'TextChangedP' }),
        C.debounceTime(250),
        C.forEach(function (x) print('text changed to: ' .. vim.fn.getline('.')) end)
    )
end

---
print('merge')
C.pipe(
    C.merge(
        C.fromIPairs({1, 2, 3 }),
        C.fromIPairs({4, 5, 6})
    ),
    C.subscribe({
        next = function (n) print(n) end,
        complete = function () print('complete') end
    })
)

-----
print('tap')
C.pipe(
    C.fromIPairs({1,2,3}),
    C.tap({ next = function(x) print('tap'..x) end }),
    C.forEach(function (x) print(x) end)
)

---
print('takeUntil')
if vim ~= nil then
    C.pipe(
        C.fromEvent({ 'TextChangedI', 'TextChangedP' }),
        C.takeUntil(C.fromEvent('InsertLeave')),
        C.debounceTime(250),
        C.forEach(function (x) print('text changed to: ' .. vim.fn.getline('.')) end)
    )
end

---
print('makeSubject')
local subject = C.makeSubject()

local dispose = C.pipe(
    subject,
    C.subscribe({
        next = function(x) print(x) end,
        error = function(e) print(e) end,
        complete = function() print('complete') end
    })
)

subject(1, 'hello')
subject(1, 'world')
subject(2)
dispose()
