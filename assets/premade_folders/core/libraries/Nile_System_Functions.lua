local System = {}



--[=[ Display system info ]=]--
System.info = function(operator)
	local switch = {

		-- Show help page.
		["help"] = function()
			say("Documentation:")
			say2("https://entertheduat.org")
			say("Discord server:")
			say2("https://discord.gg/AVSuRZsTXp")
			say("Github:")
			say2("https://github.com/The-Duat/mizOS")
		end,

		-- List installed OPMS packages.
		["pkgs"] = function()
			listInstalled()
		end,

		-- List packages in the Duat's repository.
		["repo"] = function()
			listRepo()
		end,

		-- Display current i3 settings.
		["i3settings"] = function()
			say("Current i3 settings:")
			viewSettings("/var/NileRiver/config/" .. userName .. "/i3")
		end,

		-- Display current Alacritty settings.
		["alacrittysettings"] = function()
			say("Current Alacritty settings:")
			viewSettings("/var/NileRiver/config/" .. userName .. "/alacritty")
		end,

		-- Display current GTK settings.
		["gtksettings"] = function()
			say("Current GTK settings:")
			viewSettings("/var/NileRiver/config/" .. userName .. "/gtk")
		end,
		["themes"] = function()
			say("Installed themes:")
			for _,theme in pairs(splitString(readCommand("ls /var/NileRiver/themes")), " ") do
				say2(theme)
			end
		end
	}
	if switch[operator] then
		switch[operator]()

		-- Display theme info
	elseif checkC("/var/NileRiver/themes/" .. operator) == true then
		say("Settings for theme " .. operator .. ":")
		say("i3 Settings:")
		viewSettings("/var/NileRiver/themes/" .. operator .. "/i3")
		say("GTK Settings:")
		viewSettings("/var/NileRiver/themes/" .. operator .. "/gtk")
		say("Alacritty Settings:")
		viewSettings("/var/NileRiver/themes/" .. operator .. "/alacritty")

	else
		fault("Invalid operator: " .. operator)
	end
end


