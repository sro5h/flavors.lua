#!/usr/bin/env lua
local Json = require("JSON")

-- Help string
local HELP = [[
Usage: flavors.lua [flavor]
    [flavor]:
        Needs to be a subdir containing a flavor.json
]]

-- Program entry
if arg[1] then
    applyFlavor(arg[1])
    print("Applied flavor " .. arg[1] .. ".")
else
    print(HELP)
end

