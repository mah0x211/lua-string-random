package = "string-random"
version = "dev-1"
source = {
    url = "git+https://github.com/mah0x211/lua-string-random.git",
}
description = {
    summary = "generate a random string.",
    homepage = "https://github.com/mah0x211/lua-string-random",
    license = "MIT/X11",
    maintainer = "Masatoshi Fukunaga",
}
dependencies = {
    "lua >= 5.1",
}
build = {
    type = "builtin",
    modules = {
        ["string.random"] = "random.lua",
    },
}
