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
	if dofile(infoDir .. "/info.lua").is_present == true then
		fault("Package is already installed.")
		exit()
	end

	say("Clearing work folder.")
	x("rm -rf /var/mizOS/work/*")

	say("Downloading package.")
	x("cd /var/mizOS/work && git clone https://github.com/" .. developerName .. "/" .. softwareName)

	say("Validating package.")
	if not dofile(downloadDir .. "/MIZOSPKG.lua") == true then
		fault("That package either doesn't exist, or was not made correctly.")
		exit()
	end
	say2("Package is valid, continuing installation.")

	local packageInfo = dofile(downloadDir .. "/info.lua")

	say("\nPacman dependencies:")
	for _,pacmanDep in pairs(packageInfo.pacman_depends) do
		say2(pacmanDep)
	end
	say("\nAUR dependencies:")
	for _,aurDep in pairs(packageInfo.aur_depends) do
		say2(aurDep)
	end
	say("Install dependencies for " .. packageName .. "? (y/n)")
	if string.lower(read()) == "y" then
		iPkg(packageInfo.pacman_depends, "pacman")
		iPkg(packageInfo.aur_depends, "aur")
	else
		say("Dependency installation skipped.")
	end

	say("\nInstall " .. packageName .. "? (y/n)")
	if not string.lower(read()) == "y" then
		fault("Installation aborted.")
		exit()
	end

	x("mkdir " .. infoDir)
	x("cp " .. downloadDir .. "/info.lua " .. infoDir)
	x("cd " .. downloadDir .. " && ./install")
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
	if not string.lower(read()) == "y" then
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

	say("\nPacman dependencies:")
	for _,pacmanDep in pairs(packageInfo.pacman_depends) do
		say2(pacmanDep)
	end
	say("\nAUR dependencies:")
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
	local nameInfo = splitString3(packageName, "/")
	local developerName = trimWhite(nameInfo[1])
	local softwareName = trimWhite(nameInfo[2])
	local downloadDir = "/var/mizOS/work/" .. softwareName
	local infoDir = "/var/mizOS/packages/" .. developerName .. "_" .. softwareName

	if not dofile(infoDir .. "/info.lua").is_present == true then
		fault("That package is not installed.")
		exit()
	end

	say("Updating " .. packageName .. ".")

	say("Clearing work folder.")
	x("rm -rf /var/mizOS/work/*")

	say("Deleting old info directory.")
	xs("rm -rf " .. infoDir)

	say("Downloading package.")
	x("cd /var/mizOS/work && git clone https://github.com/" .. developerName .. "/" .. softwareName)
end



return Manager
