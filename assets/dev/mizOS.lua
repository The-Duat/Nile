-- Made by https://entertheduat.org



--[=[--[=[--[=[ THIS SCRIPT STORES THE CORE SOURCE CODE OF MIZOS. ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING ]=]--]=]--]=]--



--[=[--[=[ MIZOS SETUP ]=]--]=]--


-- Get the home directory.
local home = os.getenv("HOME")

-- Get the init system.
local init = dofile("/var/mizOS/init/init.lua")

-- Input/Output table. Contains functions mizOS uses for Input/Output.
local mio = {}

-- Base mizOS table. Returned by this module.
local mizOS = {
	-- System table, this stores mizOS system functions.
	["system"] = {}
}

local read
local say
local say2
local write
local err
-- Transfer the frontend's IO functions to the mizOS backend.
-- The frontend runs this initialize function, and passes its IO functions stored in a table to it.
-- Different frontends may have different methods for IO.
-- This ensures that mizOS is flexible, and is compatible with all of them.
mizOS.initializeIO = function(givenio)
	read = givenio.inp -- Input
	write = givenio.outp -- Print raw output.
	say = givenio.foutp -- Fancy output, like printing with a newline.
	say2 = givenio.afoutp -- Alternate say, usually with a different design.
	fault = givenio.err -- Error output.
end


--[=[ User Interface Data ]=]--
local uis = { 
	{"budgie", "budgie-desktop", false},
	{"cinnamon", "cinnamon", false},
	{"cutefish", "cutefish", false},
	{"deepin", "deepin", false},
	{"enlightenment", "enlightenment", false},
	{"gnome", "gnome", false},
	{"gnome-flashback", "gnome-flashback", false},
	{"kde", "plasma", false},
	{"lxde", "lxde", false},
	{"lxqt", "lxqt", false},
	{"mate", "mate", false},
	{"sugar", "sugar sugar-fructose", false},
	{"ukui", "ukui", false},
	{"xfce", "xfce4", false},
	{"cde", "cdesktopenv", true},
	{"ede", "ede", true},
	{"kde1", "kde1-kdebase-git", true},
	{"liri", "liri-shell-git", true},
	{"lumina", "lumina-desktop", true},
	{"moksha", "moksha-git", true},
	{"pantheon", "pantheon-session-git", true},
	{"paperde", "paperde", true},
	{"phosh", "phosh", true},
	{"plasma-mobile", "plasma-mobile", true},
	{"thedesk", "thedesk", true},
	{"trinity", "trinity", false},
	{"maui", "maui-shell-git", true},
	{"2bwm", "2bwm", true},
	{"9wm", "9wm", true},
	{"afterstep", "afterstep-git", true},
	{"berry", "berry-git", true},
	{"blackbox", "blackbox", false},
	{"compiz", "compiz", false},
	{"cwm", "cwm", true},
	{"eggwm", "eggwm", true},
	{"evilwm", "evilwm", true},
	{"fluxbox", "fluxbox", false},
	{"flwm", "flwm", true},
	{"fvmm", "fvmm", true},
	{"gala", "gala", false},
	{"goomwwm", "goomwwm", true},
	{"icewm", "icewm", false},
	{"jbwm", "jbwm", true},
	{"jwm", "jwm", false},
	{"karmen", "karmen", true},
	{"kwin", "kwin", false},
	{"lwm", "lwm", false},
	{"marco", "marco", false},
	{"metacity", "metacity", false},
	{"muffin", "muffin", false},
	{"mutter", "mutter", false},
	{"mwm", "openmotif", false},
	{"openbox", "openbox", false},
	{"pawm", "pawm", true},
	{"pekwm", "pekwm", false},
	{"sawfish", "sawfish", true},
	{"sowm", "sowm", true},
	{"tinywm", "tinywm", true},
	{"twm", "xorg-twm", false},
	{"ukwm", "ukwm", false},
	{"uwm", "ude", true},
	{"wind", "windwm", true},
	{"windowlab", "windowlab", true},
	{"windowmaker", "windowmaker", true},
	{"wm2", "wm2", true},
	{"worm", "worm-git", true},
	{"xfwm", "xfwm4", false},
	{"bspwm", "bspwm", false},
	{"exwm", "exwm-git", true},
	{"herbstluftwm", "herbstluftwm", false},
	{"i3", "i3-wm", false},
	{"larswm", "larswm", true},
	{"leftwm", "leftwm", true},
	{"notion", "notion", false},
	{"ratpoison", "ratpoison", false},
	{"stumpwm", "stumpwm", false},
	{"subtle", "subtle-hg", true},
	{"wmfs2", "wmfs2-git", true},
	{"awesome", "awesome", false},
	{"dwm", "dwm", true},
	{"echinus", "echinus", true},
	{"frankenwm", "frankenwm", true},
	{"i3-gaps", "i3-gaps", false},
	{"spectrwm", "spectrwm", false},
	{"sway", "sway", false},
	{"qtile", "qtile", false},
	{"xmonad", "xmonad", false},
	{"hyprland", "hyprland", true}
}



