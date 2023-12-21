local file = io.open("/etc/os-release", "r")
local copy = io.open("/etc/nile-os-release", "w")

local splitString = dofile("/var/NileRiver/core/libraries/Nile_Utility_Functions.lua").splitString

if file == nil then
	print("/etc/os-release not found. Changes not made.")
	os.exit()
end

local releaseContents = file:read("*all")
local newContents = ""

local function addEntry(str)
	newContents = newContents .. str .. "\n"
end


local relLines = splitString(releaseContents, "\n")

if string.sub(reLines[1], 7, 10) == "NILE" then
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
		addEntry(key .. "=nile-logo\n")
	else
		addEntry(key .. "=" .. value .. "\n")
	end
end
