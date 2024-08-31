local Manager = {}



--[=[ Install an Osiris package ]=]--
Manager.InstallOsirisPackage = function(packageName, promptBypass)

	if IsRoot() == false then
		Fault("This action must be ran as root.")
		Exit()
	end

	local nameInfo = SplitString(packageName, "/")
	local developerName = string.lower(TrimWhite(nameInfo[1]))
	local softwareName = string.lower(TrimWhite(nameInfo[2]))

	Xs("rm -rf /var/NileRiver/work/*")
	X(string.format("cd /var/NileRiver/work && sudo git clone https://github.com/%s/%s", developerName, softwareName))

	local s, e = pcall(function()
		local test = dofile(string.format("/var/NileRiver/packages/%s_%s/OpmsPackageInfo.lua", developerName, softwareName))
	end)

	if s then
		Fault("That Opms package is already installed.")
		Exit()
	end


	local packageInfo
	local s, e = pcall(function()
		packageInfo = dofile(string.format("/var/NileRiver/work/%s/OpmsPackageInfo.lua", softwareName))
	end)

	if not s then
		Fault("OPMS Package " .. packageName .. " does not exist.")
		Exit()
	end

	if not packageInfo.OpmsPackage or not packageInfo.PackageType then
		Fault("Broken or misconfigured OPMS package.")
		Exit()
	end

	if promptBypass ~= true then
		Say("Install the OPMS package " .. packageName .. " ? (y/n)")
		if string.lower(Read()) ~= "y" then
			Fault("Package installation aborted.")
			Exit()
		end
	end

	local installType = {
		["theme"] = function()
            if DirExists("/var/NileRiver/themes/" .. packageInfo.ThemeName) == true then
				Fault("A theme by that name is already installed.")
				Exit()
			end
			Xs("mkdir /var/NileRiver/themes/" .. packageInfo.ThemeName)
			Xs(string.format("mv /var/NileRiver/work/%s/theme/* /var/NileRiver/themes/%s/", softwareName, packageInfo.ThemeName))
		end,
		["plugin"] = function()
			if DirExists("/var/NileRiver/plugins/" .. packageInfo.PluginName) == true then
				Fault("A plugin by that name is already installed.")
				Exit()
			end
			Xs("mkdir /var/NileRiver/plugins/" .. packageInfo.PluginName)
			Xs(string.format("mv /var/NileRiver/work/%s/plugin/* /var/NileRiver/plugins/%s/", softwareName, packageInfo.PluginName))
			Xs(string.format("mkdir /var/NileRiver/core/libraries-thirdparty/$s", packageInfo.PluginName))
			Xs(string.format("mv /var/NileRiver/work/%s/libraries/* /var/NileRiver/core/libraries-thirdparty/%s/", softwareName, packageInfo.PluginName))
		end,
		["frontend"] = function()
			if DirExists("/var/NileRiver/core/libraries-thirdparty/" .. packageInfo.FrontendName) == true then
				Fault("A frontend by that name is already installed.")
				Exit()
			end
			Xs("mkdir /var/NileRiver/core/libraries-thirdparty/" .. packageInfo.FrontendName)
			Xs(string.format("mv /var/NileRiver/work/%s/frontend/frontendprogram/%s /usr/bin/", softwareName, packageInfo.FrontendName))
			Xs(string.format("mv /var/NileRiver/work/%s/frontend/frontendlibraries/* /var/NileRiver/core/libraries-thirdparty/%s/", softwareName, packageInfo.FrontendName))
		end
	}

	local s, e = pcall(function() 
		if installType[packageInfo.PackageType] ~= nil then
			installType[packageInfo.PackageType]()
		end
	end)

	if not s then
		Fault("An unexpected error occurred while attempting to install this package.")
		Fault("Error:")
		Fault(e)
		Exit()
	end

	local packageInfoDirectory = string.format("/var/NileRiver/packages/%s_%s", developerName, softwareName)
	Xs("mkdir " .. packageInfoDirectory)
	Xs(string.format("mv /var/NileRiver/work/%s/OpmsPackageInfo.lua %s", softwareName, packageInfoDirectory))
end


