package = "callbag"
version = "v0.0.1-1"

source = {
    url = "git://github.com/prabirshrestha/lua-callbag.git",
    tag = "0.0.1"
}

description = {
    summary = "Callbag for Lua",
    homepage = "https://github.com/prabirshrestha/lua-callbag",
    license = "MIT",
    maintainer = "mail@prabir.me",
    detailed = [[
        Callbag for lua
    ]]
}

build = {
    type = "builtin",
    modules = { callbag = "callbag.lua" }
}