--[=[ System configuration ]=]--
System.config = function(operator, value)

	-- Change the system wallpaper.
	if operator == "wallpaper" then
		local wallpaperInfo = splitString(value, ".")
		local pathInfo = splitString(value, "/")
		local fileType = wallpaperInfo[#wallpaperInfo]
		local wallpaperName = pathInfo[#pathInfo]
		if fileType ~= "png" and fileType ~= "jpg" and fileType ~= "webp" then
			fault("Incorrect filetype: " .. fileType)
			exit()
		end
		x("rm -rf /var/NileRiver/config/" .. userName .. "/wallpaper/*")
		x(string.format("cp %s /var/NileRiver/config/%s/wallpaper/", value, userName))
		x(string.format("mv /var/NileRiver/config/%s/wallpaper/%s /var/NileRiver/config/%s/wallpaper/wallpaper.%s", userName, wallpaperName, userName, fileType))
		x("pkill -fi feh")
		x(string.format("feh --bg-fill --zoom fill /var/NileRiver/config/%s/wallpaper/wallpaper.*", userName))
		say("Wallpaper changed to " .. value)

	-- Change NILE Theme
	elseif operator == "theme" then
		if checkC("/var/NileRiver/themes/" .. value) == false then
			fault("The theme " .. value .. " is not installed.")
		end
		say("Overwrite your current settings with the theme " .. value .. "? (y/n)")
		say("Your current settings will be lost.")
		if string.lower(read()) ~= "y" then
			fault("Aborted.")
		end
		xs("rm -rf /var/NileRiver/config/" .. userName .. "/*")
		xs("cp -r /var/NileRiver/themes/" .. value .. "/* /var/NileRiver/config/" .. userName .. "/")
		xs(string.format("chown -R %s:%s /var/NileRiver/config/%s", userName, userName, userName))
		xs("chmod -R 755 /var/Nile/config/%s", userName)
		xs("pkill -fi feh")
		x(string.format("cd /var/NileRiver/config/%s/i3 && ./genconf", userName))
		x(string.format("cd /var/NileRiver/config/%s/gtk && ./genconf", userName))
		x(string.format("cd /var/NileRiver/config/%s/alacritty && ./genconf", userName))
		x(string.format("feh --bg-fill --zoom fill /var/NileRiver/config/%s/wallpaper/wallpaper.*", userName))
		if checkC("/var/NileRiver/config/" .. userName) then
			say("Theme has sucessfully been enabled.")
		else
			fault("An unknown error occured when attempting to enable theme " .. value)
		end

	-- Change the package security level.
	elseif operator == "pkgsec" then
		if value == "strict"
		or value == "moderate"
		or value == "none" then
			local currentLevel = dofile("/var/NileRiver/security/active/type.lua")
			xs("rm /var/NileRiver/security/active/*")
			xs("cp /var/NileRiver/security/storage/" .. value .. "/type.lua /var/NileRiver/security/active")
			say("Package security level changed from " .. currentLevel .. " to " .. value .. ".")
		else
			fault("Invalid security type: " .. value)
		end

	-- Change i3 settings.
	elseif i3ConfigSheet[operator] then
		local dataType = i3ConfigSheet[operator]
		if dataType == "special_bar" then
			if value == "top" 
			or value == "bottom" then
				writeSetting("i3", operator, value)
			else
				fault("Invalid bar position: " .. value)
				exit()
			end
		elseif dataType == "special_mod" then
			if value == "Mod1"
			or value == "Mod2"
			or value == "Mod3"
			or value == "Mod4" then
				writeSetting("i3", operator, value)
			else
				fault("Invalid mod key: " .. value)
				exit()
			end
		elseif dataType == "hex" then
			if isHex(value) == true then
				writeSetting("i3", operator, "#" .. value)
			else
				fault("Invalid hex color: #" .. value)
				exit()
			end
		elseif dataType == "int" then
			if isInt(value) == true then
				writeSetting("i3", operator, value)
			else
				fault("Invalid integer: " .. value)
				exit()
			end
		end
		say(operator .. " has been set to " .. value .. ".")

	-- Change Alacritty settings.
	elseif alacrittyConfigSheet[operator] then
		local dataType = alacrittyConfigSheet[operator]
		if dataType == "hex" then
			if isHex(value) == true then
				writeSetting("alacritty", operator, "#" .. value)
			else
				fault("Invalid hex color: #" .. value)
			end
		end

	-- Change GTK settings.
	elseif gtkConfigSheet[operator] == true then
		writeSetting("gtk", operator, value)
		say(operator .. " has changed to " .. value .. ".")
	else
		fault("Invalid info operator: " .. operator)
	end
end



--[=[ Theme Management ]=]--
System.theme = function(operator, value)

	if operator == "compile" then
		say("Compile current settings into a new theme? (y/n)")
		if string.lower(read()) ~= "y" then
			exit()
		end
		say("What should this theme be called?")
		local themeName = read()
		themeName = themeName:gsub(" ", "-")
		themeName = themeName:gsub("/", "-")

		say("Checking existence of " .. themeName)
		if checkC("/var/NileRiver/themes/" .. themeName) == true then
			fault("A theme by the name " .. themeName .. " already exists. Please choose a different name.")
			exit()
		end
		say2("Theme name is not taken. Continuing compilation.")
		xs("mkdir /var/NileRiver/themes/" .. themeName)
		xs(string.format("cp -r /var/NileRiver/config/%s/* /var/NileRiver/themes/%s/", userName, themeName))
		xs("chown -R root:root /var/NileRiver/themes/" .. themeName)
		xs("chmod 755 /var/NileRiver/themes/" .. themeName)
		if checkC("/var/NileRiver/themes/" .. themeName) ~= false then
			say("Theme " .. themeName .. "has been successfully created.")
		else
			fault("Something went wrong while compiling theme " .. themeName)
		end
	end
end


--[=[ Init System service management ]=]--
System.service = function(operator, value)

	local commandSheet
	if initSystem == "systemd" then
		commandSheet = systemdCommandSheet
	elseif initSystem == "runit" then
		commandSheet = runitCommandSheet
	elseif initSystem == "openrc" then
		commandSheet = openrcCommandSheet
	else
		fault("Your init system is not supported.")
		exit()
	end

	local commandInfo = commandSheet[operator]
	if commandInfo then
		if commandInfo[1] == "runit_only" then
			fault("The operator \"" .. operator .. "\" is only supported by the Runit init system.")
			exit()
		elseif commandInfo[1] == "special" then
			write(readCommand(commandInfo[2][value]))
		else
			xs(string.format(commandInfo[1], value))
		end
	else
		fault("Invalid service operator: " .. operator)
		exit()
	end
end


--[=[ Graphics management ]=]--
System.graphics = function(operator, value)

	-- If present, construct the command to be ran.
	local commandString = ""
	if type(value) == "table" then
		for _,argument in pairs(value) do
			commandString = commandString .. argument .. " "
		end
	end

	-- Run command on dedicated GPU.
	if operator == "xd" then
		x("export DRI_PRIME=1 && exec " .. commandString)

	-- Run command on integrated GPU.
	elseif operator == "xi" then
		x("export DRI_PRIME=0 && exec " .. commandString)

	-- Change the graphics mode.
	elseif operator == "mode" then
		if value == "i" then
			say(readCommand("supergfxctl --mode Integrated"))
		elseif value == "d" then
			say(readCommand("supergfxctl --mode Dedicated"))
		elseif value == "h" then
			say(readCommand("supergfxctl --mode Hybrid"))
		elseif value == "c" then
			say(readCommand("supergfxctl --mode Compute"))
		elseif value == "v" then
			say(readCommand("supergfxctl --mode Vfio"))
		else
			fault("Invalid GPU mode: " .. value)
		end

	-- Setup graphics
	elseif operator == "setup" then
		local gpupacksheet = {
			amdGpuDriverPackages,
			nvidiaPropDriverPackages,
			nvidiaFossDriverPackages,
			intelDriverPackages
		}
		say("Please select all needed gpu drivers.")
		say("Available drivers:")
		say2("1. (AMD) AMDGPU")
		say2("2. (Nvidia Proprietary) Nvidia")
		say2("3. (Nvidia FOSS) Nouveau")
		say2("4. (Intel) Intel")
		say("Enter a number selection (e.x. \"1 3 4\")")
		local gpusel = read()
		for _,sel in pairs(splitString(trimWhite(gpusel))) do
			local seln = tonumber(sel)
			if gpupacksheet[seln] then
				iPkg(gpupacksheet[seln], "pacman", false)
			else
				fault("Invalid driver selection: " .. sel)
			end
		end
	else
		fault("Invalid graphics operator: " .. operator)
	end
end


--[=[ Network management. ]=]--
System.network = function(operator, value)
	if operator == "scan-ip" then
		say("Scanning IP Address " .. value)
		x("wget https://freegeoip.app/json/" .. value .. " -O /var/NileRiver/download/ipinfo --no-verbose")
		local IPData = jsonParse(readCommand("cat /var/NileRiver/download/ipinfo"))
		say("General IP information:")
		for data,val in pairs(IPData) do
			data2 = tostring(data)
			if type(val) == "table" then
				val2 = "N/A"
			else
				val2 = tostring(val)
			end
			if type(data2) == "string" and type(val2) == "string" then
				say2(data2 .. ": " .. val2)
			end
		end
		x("rm /var/NileRiver/download/ipinfo")
	elseif operator == "scan-wifi" then
		wifiManager("getlocalnetworks", nil, nil)
	elseif operator == "connect" then
		say("Please enter the password for " .. value .. ".")
		local password = read()
		wifiManager("connect", value, password)
	elseif operator == "disconnect" then
		wifiManager("disconnect", nil, nil)
	end
end


--[=[ System software management. ]=]--
System.software = function(operator, packageList, aurmode, promptBypass)

	-- If channel is opms, convert packagelist table to string.
	local packageString
	local packageType
	if packageList then
		if #splitString(packageList[1], "/") == 2 then -- Check if the package is using the OPMS format (repoName/softwareName)
			packageType = "osiris"
			packageString = packageList[1]
		else
			packageType = "native"
		end
	end

	-- Install a package.
	if operator == "fetch" then
		if packageType == "osiris" then
			say("Current security level: " .. packageSecType)
			say("Checking required security level for " .. packageString .. ".")
			local requiredSecLevel = checkPkgSecLevel(packageString)
			local appendage = ", or below"
			if requiredSecLevel == "none" then
				appendage = ""
			end
			say("Required security level: " .. requiredSecLevel .. appendage .. ".")
			local doesItPass = false
			if requiredSecLevel == "strict" then
				doesItPass = true
			elseif requiredSecLevel == "moderate" then
				if packageSecType ~= "strict" then
					doesItPass = true
				end
			elseif requiredSecLevel == "none" then
				if packageSecType == "none" then
					doesItPass = true
				end
			end
			if doesItPass == true then
				installMPackage(trimWhite(packageString), promptBypass)
			else
				fault("Unable to install " .. packageString .. " with the \"" .. packageSecType .. "\" security type.")
				exit()	
			end
		elseif packageType == "native" then
			iPkg(packageList, aurmode)
		end
	
	-- Remove a package.
	elseif operator == "remove" then
		if packageType == "osiris" then
			removeMPackage(packageString, promptBypass)
		elseif packageType == "native" then
			rPkg(packageList, aurmode)
		end
	else
		fault("Invalid software operator: " .. operator)
	end
end


--[=[ System updates ]=]--
System.update = function(updateType, dev)
	if updateType == "system" then
		local devString = ""
		if dev == true then
			devString = "sudo git checkout development &&"
			say("Developer mode enabled.")
		end
		say("Update the NILE? (y/n)")
		if string.lower(read()) ~= "y" then
			fault("NILE System Update aborted.")
			exit()
		end
		x("cd /var/NileRiver/src && sudo git clone https://github.com/The-Duat/Nile && cd /var/NileRiver/src/Nile && " .. devString .. " ./install && sudo rm -rf /var/NileRiver/src/*")
	elseif updateType == "packages" then
		listInstalled()
		say("Update installed Osiris packages? (y/n)")
		if string.lower(read()) ~= "y" then
			fault("Osiris package update aborted.")
			fault("It is considered dangerous to update the system and not the packages, or vice versa.")
			exit()
		end
		local packages = splitString(readCommand("ls /var/NileRiver/packages"))
		for _,package in pairs(packages) do
			local splitName = splitString(package, "_")
			if splitName[1] and splitName[2] then
				updateMPackage(trimWhite(splitName[1] .. "/" .. splitName[2]))
			end
		end
	else
		fault("Invalid update type: " .. updateType)
	end
end


--[=[ Start i3 ]=]--
System.start = function()
	x("startx /var/NileRiver/core/xinitrc")
end


--[=[ Plugin Management ]=]--
System.plugin = function(operator, value, arguments)           
	if operator == "run" then
		if checkC("/var/NileRiver/plugins/" .. value) == true then
			dofile("/var/NileRiver/plugins/" .. value .. "/plugin.lua").main(NileRiver, arguments)
		else
			fault("The plugin " .. value .. " is not installed.")
                end
        end
end



return System