--[=[--[=[ GENERAL PURPOSE FUNCTIONS. ]=]--]=]--


--[=[ Command shorteners. ]=]--
local function x(cmd)	-- Run system command.
	os.execute(cmd)
end

local function ipkg(pkg, noask)  -- Install pacman package.
	local a = ""
	if noask == true then
		a = "--noconfirm"
	end
	x("sudo pacman -S " .. a .. " " .. pkg)
end

local function ypkg(pkg)   -- Install AUR package.
	x("yay -S " .. pkg)
end


--[=[ String Manipulation. ]=]--

-- Split string function.
local function splitstr(ins, sep)
	if sep == nil then
		sep = " "
	end
	local t = {}
	if ins and sep then
		for str in string.gmatch(ins, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
	end
	return t
end

-- Trim whitepsace.
local function trim(s)
	local new = ""
	local i = 0
	local new = ""
	local len = string.len(s)
	while i <= len do
		local sub = string.sub(s, i, i)
		if sub ~= " " then
			new = new .. sub
		end
		i = i + 1
	end
	return new
end

-- Check if string is a hex color code.
local validhexchars = {
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
	["a"] = true,
	["b"] = true,
	["c"] = true,
	["d"] = true,
	["e"] = true,
	["f"] = true
}
local function hexcolorcheck(str)
	local hex = string.lower(str)
	if #hex ~= 6 then
		return false
	end
	local i = 2
	while i <= #hex do
		if not validhexchars[string.sub(hex, i, i)] then
			return false
		end
		i = i + 1
	end
	return true
end

-- Check if string is an "integer". 
local validdigits = {
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true
}
local function intcheck(str)
	if string.sub(str, 1, 1) == "0" then
		return false
	end
	local i = 1
	while i <= #str do
		if not validdigits[string.sub(str, i, i)] == true then
			return false
		end
		i = i + 1
	end
	return true
end


--[=[ File Manipulation ]=]--

--Check if file exists.
local function checkfile(name)
	local file = io.open(name, "r")
	if file ~= nil then
				io.close(file)
		return {true, name}
	else
		return {false, name}
	end
end

-- Read file contents.
local function readfile(file)
	local contents = ""
	if checkfile(file) == true then
		contents = capture("cat " .. file)
	end
	return contents
end

-- Get output of command.
local function capture(cmd, raw)
	local file = assert(io.popen(cmd, 'r'))
	local out = assert(file:read('*a'))
	file:close()
	if raw then return out end
	out = string.gsub(out, '^%s+', '')
	out = string.gsub(out, '%s+$', '')
	out = string.gsub(out, '[\n\r]+', ' ')
	return out
end



--[=[--[=[ MIZOS SYSTEM FUNCTIONS ]=]--]=]--


--[=[ mizOS configuration. ]=]--

-- Generate new i3 config file.
local function geni3conf()
	x("cd /var/mizOS/config/i3 && ./genconf")
end

-- Write a new i3 config setting.
local function wi3config(typ, val)
	x("echo \"" .. val .. "\" > /var/mizOS/config/i3/settings/" .. typ)
	geni3conf()
end


-- i3 configuration functions.
local i3conf = {
	["bar-color"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["bar-position"] = {true, 
		function(op, value)
			if value == "bottom" or value == "top" then
				wi3config(op, value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid position: " .. value)
			end 
		end},
		["border-color1"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["border-color2"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["border-color3"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["border-size"] = {true, 
		function(op, value)
			if intcheck(value) == true then
				wi3config(op, value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["gaps-inner"] = {true, 
		function(op, value)
			if intcheck(value) == true then
				wi3config(op, value)
				say(op .. " changed to " .. value)
			else
				say("Invalid hex color code: " .. value)
			end 
		end},
		["gaps-outer"] = {true, 
		function(op, value)
			if intcheck(value) == true then
				wi3config(op, value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["mod-key"] = {true, 
		function(op, value)
			if value == "Mod1"
			or value == "Mod2"
			or value == "Mod3"
			or value == "Mod4" then
				wi3config(op, value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid mod key: " .. value)
			end
		end},
		["ws-bg-color1"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["ws-bg-color2"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["ws-bg-color3"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["ws-txt-color1"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["ws-txt-color2"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end},
		["ws-txt-color3"] = {true, 
		function(op, value)
			if hexcolorcheck(value) == true then
				wi3config(op, "#" .. value)
				say(op .. " changed to " .. value)
			else
				fault("Invalid hex color code: " .. value)
			end 
		end}
}

-- GTK config
local gtkconf = {
    ["gtk-theme"] = {true,
        function(theme)
        end}
}

-- Config system function.
mizOS.system.config = function(op, value)
	if op == "wallpaper" then  -- Change wallpaper.
		local split = splitstr(value, ".")
		local rawnamesplit = splitstr(value, "/")
		local filetype = split[#split]
		local rawname = rawnamesplit[#rawnamesplit]
		if filetype ~= "png" and filetype ~= "jpg" and filetype ~= "webp" then
			fault("Invalid filetype passed. (Must be .png, .jpg, or .webp)")
		end
		x("rm -rf /var/mizOS/config/wallpaper/*")
		x("cp " .. value .. " /var/mizOS/config/wallpaper/")
		x("mv /var/mizOS/config/wallpaper/" .. rawname .. " /var/mizOS/config/wallpaper/wallpaper." .. filetype)
		x("pkill -fi feh")
		x("feh --bg-fill --zoom fill /var/mizOS/config/wallpaper/wall*")
		say("Wallpaper changed to " .. value)
	elseif op == "pkgsecurity" then  -- Change package security type
		if value == "strict" or value == "moderate" or value == "none" then
			local old = dofile("/var/mizOS/security/active/type.lua")
			x("rm -rf /var/mizOS/security/active/*")
			x("cp /var/mizOS/security/storage/" .. value .. "/type.lua /var/mizOS/security/active")
			say("Package security changed from " .. old .. " to " .. value .. ".")
		else
			fault("Invalid argument: " .. value)
		end
	elseif i3conf[op][1] == true then
		i3conf[op][2](op, value)
	else
		fault("Invalid argument: " .. op)
	end
end


--[=[ System safety. ]=]--

-- System safety system function. (wow, what a mouthful)
mizOS.system.safety = function(op, program)
	local dev = true
	if dev then
		fault("Still in development.")
	end
	if op == "backup" then
		if program == nil then
			x("rm -rf /var/mizOS/backup/*")
			x("cp -r /var/mizOS/config/* /var/mizOS/backup/")
		else
			if dofile("/var/mizOS/config/" .. program .. "/c.lua") == true then
				if dofile("/var/mizOS/backup/" .. program .. "/c.lua") == true then
					x("rm -rf /var/mizOS/backup/" .. program)
				end
				x("cp -r /var/mizOS/config/" .. program .. " /var/mizOS/backup")
			else
				fault("Invalid program: " .. program)
			end
		end
	elseif op == "restore" then
		x("rm -rf /var/mizOS/config/*")
		if program == nil then
			if dofile("/var/mizOS/backup/c.lua") == true then
				x("rm -rf /var/mizOS/config/*")
			end
		end
	end
end


--[=[ mizOS package management. ]=]--

-- mizOS package manager function.
local function package(op, thepkg, noask)
	local pkgsplit
	local dev
	local name
	local insdir
	local pkgdir
	if thepkg then
		pkgsplit = splitstr(thepkg, "/")
		dev = trim(pkgsplit[1])
		name = trim(pkgsplit[2])
		insdir = "/var/mizOS/work/" .. name
		pkgdir = "/var/mizOS/packages/" .. dev .. "_" .. name
	end
	if pkgsplit[1] and pkgsplit[2] then
		if op == "install" then
			x([[su -c "rm -rf /var/mizOS/work/*" root]])
			x("cd /var/mizOS/work && git clone https://github.com/" .. pkgsplit[1] .. "/" .. pkgsplit[2])
			x("ls /var/mizOS/work/" .. pkgsplit[2])
			if dofile(insdir .. "/MIZOSPKG.lua") == true then
				say("Package is valid, continuing installation.")
				local info = dofile(insdir .. "/info.lua")
				local pacpkgs = ""
				local aurpkgs = ""
				say("\npacman dependencies:")
				for _,pacdep in pairs(info.pacman_depends) do
					say2(pacdep)
					pacpkgs = pacpkgs .. pacdep .. " "
				end
				say("\nAUR dependencies:")
				for _,aurdep in pairs(info.aur_depends) do
					say2(aurdep)
					aurpkgs = aurpkgs .. aurdep .. " "
				end
                if not noask then
                    say("Install dependencies for " .. thepkg .. "? (y/n)")
                    if string.lower(read()) == "y" then
                        ipkg(pacpkgs)
                        ypkg(aurpkgs)
                    else
                        say("Dependency installation skipped.")
                    end
                else
                    ipkg(pacpkgs)
                    ypkg(aurpkgs)
                end
                if not noask then
                    say("Continue installation? (y/n)")
                    if not string.lower(read()) == "y" then
                        fault("Installation aborted.")
                        os.exit()
                    end
                end
				x("mkdir " .. pkgdir)
				x("cp " .. insdir .. "/info.lua " .. pkgdir .. "/")
				x("cd " .. insdir .. " && ./install")
			else
				fault("That package either doesn't exist, or was not made correctly.")
			end
		elseif op == "remove" then
			if checkfile(pkgdir .. "/info.lua") == true then
				local info = dofile(pkgdir .. "/info.lua")
				say("Removing program files.")
				for _,file in pairs(info.files) do
					say2("Removing " .. file)
					x("sudo rm " .. file)
				end
				say("Removing program directories.")
				for _,folder in pairs(info.directories) do
					say2("Removing " .. folder)
					x("sudo rm -rf " .. folder)
				end
				local pacpkgs = ""
				local aurpkgs = ""
				say("\npacman dependencies:")
				for _,pacdep in pairs(info.pacman_depends) do
					say2(pacdep)
					pacpkgs = pacpkgs .. pacdep .. " "
				end
				say("AUR dependencies:")
				for _,aurdep in pairs(info.aur_depends) do
					say2(aurdep)
					aurpkgs = aurpkgs .. aurdep .. " "
				end
				if not noask then
                    say("\nRemove dependencies for " .. thepkg .. "? (y/n)")
                    if string.lower(read()) == "y" then
                        x("sudo pacman -Rn " .. pacpkgs)
				        x("yay -Rn " .. aurpkgs)
				        x("sudo rm -rf " .. pkgdir)
                    else
                        say("Dependencies kept.")
                    end
                end
				say(thepkg .. " has been uninstalled.")
			else
				fault("That package is not installed.")
			end
		elseif op == "update" then
			if checkfile(pkgdir .. "/info.lua") == true then
				x("rm -rf " .. pkgdir)
				x([[su -c "rm -rf /var/mizOS/work/*" root]])
				x("cd /var/mizOS/work && git clone https://github.com/" .. dev .. "/" .. name)
				if dofile(insdir .. "/MIZOSPKG.lua") == true then				
					local info = dofile(insdir .. "/info.lua")
					local pacpkgs = ""
					local aurpkgs = ""
					for _,pacdep in pairs(info.pacman_depends) do
						pacpkgs = pacpkgs .. pacdep .. " "
					end
					for _,aurdep in pairs(info.aur_depends) do
						aurpkgs = aurpkgs .. aurdep .. " "
					end
					ipkg(pacpkgs)
					ypkg(aurpkgs)
					x("mkdir " .. pkgdir)
					x("cp " .. insdir .. "/info.lua " .. pkgdir .. "/")
					x("cd " .. insdir .. " && ./update")
				else
					fault("That package either doesn't exist, or was not made correctly.")
				end
			end
		elseif op == "list" then
			say("Installed mizOS packages:")
			for _,i in pairs(splitstr(capture("ls /var/mizOS/packages"), " ")) do
				local split = splitstr(i, "_")
				say2(split[1] .. "/" .. split[2])
			end
		end
	end
end

-- Check mizOS package security level before installing package.
local function firewall(op, thepkg, noask)
	x("rm -rf /var/mizOS/repo/*")
	x("wget https://entertheduat.org/packages/repo.lua -P /var/mizOS/repo/")
	local pkg = trim(thepkg)
	local repo = dofile("/var/mizOS/repo/repo.lua")
	local seclevel = dofile("/var/mizOS/security/active/type.lua")
	if repo["official"][pkg] == true then
		package(op, pkg, noask)
	elseif repo["community"][pkg] == true then
		if seclevel ~= "strict" then
			package(op, pkg, noask)
		else
			fault("Can't install community packages with the \"strict\" security level set.")
		end
	else
		if seclevel == "none" then
			package(op, pkg, noask)
		else
			fault("Can't install global packages with the \"" .. seclevel .. "\" security level set.")
		end
	end
end

-- Software management system function.
mizOS.system.software = function(op, channel, pkgs, noask)
	local packages = ""
	for _,ag in pairs(pkgs) do
		if ag ~= "neofetch" then
			packages = packages .. ag .. " "
		end
	end
	if op == "fetch" then
		if channel == "aur" then
			ypkg(packages)
		elseif channel == "ui" then
			for _,desktop in pairs(uis) do
				if desktop[1] == packages then
					if desktop[3] == false then
						ipkg(desktop[2])  
					elseif desktop[3] == true then
							ypkg(desktop[2])											   
					end 
				end
			end
		elseif channel == "pacman" then
			x("sudo pacman -S " .. packages)
		elseif channel == "mizos" then
			firewall("install", packages)
		end
	elseif op == "remove" then
		if channel == "aur" then
			x("yay -Rn " .. packages)
		elseif channel == "ui" then
			for _,desktop in pairs(uis) do
				if desktop[1] == packages then	
					if desktop[3] == false then
						x("sudo pacman -Rn " .. desktop[2])
				   elseif desktop[3] == true then
						  x("yay -Rn " .. desktop[2])
					end
				end
			end
		elseif channel == "pacman" then
			x("sudo pacman -Rn " .. packages)
		elseif channel == "mizos" then
			firewall("remove", packages)
		end
	elseif op == "clear cache" then
		x("yay -Scc")
		if init == "systemd" then
			x("sudo journalctl --vacuum-time=21days")
		else
			fault("SystemD not found, unable to clear journal logs.")
		end
	elseif op == "list packages" then
		if channel == "mizos" then
			say("Installed mizOS packages:")
			for _,v in pairs(splitstr(package("list", nil), " ")) do
				say2(v)
			end
			package("list", nil, nil)
		elseif channel == "pacman" then
			write(capture("sudo pacman -Qe"))
		elseif channel == "aur" then
			fault("As of right now, AUR packages cannot be listed individually.")
		end
	else
		fault("Command not found!")
	end
end



--[=[ Init System Management ]=]--

-- Runit command conversion.
local function runit(op, service)
	if op == "link" then
		x("sudo ln -s /etc/runit/sv/" .. service .. " /run/runit/service/")
	elseif op == "unlink" then	 
		x("sudo rm /run/runit/service/" .. service)
	elseif op == "disable" then
		x("sudo touch /run/runit/service/" .. service .. "/down")  
	elseif op == "enable" then
		x("sudo rm /run/runit/service/" .. service .. "/down")
	elseif op == "start" then
		x("sudo sv start " .. service)
	elseif op == "stop" then		 
		x("sudo sv stop " .. service)
	elseif op == "restart" then
		x("sudo sv restart " .. service)
	elseif op == "list" then
		if service == "installed" then	 
			say("Installed services:")
			for _,i in pairs(splitstr(capture("ls /etc/runit/sv"), " ")) do
				say2(i)
			end
		elseif service == "linked" then  
			say("Linked services:")
			for _,i in pairs(splitstr(capture("ls /run/runit/service"), " ")) do
				say2(i)
			end
		end
	else
		fault("Command not found!")
		end
end

-- SystemD command conversion.
local function systemd(op, service)
	if op == "link" then			  
		fault("This command is only available for the Runit init system.")
	elseif op == "unlink" then
		fault("This command is only available for the Runit init system.")
	elseif op == "disable" then
		x("sudo systemctl disable " .. service)
	elseif op == "enable" then
		x("sudo systemctl enable " .. service)
	elseif op == "start" then
		x("sudo systemctl start " .. service)
	elseif op == "stop" then
		x("sudo systemctl stop " .. service)
	elseif op == "restart" then
		x("sudo systemctl restart " .. service)
	elseif op == "list" then
		if service == "installed" then		
			write(capture("systemctl list-units --type=service --all"))
		elseif service == "linked" then								 
			write(capture("systemctl list-units --state=enabled"))
		end
	else
		fault("Command not found!")
	end
end

-- OpenRC command conversion.
local function openrc(op, service)
	if op == "link" then	   
		fault("This command is only available for the Runit init system.")
	elseif op == "unlink" then
			fault("This command is only available for the Runit init system.")
	elseif op == "disable" then  
		x("sudo rc-update del " .. service .. " default")  
	elseif op == "enable" then	
		x("sudo rc-update add " .. service .. " default")  
	elseif op == "start" then
		x("sudo rc-service " .. service .. " start")
	elseif op == "stop" then
		x("sudo rc-service " .. service .. " stop")
	elseif op == "restart" then
		x("sudo rc-service " .. service .. " restart")
	elseif op == "list" then
		if service == "installed" then
			write(capture("rc-update show"))
		elseif service == "linked" then
			write(capture("rc-update -v show"))
		end
	else
		fault("Command not found!")
	end
end

-- Service management system function.
mizOS.system.service = function(op, service)
	if init == "runit" then
		runit(op, service)
	elseif init == "systemd" then
		systemd(op, service)
	elseif init == "openrc" then
		openrc(op, service)
	else
		fault("Your init system is not supported.")
	end
end


--[=[ GPU Management ]=]--

-- https://github.com/Mizosu97/mgpu
local function mgpu(gpu, arguments)
	local gcmd = ""
	for _,ag in pairs(arguments) do
		if ag ~= "miz" 
		and ag ~= "/bin/lua" 
		and ag ~= "/usr/bin/miz" 
		and ag ~= "./miz" 
		and ag ~= "xd" 
		and ag ~= "xi" 
		and ag ~= "gfx" then
			gcmd = gcmd .. ag .. " "
		end
	end
	if gpu == "xd" then
		x("export DRI_PRIME=1 && exec " .. gcmd)
	elseif gpu == "xi" then
		x("export DRI_PRIME=0 && exec " .. gcmd)
	end
end

-- GPU management system function
mizOS.system.gfx = function(op, mode, arguments)
	if op == "xi" or op == "xd" then
		x(mgpu(op, arguments))
	elseif op == "mode" then 
		if mode == "i" then
			say(capture("supergfxctl --mode integrated"))
		elseif mode == "d" then
			say(capture("supergfxctl --mode dedicated"))
		elseif mode == "h" then
			say(capture("supergfxctl --mode hybrid"))
		elseif mode == "c" then  
			say(capture("supergfxctl --mode compute"))
		elseif mode == "v" then
			say(capture("supergfxctl --mode vfio"))
		end
	elseif op == "setup" then
		x("sudo systemctl enable --now power-profiles-daemon.service && sudo systemctl enable --now supergfxd")
	else
		fault("Command not found.")
	end
end


--[=[ Display System Information ]=]--

-- System info system function.
mizOS.system.info = function(op)
	if op == "help" then
		say("https://discord.gg/CzHw7cXKCx")
	elseif op == "source" then
		say("https://github.com/Mizosu97/mizOS")
	elseif op == "creator" then
		say("https://theduat.neocities.org")
	elseif op == "uilist" then
        say("Desktop environment/Window manager list:")
		for _,desktop in pairs(uis) do
            local dtype = ""
            if desktop[3] == true then
                dtype = "(AUR)"
            else
                dtype = "(pacman)"
            end
            --say2(desktop[1] .. dtype)
            say2(string.format("%s %-s", desktop[1], dtype))
        end
	else
		fault("Command not found.")
	end
end


--[=[ mizOS System Updating ]=]--

--mizOS system update system function.
mizOS.system.update = function(op, dev)
	if op == "packages" then
		local updatepkgst = capture("ls /var/mizOS/packages")
		local updatepkgs = splitstr(updatepkgst, " ")
		for _,pkg in pairs(updatepkgs) do
			local splitpkg = splitstr(pkg, "_")
			if splitpkg[1] and splitpkg[2] then
				local finalpkg = splitpkg[1] .. "/" .. splitpkg[2]
				package("update", finalpkg)
			end
		end
	elseif op == "system" then
		local devstr = ""
		if dev == true then
			devstr = "dev"
		end
		x("cd /var/mizOS/src && git clone https://github.com/Mizosu97/mizOS && cd /var/mizOS/src/mizOS && ./install " .. devstr .. " && rm -rf /var/mizOS/src/mizOS")
	end
end


--[=[ Root Command Execution ]=]--

-- Root command execution system function.
mizOS.system.root = function(command)
    -- This is not meant to replace sudo.
    -- This is useful when you want a minimal interface, and want the password prompt to show up every time.
	local final = [[su -c "]] .. command .. [[" root]]  -- This uses "su" instead of "sudo"
	x(final)
end



--[=[--[=[ RETURN THE MIZOS TABLE ]=]--]=]--

-- Returns thy fabled table.
return mizOS  -- THY FABLED TABLE.
-- OH MY GOD IT JUST RETURNED THE TABLE!
-- OH MY GOD OH MY GOD OH MY GOD NO WAY
-- As you can see, I am very bored right now.

-- Wow you made it to the end :D
