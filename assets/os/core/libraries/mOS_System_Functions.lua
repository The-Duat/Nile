local System = {}



--[=[ Display system info ]=]--
System.info = function(operator)

	-- Show help page.
	if operator == "help" then
		say("Documentation:")
		say2("https://entertheduat.org")
		say("Discord server:")
		say2("https://discord.gg/AVSuRZsTXp")
		say("Github:")
		say2("https://github.com/Mizosu97/mizOS")

	-- Display installable DE/WMs
	elseif operator == "uilist" then
		say("Installable Desktop Environments and Window Managers:")
		for _,desktop in pairs(UITable) do
			local manager = ""
			if desktop[3] == true then
				manager = "(AUR)"
			else
				manager = "(Pacman)"
			end
			say2(string.format("%-18s %s", desktop[1], manager))
		end

	-- List installed mizOS packages.
	elseif operator == "pkgs" then
		listInstalled()

	-- List packages in the Duat's repository.
	elseif operator == "repo" then
		listRepo()

	-- Display current i3 settings.
	elseif operator == "i3settings" then
		say("Current i3 settings:")
		for _,settingName in pairs(splitString(readCommand("ls /var/mizOS/config/" .. userName .. "/i3/settings"))) do
			settingName = trimWhite(settingName)
			local settingFile = io.open("/var/mizOS/config/" .. userName .. "/i3/settings/" .. settingName, "r")
			local settingValue = settingFile:read("*all")
			say2(string.format("%-18s %s", settingName, settingValue))
			settingFile:close()
		end

	-- Display current GTK settings.
	elseif operator == "gtksettings" then
		say("Current GTK settings:")
		for _,settingName in pairs(splitString(readCommand("ls /var/mizOS/config/" .. userName .. "/gtk/settings"))) do
			settingName = trimWhite(settingName)
			local settingFile = io.open("/var/mizOS/config/" .. userName .. "/gtk/settings/" .. settingName, "r")
			local settingValue = settingFile:read("*all")
			say2(string.format("%-18s %s", settingName, settingValue))
			settingFile:close()
		end
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
		x("rm -rf /var/mizOS/config/" .. userName .. "/wallpaper/*")
		x(string.format("cp %s /var/mizOS/config/%s/wallpaper/", value, userName))
		x(string.format("mv /var/mizOS/config/%s/wallpaper/%s /var/mizOS/config/%s/wallpaper/wallpaper.%s", userName, wallpaperName, userName, fileType))
		x("pkill -fi feh")
		x("feh --bg-fill --zoom fill /var/mizOS/config/wallpaper/wallpaper.*")
		say("Wallpaper changed to " .. value)

	-- Change the package security level.
	elseif operator == "pkgsec" then
		if value == "strict"
		or value == "moderate"
		or value == "none" then
			local currentLevel = dofile("/var/mizOS/security/active/type.lua")
			xs("rm /var/mizOS/security/active/*")
			xs("cp /var/mizOS/security/storage/" .. value .. "/type.lua /var/mizOS/security/active")
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
				fault("Invalid hex color: " .. value)
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

	-- Change GTK settings.
	elseif gtkConfigSheet[operator] == true then
		writeSetting("gtk", operator, value)
		say(operator .. " has changed to " .. value .. ".")
	else
		fault("Invalid info operator: " .. operator)
	end
end



--[=[ Config backup/restore ]=]--
System.csafety = function(operator, value)
	-- Determine program to restore/backup
	local program = userName
	if value then
		if not configurablePrograms[value] then
			fault("Invalid program: " .. value)
			exit()
		end
		program = userName .. "/" .. value
	end

	-- Backup given program.
	if operator == "backup" then
		local to = "/var/mizOS/backup/"
		if value then to = to .. userName end
		say("Backup settings for " .. program .. "? (y/n)")
		say("Old backups will be lost.")
		if string.lower(read()) ~= "y" then
			fault("Backup aborted.")
			exit()
		end
		if checkC("/var/mizOS/backup/" .. userName) == false then
			x("mkdir /var/mizOS/backup/" .. userName)
		end
		if checkC("/var/mizOS/backup/" .. program) == true then
			x("rm -rf /var/mizOS/backup/" .. program)
		end
		x("cp -r /var/mizOS/config/" .. program .. " " .. to)

	-- Restore given program.
	elseif operator == "restore" then
		local to = "/var/mizOS/config/"
		if value then to = to .. userName end
		say("Restore settings for " .. program .. "? (y/n)")
		say("Current settings will be lost.")
		if string.lower(read()) ~= "y" then
			fault("Restoration aborted.")
			exit()
		end
		if checkC("/var/mizOS/backup/" .. program) == false then
			fault("Backup for " .. program .. " doesn't exist.")
			exit()
		end
		x("rm -rf /var/mizOS/config/" .. program)
		x("cp -r /var/mizOS/backup/" .. program .. " " .. to)
	end
end


--[=[ mizOS service management ]=]--
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


--[=[ mizOS graphics management ]=]--
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
	else
		fault("Invalid graphics operator: " .. operator)
	end
end


--[=[ System software management. ]=]--
System.software = function(operator, channel, packageList)

	-- If channel is mizOS, convert packagelist table to string.
	local packageString
	if packageList then
		if channel == "mizos" or channel == "desktop" then
			packageString = packageList[1]
		end
	end

	-- Install a package.
	if operator == "fetch" then
		if channel == "mizos" then
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
				installMPackage(trimWhite(packageString))
			else
				fault("Unable to install " .. packageString .. " with the \"" .. packageSecType .. "\" security type.")
				exit()	
			end
		elseif channel == "pacman" or channel == "aur" then
			iPkg(packageList, channel)
		elseif channel == "dekstop" then
			iDesktop(packageString)
		end
	
	-- Remove a package.
	elseif operator == "remove" then
		if channel == "mizos" then
			removeMPackage(packageString)
		elseif channel == "pacman" or channel == "aur" then
			rPkg(packageList, channel)
		elseif channel == "desktop" then
			rDesktop(packageString)
		end

	-- Clear package cache, and journal logs if SystemD is present.
	elseif operator == "clear cache" then
		say("Clearing package cache.")
		x("yay -Scc")
		if initSystem == "systemd" then
			xs("journalctl --vacuum-time=21days")
		else
			fault("SystemD not found, unable to clear journal logs.")
		end
	else
		fault("Invalid software operator: " .. operator)
	end
end


--[=[ mizOS system updates ]=]--
System.update = function(updateType, dev)
	if updateType == "system" then
		local devString = ""
		if dev == true then
			devString = "sudo git checkout development &&"
			say("Developer mode enabled.")
		end
		say("Update mizOS? (y/n)")
		if string.lower(read()) ~= "y" then
			fault("mizOS System Update aborted.")
			exit()
		end
		x("cd /var/mizOS/src && sudo git clone https://github.com/Mizosu97/mizOS && cd /var/mizOS/src/mizOS && " .. devString .. " ./install && sudo rm -rf /var/mizOS/src/*")
	elseif updateType == "packages" then
		listInstalled()
		say("Update installed mizOS packages? (y/n)")
		if string.lower(read()) ~= "y" then
			fault("mizOS package update aborted.")
			fault("It is considered dangerous to update the system and not the packages, or vice versa.")
			exit()
		end
		local packages = splitString(readCommand("ls /var/mizOS/packages"))
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



return System