--[=[ Remove an Osiris package ]=]--
Manager.RemoveOsirisPackage = function(packageName, promptBypass)
	local nameInfo = SplitString(packageName, "/")
	local developerName = string.lower(TrimWhite(nameInfo[1]))
	local softwareName = string.lower(TrimWhite(nameInfo[2]))
	local packageInfo
	local s, e = pcall(function()
		packageInfo = dofile(string.format("/var/NileRiver/packages/%s_%s", developerName, softwareName))
	end)
	if not s then
		Fault("The given OPMS package is not installed on the system.")
		Exit()
	end

	local PackageType = packageInfo.PackageType

	local uninstallType = {
		["theme"] = function()
			if DirExists("/var/NileRiver/themes/" .. packageInfo.ThemeName) == false then
                Fault("A theme by that name is not installed.")
				Exit()
			end
			Xs(string.format("rm -rf /var/NileRiver/themes/%s", packageInfo.ThemeName))
		end,
		["plugin"] = function()
			if DirExists("/var/NileRiver/plugins/" .. packageInfo.PluginName) == false then
                Fault("A plugin by that name is not installed.")
				Exit()
			end
			Xs(string.format("rm -rf /var/NileRiver/core/libraries-thirdparty/plugin/$s", packageInfo.PluginName))
		end,
		["frontend"] = function()
			if DirExists("/var/NileRiver/core/libraries-thirdparty/" .. packageInfo.FrontendName) == false then
                Fault("A frontend by that name is not installed.")
                Exit()
			end
			Xs("rm /usr/bin/" .. packageInfo.FrontendName)
			Xs("rm -rf /var/NileRiver/core/libraries-thirdparty/" .. packageInfo.FrontendName)
		end
	}
end


--[=[ Update an Osiris Package ]=]--
Manager.UpdateOsirisPackage = function(packageName, promptBypass)
	local nameInfo = SplitString(packageName, "/")
        local developerName = string.lower(TrimWhite(nameInfo[1]))
        local softwareName = string.lower(TrimWhite(nameInfo[2]))
        local packageInfo
        local s, e = pcall(function()
		packageInfo = dofile(string.format("/var/NileRiver/packages/%s_%s", developerName, softwareName))
        end)
        if not s then
                Fault("The given OPMS package is not installed on the system.")
                Exit()
        end
	if promptBypass ~= true then
		Say("Update the OPMS package " .. developerName .. "/" .. softwareName .. " ? (y/n)")
		if string.lower(Read()) ~= "y" then
			Fault("Package uodate for " .. developerName .. "/" .. softwareName .. " aborted.")
		end
	end
	RemoveOsirisPackage(packageName, true)
	InstallOsirisPackage(packageName, true)
end


--[=[ Check installable package's required security level ]=]--
Manager.GetOsirisPackagePlacement = function(packageName)
	Say("Downloading package repo.")
	Xs("rm -rf /var/NileRiver/repo/* && sudo wget https://nile.entertheduat.org/repo.lua -P /var/NileRiver/repo/ --no-verbose")
	local DuatRepo = dofile("/var/NileRiver/repo/repo.lua")

	local packageNameFormatted = string.lower(TrimWhite(packageName))

	if DuatRepo["official"][packageNameFormatted] ~= nil then
		return "official"
	elseif DuatRepo["community"][packageNameFormatted] ~= nil then
		return "community"
	else
		return "global"
	end
end


--[=[ Get list of installed packages ]=]-- 
Manager.GetOsirisPackages = function()
	local packages = {}
	for _,package in pairs(SplitString(ReadCommand("ls /var/NileRiver/packages"))) do
		local pkgNameInfo = SplitString(package, "_")
		table.insert(packages, pkgNameInfo[1] .. "/" .. pkgNameInfo[2])
	end
	return packages
end


--[=[ Get list of packages in the Duat's repo ]=]--
Manager.ListRepo = function()
	Say("Downloading package repo.")
	Xs("rm -rf /var/NileRiver/repo/* && sudo wget https://nile.entertheduat.org/repo.lua -P /var/NileRiver/repo/ --no-verbose")

	local DuatRepo = dofile("/var/NileRiver/repo/repo.lua")

	Say("The Duat's Package Repository")
	Say("Official:")
	for _,package in pairs(DuatRepo.official) do
		Say2(package[1])
	end
	Say("Community:")
	for _,package in pairs(DuatRepo.community) do
		Say2(package[1])
	end
	Say("Due to the nature of \"global\" packages, they cannot be listed.")

end



return Manager
