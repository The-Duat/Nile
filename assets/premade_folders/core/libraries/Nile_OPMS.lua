local Manager = {}



--[=[ Install an Osiris package ]=]--
Manager.installMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = string.lower(trimWhite(nameInfo[1]))
	local softwareName = string.lower(trimWhite(nameInfo[2]))
	local downloadDir = "/var/NileRiver/work/" .. softwareName
	local infoDir = "/var/NileRiver/packages/" .. developerName .. "_" .. softwareName

	if not developerName and softwareName then
		fault("Invalid package name format.")
		exit()
	end

	say("Clearing work folder.")
	xs("rm -rf /var/NileRiver/work/*")

	say("Downloading package.")
	x("cd /var/NileRiver/work && sudo git clone https://github.com/" .. developerName .. "/" .. softwareName)

	local packageInfo = dofile(downloadDir .. "/OPMS_Package_Info.lua")

	say("Validating package.")
	if not packageInfo.exists == true then
		fault("That package either doesn't exist, or was not made correctly.")
		exit()
	end
	say2("Package is valid, continuing installation.")


	say("Installing installation dependencies for " .. developerName .. "/" .. softwareName)
	for _,dep in pairs(packageInfo["Installation Dependencies"].nativePkgManager) do
		say2(dep)
	end
	iPkg(packageInfo["Installation Dependencies"].nativePkgManager)
	say("Needed package dependencies:")
	for _,dep in pairs(packageInfo["Program Dependencies"].nativePkgManager) do
		say2(dep)
	end
	say("Install needed dependencies for " .. packageName .. "? (y/n)")
	if string.lower(read()) == "y" then
		iPkg(packageInfo["Program Dependencies"].nativePkgManager, false)
	else
		say("Dependency installation skipped.")
	end

	say("Install " .. packageName .. "? (y/n)")
	if string.lower(read()) ~= "y" then
		fault("Installation aborted.")
		exit()
	end

	xs("mkdir " .. infoDir)
	xs("cp " .. downloadDir .. "/package.lua " .. infoDir)
	xs("chown -R root:root " .. infoDir)
	xs("chmod -R 755 " .. infoDir)
	xs("chmod -R 777 " .. downloadDir)
	xaf(downloadDir, packageInfo.install)
end

--[=[ Remove an Osiris package ]=]--
Manager.removeMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = string.lower(trimWhite(nameInfo[1]))
	local softwareName = string.lower(trimWhite(nameInfo[2]))
	local infoDir = "/var/NileRiver/packages/" .. developerName .. "_" .. softwareName

	local packageInfo = dofile(infoDir .. "/package.lua")

	if not packageInfo.exists == true then
		fault("That package is not installed.")
		exit()
	end

	say("Remove " .. packageName .. "? (y/n)")
	if string.lower(read()) ~= "y" then
		fault("Package removal aborted.")
		exit()
	end

	say("Running package's uninstallation script.")
	xaf("/tmp", packageInfo.remove)

	say("Pacman dependencies:")
	for _,pacmanDep in pairs(packageInfo.pacman_depends) do
		say2(pacmanDep)
	end
	say("AUR dependencies:")
	for _,aurDep in pairs(packageInfo.aur_depends) do
		say2(aurDep)
	end

	say("Remove dependencies for " .. packageName .. "? (y/n)")
	if string.lower(read()) == "y" then
		rPkg(packageInfo.pacman_depends, "pacman")
		rPkg(packageInfo.aur_depends, "aur")
	end

	say("Removing info directory.")
	xs("rm -rf " .. infoDir)
end

--[=[ Update an Osiris Package ]=]--
Manager.updateMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = trimWhite(nameInfo[1])
	local softwareName = trimWhite(nameInfo[2])
	local downloadDir = "/var/NileRiver/work/" .. softwareName
	local infoDir = "/var/NileRiver/packages/" .. developerName .. "_" .. softwareName

	say("Updating " .. packageName .. ".")

	say("Clearing work folder.")
	xs("rm -rf /var/NileRiver/work/*")

	say("Deleting old info directory.")
	xs("rm -rf " .. infoDir)

	say("Downloading package.")
	x("cd /var/NileRiver/work && sudo git clone https://github.com/" .. developerName .. "/" .. softwareName)

	say("Creating new info file.")
	xs("mkdir " .. infoDir)
	xs("cp " .. downloadDir .. "/info.lua " .. infoDir)
	xs("chmod -R 755 " .. infoDir)

	local packageInfo = dofile(downloadDir .. "/packge.lua")

	say("Pacman dependencies:")
	for _,pacmanDep in pairs(packageInfo.pacman_depends) do
		say2(pacmanDep)
	end
	say("AUR dependencies:")
	for _,aurDep in pairs(packageInfo.aur_depends) do
		say2(pacmanDep)
	end
	say("Autoinstalling dependencies.")
	iPkg(packageInfo.pacman_depends, "pacman")
	iPkg(packageInfo.aur_depends, "aur")

	say("Updating " .. packageName)
	xaf(downloadDir, packageInfo.update)

	x("sudo cp "  .. downloadDir .. "/package.lua" .. infoDir)
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
