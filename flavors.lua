#!/usr/bin/env lua
--
-- # flavors
--
-- Simple flavor managment for projects
--
-- **Version:** 0.1.0.0
-- **License:** MIT
-- **Source:** [Github](https://github.com/sro5h/flavors.lua)
--

-- ## Modules
--
local Json = require("JSON")
local File = require("file")

-- ### HELP
--
-- The help string.
--
local HELP = [[
Usage: flavors.lua [flavor]
    [flavor]:
        Needs to be a subdir containing a flavor.json
]]

-- ### FILE_FLAVOR
--
-- The local configuration file's name.
--
local FILE_FLAVOR = "flavor.json"

-- ### copyFiles
--
-- Function to copy all 'files' from 'src' to 'dest'.
--
-- - 'src'   is a string
-- - 'dest'  is a string
-- - 'files' is a table
--
function copyFiles(src, dest, files)
    for _, file in pairs(files) do
        -- if no dest name is specified use src
        file.dest = file.dest or file.src
        File.copyBinary(src .. "/" .. file.src, dest .. "/" .. file.dest)
    end
end

-- ## applyFlavor
--
-- Applies the specified flavor.
--
-- - 'flavor' is a string
--
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

