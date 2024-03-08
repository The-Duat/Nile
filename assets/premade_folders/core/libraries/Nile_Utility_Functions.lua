--[=[ [ General Utility Functions ] ]=]--

local Functions = {}



--[=[ Command Manipulation ]=]--

-- Run given command.
Functions.x = function(cmd)
	os.execute(cmd)
end

-- Run given command as root.
Functions.xs = function(cmd)
	os.execute("sudo " .. cmd)
end

-- Execute string as file.
Functions.xaf = function(fileDir, cmd)
	local fileName = tostring(math.random(1,1000000))
	os.execute("touch " .. fileDir .. "/" .. fileName)
	os.execute("sudo chown -R " .. userName .. ":" .. userName .. " " .. fileDir .. "/" .. fileName)
	os.execute("sudo chmod -R 777 " .. fileDir .. "/" .. fileName)
	local file = io.open(fileDir .. "/" .. fileName, "w")
	if file ~= nil then
		file:write(cmd)
	else
		fault("Error dumping string into " .. fileName)
	end
	file:close()
	os.execute("sleep 1")
	os.execute("cd " .. fileDir .. " && ./" .. fileName)
	os.execute("rm " .. fileDir .. "/" .. fileName)
end

-- Run given Lua function as root.S
Functions.runAsRoot = function(fn)
	if not type(fn) == "Function" then
		fault("Error.")
	end
end

-- Read output of a command.
local function readCommand(cmd)
	local file = assert(io.popen(cmd, 'r'))
	local out = assert(file:read('*a'))
	file:close()
	if raw then return out end
	out = string.gsub(out, '^%s+', '')
	out = string.gsub(out, '%s+$', '')
	out = string.gsub(out, '[\n\r]+', ' ')
	return out
end
Functions.readCommand = readCommand

-- Install packages from the native package manager.
Functions.iPkg = function(packages, aurmode)
	local baseCommand
	if nativePkgManager == "pacman" then
		baseCommand = pmCommandSheet[nativePkgManager].install
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

-- Remove pacman/AUR package
Functions.rPkg = function(packages, aurmode)
	local baseCommand
	if nativePkgManager == "pacman" then
		baseCommand = pmCommandSheet[nativePkgManager].remove
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
Functions.sudo = function(fn)
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
Functions.checkFile = function(path)
	local file = io.open(path, "r")
	if not file == nil then
		file:close()
		return true
	end
	return false
end

-- Read file contents.
Functions.readFile = function(path)
	local file = io.open(path, "r")
	if not file == nil then
		local contents = file:read("*all")
		file:close()
		return contents
	else
		fault("Could not open file: "..path..". Does it exist?")
	end
end

-- Write to file.
Functions.writeFile = function(path, contents)
	local file = io.open(path, "w")
	if not file == nil then
		file:write(contents)
		file:close()
	else
		fault("Could not write to file: "..path..".")
	end
end


--[=[ String Manipulation ]=]--

-- Split string into multiple parts.
Functions.splitString = function(str, splitChar)
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
Functions.trimWhite = function(str)
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
Functions.isInt = function(str)
	local i = 1
	if string.sub(str, 1, 1) == "0" then return false end
	while i <= #str do
		if not string.find(integerCharacterSheet, string.sub(str, i, i)) == true then
			return false
		end
		i = i + 1
	end
	return true
end

-- Check if string represents a hex color code.
Functions.isHex = function(str)
	local i = 1
	local hex = string.lower(str)
	if #hex ~= 6 then return false end
	while i <= #hex do
		if not string.find(hexCharacterSheet, string.sub(hex, i, i)) == true then
			return false
		end
		i = i + 1
	end
	return true
end


--[=[ Network ]=]--
Functions.wifiManager = function(action, ssid, password)
	local netmanager = "none"
	if #readCommand("ps -C iwd") > 25 then
        netmanager = "iwd"
    elseif #readCommand("ps -C NetworkManager") > 25 then
        netmanager = "ntm"
    end
	if netmanager == "none" then
		fault("No compatible network management program is running.")
		say("Compatible network management programs:")
		say2("IWD")
		say2("NetworkManager")
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
Functions.writeSetting = function(program, setting, value)
	local configFile = io.open(string.format("/var/NileRiver/config/%s/%s/settings/%s", userName, program, setting), "w")
	if configFile then
		configFile:write(value)
		configFile:close()
		os.execute(string.format("cd /var/NileRiver/config/%s/%s && ./genconf", userName, program))
	else
		fault("Error opening " .. setting .. " config file for " .. program .. ".")
	end
end

-- Check "c.lua" existence. Used for system backups/restores.
Functions.checkC = function(path)
	if pcall(function()
		dofile(path .. "/c.lua")
	end) then
		return true
	else
		return false
	end
end

-- Install a DE/WM
Functions.iDesktop = function(desktopName)
	for _,desktop in pairs(UITable) do
		if desktop[1] == desktopName then
			if desktop[3] == false then
				os.execute("sudo pacman -S " .. desktop[2])
			elseif desktop[3] == true then
				os.execute("yay -S " .. desktop[2])
			end
		end
	end
end

-- Remove a DE/WM
Functions.rDesktop = function(desktopName)
	for _,desktop in pairs(UITable) do
		if desktop[1] == desktopName then
			if desktop[3] == true then
				os.execute("sudo pacman -Rn " .. desktop[2])
			elseif desktop[3] == false then
				os.execute("yay -Rn " .. desktop[2])
			end
		end
	end
end

-- Exit.
Functions.exit = function()
	os.exit()
end



return Functions
