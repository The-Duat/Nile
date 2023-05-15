local Manager = {}



--[=[ Install mizOS package ]=]--
Manager.installMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = string.lower(trimWhite(nameInfo[1]))
	local softwareName = string.lower(trimWhite(nameInfo[2]))
	local downloadDir = "/var/mizOS/work/" .. softwareName
	local infoDir = "/var/mizOS/packages/" .. developerName .. "_" .. softwareName

	if not developerName and softwareName then
		fault("Invalid package name format.")
		exit()
	end

	say("Clearing work folder.")
	xs("rm -rf /var/mizOS/work/*")

	say("Downloading package.")
	xs("cd /var/mizOS/work && git clone https://github.com/" .. developerName .. "/" .. softwareName)

	say("Validating package.")
	if not dofile(downloadDir .. "/MIZOSPKG.lua") == true then
		fault("That package either doesn't exist, or was not made correctly.")
		exit()
	end
	say2("Package is valid, continuing installation.")

	local packageInfo = dofile(downloadDir .. "/info.lua")

	say("Pacman dependencies:")
	for _,pacmanDep in pairs(packageInfo.pacman_depends) do
		say2(pacmanDep)
	end
	say("AUR dependencies:")
	for _,aurDep in pairs(packageInfo.aur_depends) do
		say2(aurDep)
	end
	say("Install dependencies for " .. packageName .. "? (y/n)")
	if string.lower(read()) == "y" then
		iPkg(packageInfo.pacman_depends, "pacman", true)
		iPkg(packageInfo.aur_depends, "aur", true)
	else
		say("Dependency installation skipped.")
	end

	say("Install " .. packageName .. "? (y/n)")
	if string.lower(read()) ~= "y" then
		fault("Installation aborted.")
		exit()
	end

	xs("mkdir " .. infoDir)
	xs("cp " .. downloadDir .. "/info.lua " .. infoDir)
	xs("chown -R root:root " .. infoDir)
	xs("chmod -R 755 " .. infoDir)
	x("sudo chmod -R 777 " .. downloadDir .." && cd " .. downloadDir .. " && ./install")
end

--[=[ Remove mizOS package ]=]--
Manager.removeMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = string.lower(trimWhite(nameInfo[1]))
	local softwareName = string.lower(trimWhite(nameInfo[2]))
	local infoDir = "/var/mizOS/packages/" .. developerName .. "_" .. softwareName

	if not dofile(infoDir .. "/info.lua").is_present == true then
		fault("That package is not installed.")
		exit()
	end

	say("Remove " .. packageName .. "? (y/n)")
	if string.lower(read()) ~= "y" then
		fault("Package removal aborted.")
		exit()
	end

	local packageInfo = dofile(infoDir .. "/info.lua")

	say("Removing program files.")
	for _,file in pairs(packageInfo.files) do
		say2("Removing " .. file)
		xs("rm " .. file)
	end
	say("Removing program directories.")
	for _,directory in pairs(packageInfo.directories) do
		say2("Removing " .. directory)
		xs("rm -rf " .. directory)
	end

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

--[=[ Update mizOS Package ]=]--
Manager.updateMPackage = function(packageName)
	local nameInfo = splitString(packageName, "/")
	local developerName = trimWhite(nameInfo[1])
	local softwareName = trimWhite(nameInfo[2])
	local downloadDir = "/var/mizOS/work/" .. softwareName
	local infoDir = "/var/mizOS/packages/" .. developerName .. "_" .. softwareName

	say("Updating " .. packageName .. ".")

	say("Clearing work folder.")
	x("rm -rf /var/mizOS/work/*")

	say("Deleting old info directory.")
	xs("rm -rf " .. infoDir)

	say("Downloading package.")
	xs("cd /var/mizOS/work && git clone https://github.com/" .. developerName .. "/" .. softwareName)

	say("Creating new info file.")
	xs("mkdir " .. infoDir)
	xs("cp " .. downloadDir .. "/info.lua " .. infoDir)
	xs("chmod -R 755 " .. infoDir)

	local packageInfo = dofile(downloadDir .. "/info.lua")

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
end

--[=[ Check installable package's required security level ]=]--
Manager.checkPkgSecLevel = function(packageName)
	say("Downloading package repo.")
	xs("rm -rf /var/mizOS/repo/* && wget https://entertheduat.org/packages/repo.lua -P /var/mizOS/repo/")
	local mizOSRepo = dofile("/var/mizOS/repo/repo.lua")

	local packageName = trimWhite(packageName)

	if mizOSRepo["official"][packageName][2] == true then
		return "strict"
	elseif mizOSRepo["community"][packageName][2] == true then
		return "moderate"
	else
		return "none"
	end
end

--[=[ Get list of installed packages ]=]-- 
Manager.listInstalled = function()
	say("Installed mizOS packages:")
	for _,package in pairs(splitString(readCommand("ls /var/mizOS/packages"))) do
		local pkgNameInfo = splitString(package, "_")
		say2(pkgNameInfo[1] .. "/" .. pkgNameInfo[2])
	end
end

--[=[ Get list of packages in the Duat's repo ]=]--
Manager.listRepo = function()
	say("Downloading package repo.")
	xs("rm -rf /var/mizOS/repo/* && wget https://entertheduat.org/packages/repo.lua -P /var/mizOS/repo/")

	

	local mizOSRepo = dofile("/var/mizOS/repo/repo.lua")

	say("The Duat's Package Repository")
	say("Official:")
	for _,package in pairs(mizOSRepo.official) do
		say2(package[1])
	end
	say("Community:")
	for _,package in pairs(mizOSRepo.community) do
		say2(package[1])
	end
	say("Due to the nature of \"global\" packages, they cannot be listed.")

end



return Manager
