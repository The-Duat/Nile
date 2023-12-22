local dir = arg[1]

local original = io.open(dir .. "os-release", "r")
local copy = io.open(dir .. "nile-os-release", "w")

local splitString = dofile("/var/NileRiver/core/libraries/Nile_Utility_Functions.lua").splitString

if original == nil then
	print(dir .. "os-release not found. Changes not made.")
	os.exit()
end

local releaseContents = original:read("*all")
original:close()
local newContents = ""

local function addEntry(str)
	newContents = newContents .. str .. "\n"
end


local reLines = splitString(releaseContents, "\n")

if string.sub(reLines[1], 7, 10) == "Nile" then
	print("Already overwritten.")
	os.exit()
end

for _,line in ipairs(reLines) do
	local split = splitString(line, "=")
	local key = split[1]
	local value = split[2]
	if key == "NAME" or key == "PRETTY_NAME" then
		local append = string.sub(value, 2, #value)
		addEntry(key .. "=" .. "\"Nile - " .. append)
	elseif key == "LOGO" then
		addEntry(key .. "=nile-logo")
	else
		addEntry(key .. "=" .. value)
	end
end

copy:write(newContents)
copy:close()
os.execute("sudo rm " .. dir .. "os-release && sudo mv " .. dir .. "nile-os-release " .. dir .. "os-release")

