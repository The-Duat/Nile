--[=[ [ General Utility Functions ] ]=]--

local Functions = {}



--[=[ Command Manipulation ]=]--

-- Run given command.
Functions.X = function(cmd)
	os.execute(cmd)
end

-- Run given command as root.
Functions.Xs = function(cmd)
	os.execute("sudo " .. cmd)
end

-- Execute string as file.
Functions.Xaf = function(fileDir, cmd)
	local fileName = tostring(math.random(1,1000000))
	os.execute("touch " .. fileDir .. "/" .. fileName)
	os.execute("sudo chown -R " .. UserName .. ":" .. UserName .. " " .. fileDir .. "/" .. fileName)
	os.execute("sudo chmod -R 777 " .. fileDir .. "/" .. fileName)
	local file = io.open(fileDir .. "/" .. fileName, "w")
	if file ~= nil then
		file:write(cmd)
	else
		Fault("Error dumping string into " .. fileName)
	end
	file:close()
	os.execute("sleep 1")
	os.execute("cd " .. fileDir .. " && ./" .. fileName)
	os.execute("rm " .. fileDir .. "/" .. fileName)
end

-- Run given Lua function as root.S
Functions.RunAsRoot = function(fn)
	if not type(fn) == "Function" then
		Fault("Error.")
	end
end

-- Read output of a command.
local function ReadCommand(cmd)
	local file = assert(io.popen(cmd, 'r'))
	local out = assert(file:read('*a'))
	file:close()
	if raw then return out end
	out = string.gsub(out, '^%s+', '')
	out = string.gsub(out, '%s+$', '')
	out = string.gsub(out, '[\n\r]+', ' ')
	return out
end
Functions.readCommand = ReadCommand

-- Install packages using the native package manager.
Functions.IPkg = function(packages, aurmode)
	local baseCommand
	if NativePkgManager == "pacman" then
		baseCommand = PmCommandSheet[NativePkgManager].install
		if aurmode == true then
			baseCommand = "yay -S"
		end
	end
	local packageString = ""
	for _,package in pairs(packages) do
		packageString = packageString .. package .. " "
	end
	os.execute(baseCommand .. " " .. packageString)
end

-- Remove packages using the native package manager.
Functions.RPkg = function(packages, aurmode)
	local baseCommand
	if NativePkgManager == "pacman" then
		baseCommand = PmCommandSheet[NativePkgManager].remove
		if aurmode == true then
			baseCommand = "yay -Rn"
		end
	end
	local packageString = ""
	for _,package in pairs(packages) do
		packageString = packageString .. package .. " "
	end
	os.execute(baseCommand .. " " .. packageString)
end

-- The Sudo function. Temporarily run Lua code as root.
Functions.Sudo = function(fn)
	local fnData = string.dump(fn)
	local hexfnData = ""
	for i = 1, #fnData do
		local byte = string.byte(fnData, i)
		hexfnData = hexfnData .. string.format("\\x%02x", byte)
	end
	local cmd = "sudo lua -e \"load('" .. hexfnData .. "')()\""
	os.execute(cmd)
end


--[=[ File Manipulation ]=]--

-- Check if file exists.
Functions.CheckFile = function(path)
	local file = io.open(path, "r")
	if not file == nil then
		file:close()
		return true
	end
	return false
end

-- Read file contents.
Functions.ReadFile = function(path)
	local file = io.open(path, "r")
	if not file == nil then
		local contents = file:read("*all")
		file:close()
		return contents
	else
		Fault("Could not open file: "..path..". Does it exist?")
	end
end

-- Write to file.
Functions.WriteFile = function(path, contents)
	local file = io.open(path, "w")
	if not file == nil then
		file:write(contents)
		file:close()
	else
		Fault("Could not write to file: "..path..".")
	end
end


--[=[ String Manipulation ]=]--

