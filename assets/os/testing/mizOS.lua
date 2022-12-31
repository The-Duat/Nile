-- Made by https://theduat.neocities.org


--[=[--[=[--[=[ THIS SCRIPT STORES THE CORE SOURCE CODE OF MIZOS. ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING ]=]--]=]--]=]--



local system = {}





--[=[--[=[ GENERAL PURPOSE FUNCTIONS. ]=]--]=]--





local home = os.getenv("HOME")



--[=[ Command shorteners. ]=]--
local function x(cmd)
	os.execute(cmd)
end

local function ipkg(pkg)
	x("sudo pacman -S " .. pkg)
end

local function ypkg(pkg)
	x("yay -S " .. pkg)
end



---[=[ String split function. ]=]--
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



--[=[ Get shell command output. ]=]--
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



--[=[ Check if file exists. ]=]--
local function checkfile(name)
	local file = io.open(name, "r")
        if file ~= nil then
                io.close(file)
 		return true
	end
end



--[=[ Read file contents. ]=]--
local function readfile(file)
	local contents = ""
	if checkfile(file) == true then
		contents = capture("cat " .. file)
	end
	return contents
end





--[=[--[=[ MIZOS SYSTEM ]=]--]=]--




--[=[ User Interface Data ]=]--
uis = { 
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



--[=[ Configuration file data. ]=]--
conf = {
	{"miz", "/usr/bin/miz", true},
	{"i3", home .. "/.config/i3/config", false},
	{"pacman", "/etc/pacman.conf", true},
	{"xrc", home .. "/.xinitrc", false},
	{"bashrc", home .. "/.bashrc", false}
}



--[=[ Detect init system. ]=]--
local init
if checkfile("/var/mizOS/init/runit") == true then
	init = "runit"
elseif checkfile("/var/mizOS/init/systemd") == true then
	init = "systemd"
elseif checkfile("/var/mizOS/init/openrc") == true then
	init = "openrc"
end



--[=[ https://github.com/Mizosu97/mgpu ]=]--
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





local officialpkgs = {
	"mizosu97/grapejuice"
}


system.config = function(file)
	for _,confile in pairs(conf) do
		if confile[1] == file then
			if checkfile(confile[2]) == true then
				if confile[3] == true then
					x("sudo nvim " .. confile[2])
				else
					x("nvim " .. confile[2])
				end
			else
				return "Config file does not exist."
			end
		end
	end
end



--[=[ mizOS package management. ]=]--
local function package(op, thepkg)
	local pkgsplit
	if thepkg then
		pkgsplit = splitstr(thepkg, "/")
	end
	if pkgsplit[1] and pkgsplit[2] then
		if op == "install" then
			x([[su -c "rm -rf /var/mizOS/work/*" root]])
			x("cd /var/mizOS/work && git clone https://github.com/" .. pkgsplit[1] .. "/" .. pkgsplit[2])
			if checkfile("/var/mizOS/work/" .. pkgsplit[2] .. "/MIZOSPKG") == true then				
				local info = dofile("/var/mizOS/work/" .. pkgsplit[2] .. "/info.lua")
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
				x("mkdir /var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2])
				x("cp /var/mizOS/work/" .. pkgsplit[2] .. "/info.lua /var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/")
				x("cd /var/mizOS/work/" .. pkgsplit[2] .. " && ./install")
			else
				return "error - That package either doesn't exist, or was not made correctly."
			end
		elseif op == "remove" then
			if checkfile("/var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/info.lua") == true then
				local info = dofile("/var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/info.lua")
				for _,file in pairs(info.files) do
					x("sudo rm " .. file)
				end
				for _,folder in pairs(info.directories) do
					x("sudo rm -rf " .. folder)
				end
				local pacpkgs = ""
				local aurpkgs = ""
				for _,pacdep in pairs(info.pacman_depends) do
					pacpkgs = pacpkgs .. pacdep .. " "
				end
				for _,aurdep in pairs(info.aur_depends) do
					aurpkgs = aurpkgs .. aurdep .. " "
				end
				print("Pacman dependencies:\n")
				print(pacpkgs)
				print("\n\nAUR dependencies:\n")
				print(aurpkgs)
				io.write("\n\nRemove dependencies for " .. thepkg .. " ? (y/n)\n\n> ")
				if io.read() == "y" then
					x("sudo pacman -Rn " .. pacpkgs)
					x("yay -Rn " .. aurpkgs)
				end
				x("sudo rm -rf /var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2])
				print(thepkg .. "has been uninstalled.")
			else
				print("[Error] - That package is not installed.")
			end
		elseif op == "update" then
			if checkfile("/var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/info.lua") == true then
				x("rm -rf /var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2])
				x([[su -c "rm -rf /var/mizOS/work/*" root]])
				x("cd /var/mizOS/work && git clone https://github.com/" .. pkgsplit[1] .. "/" .. pkgsplit[2])
				if checkfile("/var/mizOS/work/" .. pkgsplit[2] .. "/MIZOSPKG") == true then				
					local info = dofile("/var/mizOS/work/" .. pkgsplit[2] .. "/info.lua")
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
					x("mkdir /var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2])
					x("cp /var/mizOS/work/" .. pkgsplit[2] .. "/info.lua $HOME/.mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/")
					x("cd /var/mizOS/work/" .. pkgsplit[2] .. " && ./update")
				else
					return "error - That package either doesn't exist, or was not made correctly."
				end
			end
		elseif op == "list" then
			return capture("ls /var/mizOS/packages")
		end
	end
end



--[=[ Software management. ]=]--
system.software = function(op, channel, pkgs)
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
			package("install", packages)
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
			package("remove", packages)
		end
	elseif op == "clear cache" then
		x("yay -Scc")
		if init == "systemd" then
			x("sudo journalctl --vacuum-time=21days")
		else
			return "SystemD not found, unable to clear journal logs."
		end
	elseif op == "list packages" then
		package("list", nil)
	else
		return "[sw] > Command not found!"
	end
end



--[=[ Runit command conversion ]=]--
local function runit(op, service)
	if op == "link" then
                        x("sudo ln -s /etc/runit/sv/" .. arguments[3] .. " /run/runit/service/")
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
			x("ls /etc/runit/sv/")
                elseif service == "linked" then  
			x("ls /run/runit/service/")
                end
	else
		return "[sv_runit] > Command not found!"
        end
end



--[=[ SystemD command conversion. ]=]--
local function systemd(op, service)
	if op == "link" then              
		print("already done")
        elseif op == "unlink" then
                print("brah??")
        elseif op == "disable" then
                x("sudo systemctl disable " .. arguments[3])
        elseif op == "enable" then
                x("sudo systemctl enable " .. arguments[3])
        elseif op == "start" then
                x("sudo systemctl start " .. arguments[3])
        elseif op == "stop" then
                x("sudo systemctl stop " .. arguments[3])
        elseif op == "restart" then
                x("sudo systemctl restart " .. arguments[3])
        elseif op == "list" then
                if service == "installed" then      
			x("systemctl list-units --type=service --all")    
		elseif service == "linked" then                              
			x("systemctl list-units --state=enabled")
                end
	else
		return "[Service_systemd] > Command not found!"
        end
end



--[=[ OpenRC command conversion ]=]--
local function openrc(op, service)
	if op == "link" then       
		print("already done")
        elseif op == "unlink" then
                print("brah??")  
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
                        x("rc-update show")
                elseif service == "linked" then
                        x("rc-update -v show")
                end
	else
		return "[Service_openrc] > Command not found!"
        end
end



--[=[ Service. ]=]--
system.service = function(op, service)
	if init == "runit" then
		runit(op, service)
	elseif init == "systemd" then
		systemd(op, service)
	elseif init == "openrc" then
		openrc(op, service)
	else
		return "[Service] > Init system not supported."
	end
end



--[=[ Graphics stuff. ]=]--
system.gfx = function(op, arguments, mode)
	if op == "xi" or op == "xd" then
                mgpu(op, arguments)
        elseif op == "mode" then 
		if mode == "i" then
                        x("supergfxctl --mode integrated")
                elseif mode == "d" then
                        x("supergfxctl --mode dedicated")
                elseif mode == "h" then
                        x("supergfxctl --mode hybrid")
                elseif mode == "c" then  
			x("supergfxctl --mode compute")
                elseif mode == "v" then
                        x("supergfxctl --mode vfio")
                end
	elseif op == "setup" then
		x("sudo systemctl enable --now power-profiles-daemon.service && sudo systemctl enable --now supergfxd")
	else
		return "[gfx] > Command not found."
        end
end



--[=[ Info ]=]--
system.info = function(op)
	if op == "help" then
                return "https://discord.gg/CzHw7cXKCx"
        elseif op == "source" then
                return "https://github.com/Mizosu97/mizOS"
        elseif op == "creator" then
                return "https://theduat.neocities.org"
        elseif op == "uilist" then
                return uis
	elseif op == "configlist" then
                return conf
	else
		return "neofetch"
	end
end



--[=[ System updater. ]=]--
system.update = function(op)
	if op == "packages" then
		local updatepkgst = capture("ls /var/mizOS/packages")
		local updatepkgs = splitstr(updatepkgst, " ")
		for _,pkg in pairs(updatepkgs) do
			local splitpkg = splitstr(pkg, "_")
			if splitpkg[1] and splitpkg[2] then
				print(splitpkg[1] .. "/" .. splitpkg[2])
				local finalpkg = splitpkg[1] .. "/" .. splitpkg[2]
				package("update", finalpkg)
			end
		end
	elseif op == "system" then
		x("cd /var/mizOS/src && git clone https://github.com/Mizosu97/mizOS")
                x("cd /var/mizOS/src/mizOS && ./install")
        end
end



--[=[ Root ]=]--
system.root = function(command)
	local final = [[su -c "]] .. command .. [[" root]]
	x(final)
end





return system
