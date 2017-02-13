#!/usr/bin/env lua
local Json = require("JSON")
local File = require("file")

-- help string
local HELP = [[
Usage: flavors.lua [flavor]
    [flavor]:
        Needs to be a subdir containing a flavor.json
]]

-- constants
local FILE_FLAVOR = "flavor.json"

function copyFiles(src, dest, files)
    for _, file in pairs(files) do
        -- if no dest name is specified use src
        file.dest = file.dest or file.src
        File.copyBinary(src .. "/" .. file.src, dest .. "/" .. file.dest)
    end
end

function applyFlavor(flavor)
    -- check if flavor exists
    if File.exists(flavor .. "/" .. FILE_FLAVOR) then
        print("Flavor exists")
        -- parse the configuration file
        local configData = File.read(flavor .. "/" .. FILE_FLAVOR)
        local config = Json:decode(configData)
        if config.project then
            -- copy all specified files to according locations
            copyFiles(flavor, config.project, config.files)
        end

        print("Applied flavor " .. flavor .. ".")
    else
        print("Flavor '" .. flavor .. "' doesn't exist.")
    end
end

-- program entry
if arg[1] then
    applyFlavor(arg[1])
else
    print(HELP)
end