-- Split string into multiple parts.
Functions.SplitString = function(str, splitChar)
	local resultSplit = {}
	if splitChar == nil then
		splitChar = " "
	end
	if str and splitChar then
		for part in string.gmatch(str, "([^"..splitChar.."]+)") do
			table.insert(resultSplit, part)
		end
	end
	return resultSplit
end

-- Remove whitespace from string.
Functions.TrimWhite = function(str)
	local trimmedString = ""
	local i = 1
	while i <= #str do
		local currentChar = string.sub(str, i, i)
		if currentChar ~= " " then
			trimmedString = trimmedString .. currentChar
		end
		i = i + 1
	end
	return trimmedString
end

-- Check if string represents an integer.
Functions.IsInt = function(str)
	local i = 1
	if string.sub(str, 1, 1) == "0" then return false end
	while i <= #str do
		if not string.find(IntegerCharacterSheet, string.sub(str, i, i)) == true then
			return false
		end
		i = i + 1
	end
	return true
end

-- Check if string represents a hex color code.
Functions.IsHex = function(str)
	local i = 1
	local hex = string.lower(str)
	if #hex ~= 6 then return false end
	while i <= #hex do
		if not string.find(HexCharacterSheet, string.sub(hex, i, i)) == true then
			return false
		end
		i = i + 1
	end
	return true
end


--[=[ Network ]=]--
Functions.WifiManager = function(action, ssid, password)
	local netmanager = "none"
	if #ReadCommand("ps -C iwd") > 25 then
        netmanager = "iwd"
    elseif #ReadCommand("ps -C NetworkManager") > 25 then
        netmanager = "ntm"
    end
	if netmanager == "none" then
		Fault("No compatible network management program is running.")
		Say("Compatible network management programs:")
		Say2("IWD")
		Say2("NetworkManager")
		os.exit()
	end

	local raw = io.popen("ip route | grep default | awk '{print $5}'")
    local wirelessInterface = raw:read("*a")
    raw:close()
    wirelessInterface = wirelessInterface:gsub("%s+$", "")

	if action == "getlocalnetworks" then
		if netmanager == "ntm" then
			os.execute("nmcli device wifi list")
		else
			os.execute(string.format("iwctl station %s scan && iwctl station %s get-networks", wirelessInterface, wirelessInterface))
		end
	elseif action == "connect" then
		if netmanager == "ntm" then
			os.execute(string.format("nmcli device wifi connect \"%s\" password \"%s\"", ssid, password))
		else
			os.execute(string.format("iwctl --passphrase \"%s\" station wlan0 connect \"%s\"", password, ssid))
		end
	elseif action == "disconnect" then
		if netmanager == "ntm" then
			os.execute("nmcli device disconnect iface " .. wirelessInterface)
		else
			os.execute("iwctl station " .. wirelessInterface .. " disconnect")
		end
	end
end


--[=[ Other ]=]--

-- Change NILE setting.
Functions.WriteSetting = function(program, setting, value)
	local configFile = io.open(string.format("/var/NileRiver/config/%s/%s/settings/%s", userName, program, setting), "w")
	if configFile then
		configFile:write(value)
		configFile:close()
		os.execute(string.format("cd /var/NileRiver/config/%s/%s && ./genconf", userName, program))
	else
		Fault("Error opening " .. setting .. " config file for " .. program .. ".")
	end
end

-- View NILE program settings.
Functions.ViewSettings = function(directory)
	for _,settingName in pairs(SplitString(ReadCommand("ls " .. directory .. "/settings"))) do
		settingName = TrimWhite(settingName)
		local settingFile = io.open(directory .. "/settings/" .. settingName, "r")
		local settingValue = settingFile:read("*all")
		Say2(string.format("%-18s %s", settingName, settingValue))
                settingFile:close()
        end
end

-- Check "c.lua" existence. Used to check Nile directory existence.
Functions.CheckC = function(path)
	if pcall(function()
		dofile(path .. "/c.lua")
	end) then
		return true
	else
		return false
	end
end

-- Exit.
Functions.Exit = function()
	os.exit()
end



return Functions
