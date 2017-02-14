#!/usr/bin/env lua
--
-- # flavors
--
-- Simple flavor managment for projects
--
-- **Version:** 0.4.0
-- **License:** MIT
-- **Source:** [Github](https://github.com/sro5h/flavors.lua)
--

-- ## Modules
--
local Json = require("lib.json")
local File = require("lib.file")

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

-- ### applyCopy
--
-- Function to copy all files specified by 'src' and 'dst' in 'file'
--
-- - 'src'  is a string
-- - 'dst' is a string
-- - 'file' is a table
--
function applyCopy(src, dst, file)
    file.dst = file.dst or file.src
    if type(file.dst) ~= "table" then
        file.dst = { file.dst }
    end

    if type(file.src) ~= "table" then
        -- copy from one source to one or more destinations
        for _, dstDir in ipairs(file.dst) do
            File.copyBinary(src .. "/" .. file.src, dst .. "/" .. dstDir)
            print("Success: copying '" .. file.src .. "' to '" .. dst .. "/" .. dstDir .. "'.")
        end
    else
        if #file.src ~= #file.dst then
            print("Warning: ommiting redundant directories")
        end
        -- set size to the smaller size
        local size
        if #file.src < #file.dst then
            size = #file.src
        else
            size = #file.dst
        end
        -- copy all files from 'src' to 'dst' that have a match
        for i=1, size do
            File.copyBinary(src .. "/" .. file.src[i], dst .. "/" .. file.dst[i])
            print("Success: copying '" .. file.src[i] .. "' to '" .. dst .. "/" .. file.dst[i] .. "'.")
        end

    end

end

-- ### applySubs
--
-- Function to apply all substitutions to the 'file' using string:gsub
--
-- - 'src'  is a string
-- - 'file' is a table
--
function applySubs(src, file)
    if type(file.src) ~= "table" then
        file.src = { file.src }
    end

    for _, sub in pairs(file.subs) do
        for _, dir in pairs(file.src) do
            local content = File.read(src .. "/" .. dir)
            content = content:gsub(sub.replace, sub.with)
            File.write(src .. "/" .. dir, content, 'wb')
            print("Success: substituting '" .. sub.replace .. "' in '" .. src .. "/" .. dir .. "'.")
        end
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
                -- decide whether copying or substituting
                if file.subs then
                    -- substitue the specified strings
                    applySubs(config.project, file)
                else
                    -- copy the file(s)
                    applyCopy(flavor, config.project, file)
                end
            end
        end

        print("Done: applied flavor " .. flavor .. ".")
    else
        print("Error: flavor '" .. flavor .. "' doesn't exist.")
    end
end

-- program entry
if arg[1] then
    applyFlavor(arg[1])
else
    print(HELP)
end

