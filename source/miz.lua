instF = arg[1]

if instF == "fetch" then
        local pkgF = arg[2]
	local idF = arg[3]

	if idF == "-v" then
		os.execute("sudo xbps-install -S " .. pkgF)
	elseif idF == "-a" then
		os.execute("sudo pacman -S " .. pkgF)
	elseif idF == "-d" then
		os.execute("sudo apt install " .. pkgF)
	elseif idF == "-u" then
		os.execute("yay -S " .. pkgF)
	end
elseif instF == "remove" then
	local pkgF = arg[2]
	local idF = arg[3]

	if idF == "-v" then
		os.execute("sudo xbps-remove " .. pkgF)
	elseif idF == "-a" then
		os.execute("sudo pacman -R " .. pkgF)
	elseif idF == "-d" then
	        os.execute("sudo apt remove " .. pkgF)
	elseif idF == "-u" then
		os.execute("yay -R " .. pkgF)
	end
elseif instF == "sync" then
	local pkgF = arg[2]
	local idF = arg[3]

	if idF == "-v" then
		print("Void syncs its repos automatically on package installation.")
	elseif idF == "-a" then
		os.execute("sudo pacman -Sy")
	elseif idF == "-d" then
		os.execute("sudo apt update")
	elseif idF == "-u" then
		print("The AUR does not to be synced")
	end
elseif instF == "upgrade" then
	local pkgF = arg[2]
	local idF = arg[3]

	if idF == "-v" then
		os.execute("sudo xbps-install -Su")
	elseif idF == "-a" then
		os.execute("sudo pacman -Syu")
	elseif idF == "-d" then
		os.execute("sudo apt upgrade")
	elseif idF == "-u" then
		os.execute("yay -Syu")
	end
end








