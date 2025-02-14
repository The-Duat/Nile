local Main = {}



--[=[ Display system info ]=]--
Main.Info = function(operator)
	local switch = {

		-- Show help page.
		["help"] = function()
			Say("Documentation:")
			Say2("https://entertheduat.org")
			Say("Discord server:")
			Say2("https://discord.gg/AVSuRZsTXp")
			Say("Github:")
			Say2("https://github.com/The-Duat/mizOS")
		end,

		-- List installed OPMS packages.
		["pkgs"] = function()
			Say("Installed Osiris packages:")
			for _,package in ipairs(GetOsirisPackages()) do
				Say2(package)
			end
			Say("Installed Native packages:")
			for _,package in ipairs(GetNativePackages()) do
				Say2(package.Name .. " (" .. package.Version .. ")")
			end
		end,

		-- List packages in the Duat's repository.
		["repo"] = function()
			ListRepo()
		end,

		-- Display current i3 settings.
		["i3settings"] = function()
			Say("Current i3 settings:")
			ViewSettings("/NileRiver/config/" .. UserName .. "/i3")
		end,

		-- Display current Alacritty settings.
		["alacrittysettings"] = function()
			Say("Current Alacritty settings:")
			ViewSettings("/NileRiver/config/" .. UserName .. "/alacritty")
		end,

		-- Display current GTK settings.
		["gtksettings"] = function()
			Say("Current GTK settings:")
			ViewSettings("/NileRiver/config/" .. UserName .. "/gtk")
		end,
		["themes"] = function()
			Say("Installed themes:")
			for _,theme in pairs(SplitString(ReadCommand("ls /NileRiver/themes"), " ")) do
				Say2(theme)
			end
		end
	}
	if switch[operator] then
		switch[operator]()

		-- Display theme info
	elseif DirExists("/NileRiver/themes/" .. operator) == true then
		Say("Settings for theme " .. operator .. ":")
		Say("i3 Settings:")
		ViewSettings("/NileRiver/themes/" .. operator .. "/i3")
		Say("GTK Settings:")
		ViewSettings("/NileRiver/themes/" .. operator .. "/gtk")
		Say("Alacritty Settings:")
		ViewSettings("/NileRiver/themes/" .. operator .. "/alacritty")

	else
		Fault("Invalid operator: " .. operator)
	end
end


