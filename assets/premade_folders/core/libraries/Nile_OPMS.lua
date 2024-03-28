local Manager = {}



--[=[ Install an Osiris package ]=]--
Manager.installMPackage = function(packageName, promptBypass)
	local nameInfo = splitString(packageName, "/")
	local developerName = string.lower(trimWhite(nameInfo[1]))
	local softwareName = string.lower(trimWhite(nameInfo[2]))

	xs("rm -rf /var/NileRiver/work/*")
	xs(string.format("cd /var/NileRiver/work && git clone https://github.com/%s/%s", developerName, softwareName))

	local s, e = pcall(function()
		local test = dofile(string.format("/var/NileRiver/packages/%s_%s/OpmsPackageInfo.lua", developerName, softwareName))
	end)

	if s then
		fault("That Opms package is already installed.")
		exit()
	end


	local packageInfo
	local s, e = pcall(function()
		packageInfo = dofile(string.format("/var/NileRiver/work/%s/OpmsPackageInfo.lua", softwareName))
	end)

	if not s then
		fault("OPMS Package " .. packageName .. " does not exist.")
		exit()
	end

	if not packageInfo.OpmsPackage or not packageInfo.PackageType then
		fault("Broken or misconfigured OPMS package.")
		exit()
	end

	if promptBypass ~= true then
		say("Install the OPMS package " .. packageName .. " ? (y/n)")
		if string.lower(read()) ~= "y" then
			fault("Package installation aborted.")
			exit()
		end
	end

	local installType = {
		["theme"] = function()
			xs("mkdir /var/NileRiver/themes/" .. packageInfo.ThemeName)
			xs(string.format("mv /var/NileRiver/work/%s/theme/* /var/NileRiver/themes/%s/", packageName, packageInfo.ThemeName))
		end,
		["plugin"] = function()
			xs(string.format("mv /var/NileRiver/work/%s/plugin/PluginLoader.lua /var/NileRiver/work/%s/plugin/%s.lua", softwareName, softwareName, packageInfo.PluginName))
			xs(string.format("mv /var/NileRiver/work/%s/plugin/%s.lua /var/NileRiver/plugins/", softwareName, packageInfo.PluginName))
			xs(string.format("mv /var/NileRiver/work/%s/plugin/libraries/* /var/NileRiver/core/libraries-thirdparty/plugin/", softwareName))
		end,
		["frontend"] = function()
			xs(string.format("mv /var/NileRiver/work/%s/frontend/frontendprogram/* /usr/bin/", softwareName))
			xs(string.format("mv /var/NileRiver/work/%s/frontend/frontendlibraries/* /var/NileRiver/core/libraries-thirdparty/", softwareName))
		end
	}

	local s, e = pcall(function() 
		if installType[packageInfo.PackageType] ~= nil then
			installType[packageInfo.PackageType]()
		end
	end)

	if not s then
		fault("An unexpected error occurred while attempting to install this package.")
		fault("Error:")
		fault(e)
	end

	local packageInfoDirectory = string.format("/var/NileRiver/packages/%s_%s", developerName, softwareName)
	xs("mkdir " .. packageInfoDirectory)
	xs(string.format("mv /var/NileRiver/work/%s/OpmsPackageInfo.lua %s", softwareName, packageInfoDirectory))
end


--[=[ Remove an Osiris package ]=]--
Manager.removeMPackage = function(packageName, promptBypass)
end


--[=[ Update an Osiris Package ]=]--
Manager.updateMPackage = function(packageName, promptBypass)
end


--[=[ Check installable package's required security level ]=]--
Manager.checkPkgSecLevel = function(packageName)
	say("Downloading package repo.")
	xs("rm -rf /var/NileRiver/repo/* && sudo wget https://entertheduat.org/repo.lua -P /var/NileRiver/repo/ --no-verbose")
	local DuatRepo = dofile("/var/NileRiver/repo/repo.lua")

	local packageName = trimWhite(packageName)

	if DuatRepo["official"][packageName] ~= nil then
		return "strict"
	elseif DuatRepo["community"][packageName] ~= nil then
		return "moderate"
	else
		return "none"
	end
end


--[=[ Get list of installed packages ]=]-- 
Manager.listInstalled = function()
	say("Installed Osiris packages:")
	for _,package in pairs(splitString(readCommand("ls /var/NileRiver/packages"))) do
		local pkgNameInfo = splitString(package, "_")
		say2(pkgNameInfo[1] .. "/" .. pkgNameInfo[2])
	end
end


--[=[ Get list of packages in the Duat's repo ]=]--
Manager.listRepo = function()
	say("Downloading package repo.")
	xs("rm -rf /var/NileRiver/repo/* && sudo wget https://entertheduat.org/repo.lua -P /var/NileRiver/repo/ --no-verbose")

	local DuatRepo = dofile("/var/NileRiver/repo/repo.lua")

	say("The Duat's Package Repository")
	say("Official:")
	for _,package in pairs(DuatRepo.official) do
		say2(package[1])
	end
	say("Community:")
	for _,package in pairs(DuatRepo.community) do
		say2(package[1])
	end
	say("Due to the nature of \"global\" packages, they cannot be listed.")

end



return Manager
