#!/usr/bin/env lua
--
-- # flavors
--
-- Simple flavor managment for projects
--
-- **Version:** 0.2.0.0
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
        Needs to be a directory containing a flavor.json
]]

-- ### FILE_FLAVOR
--
-- The local configuration file's name.
--
local FILE_FLAVOR = "flavor.json"

-- ### MODE_COPY
--
-- The copy mode.
--
local MODE_COPY = "copy"

-- ### MODE_SUBSTITUTE
--
-- The substitution mode
--
local MODE_SUBSTITUTE = "substitute"

-- ### applyCopy
--
-- Function to copy a 'file'
--
-- - 'src'  is a string
-- - 'dest' is a string
-- - 'file' is a table
--
function applyCopy(src, dest, file)
    file.dest = file.dest or file.src
    print("Copying file '" .. file.src .. "' to '" .. dest .. "/" .. file.dest .. "'.")
    File.copyBinary(src .. "/" .. file.src, dest .. "/" .. file.dest)
end

-- ### applySubs
--
-- Function to apply all substitutions to the 'file' using string:gsub
--
-- - 'src'  is a string
-- - 'file' is a table
--
function applySubs(src, file)
    print("Substituting strings in file '" .. src .. "/" .. file.src .. "'.")
    for _, sub in pairs(file.subs) do
        local content = File.read(src .. "/" .. file.src)
        content = content:gsub(sub.replace, sub.with)
        File.write(src .. "/" .. file.src, content, 'wb')
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
        print("Applying flavor '" .. flavor .. "'.")
        -- parse the configuration file
        local configData = File.read(flavor .. "/" .. FILE_FLAVOR)
        local config = Json:decode(configData)
        if config.project then
            for _, file in pairs(config.files) do
                -- default to copy mode
                file.mode = file.mode or MODE_COPY

                if file.mode == MODE_COPY then
                    -- copy the file
                    applyCopy(flavor, config.project, file)
                elseif file.mode == MODE_SUBSTITUTE then
                    -- substitue the specified strings
                    applySubs(config.project, file)
                else
                    print("Invalid mode for file '" .. file.src .. "'.")
                end
            end
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