--[=[ System configuration ]=]--
Main.Config = function(operator, value)

	-- Change the system wallpaper.
	if operator == "wallpaper" then
		local wallpaperInfo = SplitString(value, ".")
		local pathInfo = SplitString(value, "/")
		local fileType = wallpaperInfo[#wallpaperInfo]
		local wallpaperName = pathInfo[#pathInfo]
		if fileType ~= "png" and fileType ~= "jpg" and fileType ~= "webp" then
			Fault("Incorrect filetype: " .. fileType)
			Exit()
		end
		os.remove(Posix.dirent.dir("/NileRiver/config/" .. UserName .. "/wallpaper")[2])
		X(string.format("cp %s /NileRiver/config/%s/wallpaper/", value, UserName))
		os.rename(string.format("/NileRiver/config/%s/wallpaper/%s", UserName, wallpaperName), string.format("/NileRiver/config/%s/wallpaper/wallpaper.%s", UserName, fileType))
		X("pkill -fi feh")
		X(string.format("feh --bg-fill --zoom fill /NileRiver/config/%s/wallpaper/wallpaper.*", UserName))

		-- Change NILE Theme
	elseif operator == "theme" then
		if DirExists("/NileRiver/themes/" .. value) == false then
			Fault("The theme " .. value .. " is not installed.")
			Exit()
		end
		Say("Overwrite your current settings with the theme " .. value .. "? (y/n)")
		Say("Your current settings will be lost.")
		if string.lower(Read()) ~= "y" then
			Fault("Aborted.")
			Exit()
		end
		-- Recursive things like this are too hard to implement from scratch in luaposix.
		-- If someone has a better way, let me know
		X("rm -rf /NileRiver/config/" .. UserName .. "/*")
		X("cp -r /NileRiver/themes/" .. value .. "/* /NileRiver/config/" .. UserName .. "/")
		X(string.format("chown -R %s:%s /NileRiver/config/%s", UserName, UserName, UserName))
		X("chmod -R 755 /var/Nile/config/%s", UserName)
		X("pkill -fi feh")
		X(string.format("cd /NileRiver/core/genconfs/i3 && ./genconf %s", UserName))
		X(string.format("cd /NileRiver/core/genconfs/gtk && ./genconf %s", UserName))
		X(string.format("cd /NileRiver/core/genconfs/alacritty && ./genconf %s", UserName))
		X(string.format("feh --bg-fill --zoom fill /NileRiver/config/%s/wallpaper/wallpaper.*", UserName))
		if DirExists("/NileRiver/config/" .. UserName) then
			Say("Theme has sucessfully been enabled.")
		else
			Fault("An unknown error occured when attempting to enable theme " .. value)
		end

		-- Change the package security level.
	elseif operator == "pkgsec" then

		CheckRoot()

		Say("Attempting to set the OPMS security level to " .. value .. ".")
		if value == "strict"
			or value == "moderate"
			or value == "none" then
			local currentLevel = dofile("/NileRiver/security/active/type.lua")
			os.remove(Posix.dirent.dir("/NileRiver/security/active")[2])
			local file = io.open("/NileRiver/security/type.lua", "w")
			if file ~= nil then
				file:write("return \"" .. value .. "\"")
				file:close()
				Say("OPMS security level changed from " .. currentLevel .. " to " .. value .. ".")
			else
				Fault("Failed to open file: /NileRiver/security/type.lua")
			end

		else
			Fault("Invalid security type: " .. value)
		end

		-- Change i3 settings.
	elseif I3ConfigSheet[operator] then
		Say("Attempting to set " .. operator .. " to " .. value .. ".")
		local dataType = I3ConfigSheet[operator]
		if dataType == "special_bar" then
			if value == "top" 
				or value == "bottom" then
				WriteSetting("i3", operator, value)
			else
				Fault("Invalid bar position: " .. value)
				Exit()
			end
		elseif dataType == "special_mod" then
			if value == "Mod1"
				or value == "Mod2"
				or value == "Mod3"
				or value == "Mod4" then
				WriteSetting("i3", operator, value)
			else
				Fault("Invalid mod key: " .. value)
				Exit()
			end
		elseif dataType == "hex" then
			if IsHex(value) == true then
				WriteSetting("i3", operator, "#" .. value)
			else
				Fault("Invalid hex color: #" .. value)
				Exit()
			end
		elseif dataType == "int" then
			if IsInt(value) == true then
				WriteSetting("i3", operator, value)
			else
				Fault("Invalid integer: " .. value)
				Exit()
			end
		end

		-- Change Alacritty settings.
	elseif AlacrittyConfigSheet[operator] then
		Say("Attempting to set " .. operator .. " to " .. value .. ".")
		local dataType = AlacrittyConfigSheet[operator]
		if dataType == "hex" then
			if IsHex(value) == true then
				WriteSetting("alacritty", operator, "#" .. value)
			else
				Fault("Invalid hex color: #" .. value)
			end
		end

		-- Change GTK settings.
	elseif GtkConfigSheet[operator] == true then
		Say("Attempting to set " .. operator .. " to " .. value .. ".")
		WriteSetting("gtk", operator, value)
		Say(operator .. " has changed to " .. value .. ".")
	else
		Fault("Invalid info operator: " .. operator)
	end
end



--[=[ Theme Management ]=]--
Main.Theme = function(operator, value)

	if operator == "compile" then
		Say("Compile current settings into a new theme? (y/n)")
		Say("Installed themes are available to all users.")
		if string.lower(Read()) ~= "y" then
			Exit()
		end
		Say("What should this theme be called?")
		local themeName = Read()
		themeName = themeName:gsub(" ", "-")
		themeName = themeName:gsub("/", "-")

		Say("Checking existence of " .. themeName)
		if DirExists("/NileRiver/themes/" .. themeName) == true then
			Fault("A theme by the name " .. themeName .. " already exists. Please choose a different name.")
			Exit()
		end
		-- Ugh. More shell jank. Sadly, I need this as I need both normal user and root access for this to work.
		Say2("Theme name is not taken. Continuing compilation.")
		Xs("mkdir /NileRiver/themes/" .. themeName)
		Xs(string.format("cp -r /NileRiver/config/%s/* /NileRiver/themes/%s/", UserName, themeName))
		Xs("chown -R root:root /NileRiver/themes/" .. themeName)
		Xs("chmod 755 /NileRiver/themes/" .. themeName)
		if DirExists("/NileRiver/themes/" .. themeName) ~= false then
			Say("Theme " .. themeName .. "has been successfully created.")
		else
			Fault("Something went wrong while compiling theme " .. themeName)
		end
	end
end


--[=[ Init System service management ]=]--
Main.Service = function(operator, value)

	local commandSheet
	if InitSystem == "systemd" then
		commandSheet = SystemdCommandSheet
	elseif InitSystem == "runit" then
		commandSheet = RunitCommandSheet
	elseif InitSystem == "openrc" then
		commandSheet = OpenrcCommandSheet
	else
		Fault("Your init system is not supported.")
		Exit()
	end

	local commandInfo = commandSheet[operator]
	if commandInfo then
		if commandInfo[1] == "runit_only" then
			Fault("The operator \"" .. operator .. "\" is only supported by the Runit init system.")
			Exit()
		elseif commandInfo[1] == "special" then
			Write(ReadCommand(commandInfo[2][value]))
		else
			Xs(string.format(commandInfo[1], value))
		end
	else
		Fault("Invalid service operator: " .. operator)
		Exit()
	end
end


--[=[ Graphics management. Undocumented. May be made into a plugin.]=]--
Main.Graphics = function(operator, value)

	-- If present, construct the command to be ran.
	local commandString = ""
	if type(value) == "table" then
		for _,argument in pairs(value) do
			commandString = commandString .. argument .. " "
		end
	end

	-- Run command on dedicated GPU.
	if operator == "xd" then
		X("export DRI_PRIME=1 && exec " .. commandString)

		-- Run command on integrated GPU.
	elseif operator == "xi" then
		X("export DRI_PRIME=0 && exec " .. commandString)

		-- Change the graphics mode.
	elseif operator == "mode" then
		if value == "i" then
			Say(ReadCommand("supergfxctl --mode Integrated"))
		elseif value == "d" then
			Say(ReadCommand("supergfxctl --mode Dedicated"))
		elseif value == "h" then
			Say(ReadCommand("supergfxctl --mode Hybrid"))
		elseif value == "c" then
			Say(ReadCommand("supergfxctl --mode Compute"))
		elseif value == "v" then
			Say(ReadCommand("supergfxctl --mode Vfio"))
		else
			Fault("Invalid GPU mode: " .. value)
		end

	else
		Fault("Invalid graphics operator: " .. operator)
	end
end


--[=[ Network management. ]=]--
Main.Network = function(operator, value)
	if operator == "scan-ip" then
		Say("Scanning IP Address " .. value)
		X("wget https://freegeoip.app/json/" .. value .. " -O /NileRiver/download/ipinfo --no-verbose")
		local IPData = JsonParse(ReadCommand("cat /NileRiver/download/ipinfo"))
		Say("General IP information:")
		for data,val in pairs(IPData) do
			local data2 = tostring(data)
			local val2
			if type(val) == "table" then
				val2 = "N/A"
			else
				val2 = tostring(val)
			end
			if type(data2) == "string" and type(val2) == "string" then
				Say2(data2 .. ": " .. val2)
			end
		end
		X("rm /NileRiver/download/ipinfo")
	elseif operator == "scan-wifi" then
		WifiManager("getlocalnetworks", nil, nil)
	elseif operator == "connect" then
		Say("Please enter the password for " .. value .. ".")
		local password = Read()
		WifiManager("connect", value, password)
	elseif operator == "disconnect" then
		WifiManager("disconnect", nil, nil)
	end
end


--[=[ System software management. ]=]--
Main.Pm = function(operator, packageList, aurmode, promptBypass)

	-- If channel is opms, convert packagelist table to string.
	local packageString
	local packageType
	if packageList then
		if #SplitString(packageList[1], "/") == 2 then -- Check if the package is using the OPMS format (repoName/softwareName)
			packageType = "osiris"
			packageString = packageList[1]
		else
			packageType = "native"
		end
	end

	-- Install a package.
	if operator == "install" then
		if packageType == "osiris" then
			local packagePlacement = GetOsirisPackagePlacement(packageString)

			local doesItPass = false

			Say("Checking current if security level allows for package installation.")
			Say("Current OPMS security level: " .. OpmsSecurityLevel)
			if packagePlacement == "official" then
				Say2("Package is an official package. ")
				doesItPass = true
			elseif packagePlacement == "community" then
				Say2("Package is a community package.")
				if OpmsSecurityLevel ~= "strict" then
					doesItPass = true
				end
			elseif packagePlacement == "global" then
				Say2("Package is a global package.")
				if OpmsSecurityLevel == "none" then
					doesItPass = true
					if promptBypass ~= true then
						Say("You are about to install the global package " .. packageString)
						Say("Global packages are not screened by the Duat. They may contain malware, or other forms of malicious code.")
						Say("INSTALL AT YOUR OWN RISK.")
						Say("Continue anyway? (y/n)")
						if string.lower(Read()) ~= "y" then
							Fault("Package installation aborted.")
							Exit()
						end
						Say("Installation of global package " .. packageString .. " will continue in 10 seconds.")
						Say("You have 10 seconds to quit the program if you do not wish to install this package.")
						local i = 10
						while i >= 1 do
							Say2(i)
							X("sleep 1")
							i = i - 1
						end
						Say("Continuing installation. Rest in piss you won't be missed.")
					end
				end
			end

			if doesItPass == true then
				InstallOsirisPackage(TrimWhite(packageString), promptBypass)
			else
				if packagePlacement == "community" then
					Fault("The package " .. packageString .. " is a community package, and cannot be installed with the \"strict\" security level.")
				elseif packagePlacement == "global" then
					Fault("The package " .. packageString .. " is a global package, and can only be installed when your security level is set to \"none\".")
					Fault("Global packages are considered unsafe, as they are not monitored by the Duat themselves. They may potentially cause damage to the system.")
				end
				Exit()
			end
		elseif packageType == "native" then
			IPkg(packageList, aurmode)
		end

		-- Remove a package.
	elseif operator == "remove" then
		if packageType == "osiris" then
			RemoveOsirisPackage(packageString, promptBypass)
		elseif packageType == "native" then
			RPkg(packageList, aurmode)
		end
	else
		Fault("Invalid software operator: " .. operator)
	end
end


--[=[ System updates ]=]--
Main.Update = function(updateType, dev)

	if updateType == "system" then
		CheckRoot()
		Say("Update the NILE? (y/n)")
		if dev == true then
			Say2("Updating to developer version. Your system may break.")
			Say2("You have been warned.")
		end
		if string.lower(Read()) ~= "y" then
			Fault("NILE System Update aborted.")
			Exit()
		end
		if dev == true then
			X("cd /NileRiver/src && git clone https://github.com/The-Duat/Nile && cd /NileRiver/src/Nile && ./main-installer && rm -rf /NileRiver/src/*")
		else
			Fault("Regular updates are not implemented yet.")
		end

	elseif updateType == "packages" then
		local opackages = GetOsirisPackages()
		Say("Installed OPMS packages:")
		for _,opackage in ipairs(opackages) do
			Say2(opackage)
		end
		Say("Update installed OPMS packages? (y/n)")
		if string.lower(Read()) ~= "y" then
			Fault("OPMS package update aborted.")
			Fault("It is considered dangerous to update the system and not the packages, or vice versa.")
			Exit()
		end
		for _,opackage in ipairs(opackages) do
			local splitName = SplitString(opackage, "_")
			if splitName[1] and splitName[2] then
				UpdateOsirisPackage(TrimWhite(splitName[1] .. "/" .. splitName[2]))
			end
		end
	else
		Fault("Invalid update type: " .. updateType)
	end
end


--[=[ Start i3 ]=]--
Main.Start = function()
	X("startx /NileRiver/core/xinitrc")
end


--[=[ Plugin Management ]=]--
Main.Plugin = function(operator, value, arguments)           
	if operator == "run" then
		if DirExists("/NileRiver/plugins/" .. value) == true then
			dofile("/NileRiver/plugins/" .. value .. "/plugin.lua").main(NileRiver, arguments)
		else
			Fault("The plugin " .. value .. " is not installed.")
		end
	end
end



return Main
