local System = {}



--[=[ Display system info ]=]--
System.info = function(operator)

	-- Show help page.
	if operator == "help" then
		say("Documentation:")
		say2("https://entertheduat.org")
		say("\nDiscord server:")
		say2("https://discord.gg/AVSuRZsTXp")
		say("\nGithub:")
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
			say2(string.format("%s %-s", desktop[1], manager))
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
		for _,settingName in pairs(splitString(readCommand("ls /var/mizOS/config/i3/settings"))) do
			settingName = trimWhite(settingName)
			local settingFile = io.open("/var/mizOS/config/i3/settings/" .. settingName, "r")
			local settingValue = settingFile:read("*all")
			say2(string.format("%s: %-s", settingName, settingValue))
			settingFile:close()
		end

	-- Display current GTK settings.
	elseif operator == "gtksettings" then
		say("Current GTK settings:")
		for _,settingName in pairs(splitString(readCommand("ls /var/mizOS/config/gtk/settings"))) do
			settingName = trimWhite(settingName)
			local settingFile = io.open("/var/mizOS/config/gtk/settings/" .. settingName, "r")
			local settingValue = settingFile:read("*all")
			say2(string.format("%s: %-s", settingName, settingValue))
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
		x("rm -rf /var/mizOS/config/wallpaper/*")
		x("cp " .. value .. " /var/mizOS/config/wallpaper/")
		x("mv /var/mizOS/config/wallpaper/" .. wallpaperName .. " /var/mizOS/config/wallpaper/wallpaper." .. fileType)
		x("pkill -fi feh")
		x("feh --bg-fill --zoom fill /var/mizOS/config/wallpaper/wallpaper.*")
		say("Wallpaper changed to " .. value)
	elseif operator == "pkgsec" then
		if value == "strict"
		or value == "moderate"
		or value == "none" then
			local currentLevel = dofile("/var/mizOS/security/active/type.lua")
			x("rm /var/mizOS/security/active/*")
			x("cp /var/mizOS/security/storage/" .. value .. "/type.lua /var/mizOS/security/active")
			say("Package security level changed from " .. currentLevel .. " to " .. value .. ".")
		else
			fault("Invalid security type: " .. value)
		end
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
		say(operator .. " has been set to " .. value)
	end
end



return System
