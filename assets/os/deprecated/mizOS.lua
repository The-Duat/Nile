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



--[=[ Preset list of Desktop Environments and Window Managers. ]=]--


local officialpkgs = {
	"mizosu97/grapejuice"
}

local function getuilist()
	print("List of DEs and WMs:")
	print(" ")
	for _,desktop in pairs(uis) do
                local name
                if desktop[3] == false then
                        name = desktop[1] .. "   (pacman)"
                elseif desktop[3] == true then
                        name = desktop[1] .. "   (AUR)"
                end
                print(name)
        end
end



--[=[ Configuration file editor. ]=]--


local function getconflist()
	print("List of available config files:")
	print(" ")
	for _,confile in pairs(conf) do
		local name
		if checkfile(confile[2]) == true then
			if confile[3] == true then
				name = confile[1] .. "   (Requires root)"
			else
				name = confile[1]
			end
			print(name)
		end
	end
end

system.config = function(arguments)
	for _,confile in pairs(conf) do
		if confile[1] == arguments[2] then
			if checkfile(confile[2]) == true then
				if confile[3] == true then
					x("sudo nvim " .. confile[2])
				else
					x("nvim " .. confile[2])
				end
			else
				print("Config file does not exist.")
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
			io.write("\nInstall " .. pkgsplit[2] .. " by " .. pkgsplit[1] .. "? (y/n)\n\n> ")
			if io.read() == "y" then
				if string.lower(pkgsplit[1]) ~= "mizosu97" then
					io.write("\n\n\nTHIS IS NOT AN OFFICIAL mizOS PACKAGE!!!\n\nThis package contains code not moderated by the mizOS developers.\n\nThis package may cause harm to your system.\n\nIf you want to install this package, type < Yes, do as I say! > \n\n> ")
					if io.read() ~= "Yes, do as I say!" then
						return
					end
				end
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
					print("[Error] - That package either doesn't exist, or was not made correctly.")
				end
			end
		elseif op == "remove" then
			io.write("\nRemove " .. pkgsplit[2] .. " by " .. pkgsplit[1] .. "? (y/n)\n\n> ")
			if io.read() == "y" then
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
			end
		elseif op == "update" then
			if checkfile("/var/mizOS/packages/" .. pkgsplit[1] .. "_" .. pkgsplit[2] .. "/info.lua") == true then
				io.write("\nUpdate " .. pkgsplit[2] .. " by " .. pkgsplit[1] .. "? (y/n)\n\n> ")
				if io.read() == "y" then
					if string.lower(pkgsplit[1]) ~= "mizosu97" then
						io.write([[\n\n\nTHIS IS NOT AN OFFICIAL mizOS PACKAGE!!!\n\nThis package contains code not moderated by the mizOS developers.\n\nThis package may cause harm to your system.\n\nIf you want to install this package, type "Yes, do as I say!"\n\n> ]])
						if io.read() ~= "Yes, do as I say!" then
							return
						end
					end
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
						print("[Error] - That package either doesn't exist, or was not made correctly.")
					end
				end
			end
		elseif op == "list" then
			x("ls /var/mizOS/packages")
		end
	end
end



--[=[ Software management. ]=]--
system.software = function(arguments)
	local packages = ""
	for _,ag in pairs(arguments) do
		if ag ~= "miz" 
		and ag ~= "/bin/lua" 
		and ag ~= "/usr/bin/miz" 
		and ag ~= "./miz"  
		and ag ~= "fetch" 
		and ag ~= "update" 
		and ag ~= "remove" 
		and ag ~= "-p" 
		and ag ~= "-u" 
		and ag ~= "-a" 
		and ag ~= "neofetch" then
			packages = packages .. ag .. " "
		end
	end
	if arguments[1] == "fetch" then
		if arguments[2] == "-a" then
			ypkg(packages)
		elseif arguments[2] == "-c" then
			print("not implemented yet")
		elseif arguments[2] == "-u" then
			for _,desktop in pairs(uis) do
                        	if desktop[1] == arguments[3] then                                                 
					if desktop[3] == false then
                                        	ipkg(desktop[2])
                                	elseif desktop[3] == true then
                                        	ypkg(desktop[2])                                               
					end
                       		end
                	end
		elseif arguments[2] == "-p" then
			x("sudo pacman -S " .. packages)
		else
			package("install", arguments[2])
		end
	elseif arguments[1] == "remove" then
		if arguments[2] == "-a" then
			x("yay -Rn " .. packages)
		elseif arguments[2] == "-u" then
			for _,desktop in pairs(uis) do
                                if desktop[1] == arguments[3] then  
					if desktop[3] == false then
						x("sudo pacman -Rn " .. desktop[2])
                                        elseif desktop[3] == true then
                                                x("yay -Rn " .. desktop[2])

                                        end
                                end
                        end
		elseif arguments[2] == "-p" then
			x("sudo pacman -Rn " .. packages)
		else
			package("remove", arguments[2])
		end
	elseif arguments[1] == "cc" then
		x("yay -Scc")
		if init == "systemd" then
			x("sudo journalctl --vacuum-time=21days")
		else
			print("SystemD not found, unable to clear journal logs.")
		end
	elseif arguments[1] == "lspkgs" then
		package("list", nil)
	else
		print("[sw] > Command not found!")
	end
end



--[=[ Runit command conversion ]=]--
local function runit(arguments)
	if arguments[2] == "link" then
                        x("sudo ln -s /etc/runit/sv/" .. arguments[3] .. " /run/runit/service/")
        elseif arguments[2] == "unlink" then   
		x("sudo rm /run/runit/service/" .. arguments[3])   
	elseif arguments[2] == "disable" then
		x("sudo touch /run/runit/service/" .. arguments[3] .. "/down")  
	elseif arguments[2] == "enable" then
                x("sudo rm /run/runit/service/" .. arguments[3] .. "/down")
        elseif arguments[2] == "start" then
                x("sudo sv start " .. arguments[3])
        elseif arguments[2] == "stop" then         
		x("sudo sv stop " .. arguments[3])
        elseif arguments[2] == "restart" then
                x("sudo sv restart " .. arguments[3])
        elseif arguments[2] == "list" then
                if arguments[3] == "installed" then   
			x("ls /etc/runit/sv/")
                elseif arguments[3] == "linked" then  
			x("ls /run/runit/service/")
                end
	else
		print("[sv_runit] > Command not found!")
        end
end



--[=[ SystemD command conversion. ]=]--
local function systemd(arguments)
	if arguments[2] == "link" then              
		print("already done")
        elseif arguments[2] == "unlink" then
                print("brah??")
        elseif arguments[2] == "disable" then
                x("sudo systemctl disable " .. arguments[3])
        elseif arguments[2] == "enable" then
                x("sudo systemctl enable " .. arguments[3])
        elseif arguments[2] == "start" then
                x("sudo systemctl start " .. arguments[3])
        elseif arguments[2] == "stop" then
                x("sudo systemctl stop " .. arguments[3])
        elseif arguments[2] == "restart" then
                x("sudo systemctl restart " .. arguments[3])
        elseif arguments[2] == "list" then
                if arguments[3] == "installed" then      
			x("systemctl list-units --type=service --all")    
		elseif arguments[3] == "linked" then                              
			x("systemctl list-units --state=enabled")
                end
	else
		print("[sv_systemd] > Command not found!")
        end
end



--[=[ OpenRC command conversion ]=]--
local function openrc(arguments)
	if arguments[2] == "link" then       
		print("already done")
        elseif arguments[2] == "unlink" then
                print("brah??")  
	elseif arguments[2] == "disable" then  
		x("sudo rc-update del " .. arguments[3] .. " default")  
	elseif arguments[2] == "enable" then  
		x("sudo rc-update add " .. arguments[3] .. " default")  
	elseif arguments[2] == "start" then
                x("sudo rc-service " .. arguments[3] .. " start")
        elseif arguments[2] == "stop" then
                x("sudo rc-service " .. arguments[3] .. " stop")
        elseif arguments[2] == "restart" then
                x("sudo rc-service " .. arguments[3] .. " restart")
        elseif arguments[2] == "list" then
                if arguments[3] == "installed" then
                        x("rc-update show")
                elseif arguments[3] == "linked" then
                        x("rc-update -v show")
                end
	else
		print("[sv_openrc] > Command not found!")
        end
end



--[=[ Service. ]=]--
system.service = function(arguments)
	if init == "runit" then
		runit(arguments)
	elseif init == "systemd" then
		systemd(arguments)
	elseif init == "openrc" then
		openrc(arguments)
	else
		print("Your init system is not supported.")
	end
end



--[=[ Graphics stuff. ]=]--
system.gfx = function(arguments)
	if arguments[2] == "xi" or arguments[2] == "xd" then
                mgpu(arguments[2], arguments)
        elseif arguments[2] == "mode" then 
		if arguments[3] == "i" then
                        x("supergfxctl --mode integrated")
                elseif arguments[3] == "d" then
                        x("supergfxctl --mode dedicated")
                elseif arguments[3] == "h" then
                        x("supergfxctl --mode hybrid")
                elseif arguments[3] == "c" then  
			x("supergfxctl --mode compute")
                elseif arguments[3] == "v" then
                        x("supergfxctl --mode vfio")
                end
	elseif arguments[2] == "setup" then
		x("sudo systemctl enable --now power-profiles-daemon.service && sudo systemctl enable --now supergfxd")
	else
		print("[gfx] > Command not found!")
        end
end



--[=[ Info ]=]--
system.info = function(arguments)
	if arguments[2] == "help" then
                print(" ")
                print("https://discord.gg/CzHw7cXKCx")
                print(" ")
        elseif arguments[2] == "source" then
		print(" ")
                print("https://github.com/Mizosu97/mizOS")
        elseif arguments[2] == "creator" then
                print(" ")
                print("https://theduat.neocities.org")
		print(" ")
        elseif arguments[2] == "uilist" then
                getuilist()
	elseif arguments[2] == "configlist" then
                getconflist()
	else
		x("neofetch")
	end
end



--[=[ System updater. ]=]--
system.update = function()
	io.write("Update mizOS? y/n \n\n> ")
        if io.read() == "y" then
                print("Updating mizOS packages.")
		local updatepkgst = capture("ls /var/mizOS/packages")
		local updatepkgs = splitstr(updatepkgst, " ")
		print("\n Updating mizOS packages: \n")
		for _,pkg in pairs(updatepkgs) do
			local splitpkg = splitstr(pkg, "_")
			if splitpkg[1] and splitpkg[2] then
				print(splitpkg[1] .. "/" .. splitpkg[2])
				local finalpkg = splitpkg[1] .. "/" .. splitpkg[2]
				package("update", finalpkg)
			end
		end
		print("Downloading mizOS source code.")
		x("cd /var/mizOS/src && git clone https://github.com/Mizosu97/mizOS")
		print("Performing system update.")
                x("cd /var/mizOS/src/mizOS && ./install")
        end
end



--[=[ Root ]=]--
system.root = function(arguments)
	local cmd = ""
	for _,ag in pairs(arguments) do
		if ag ~= "./miz"
		and ag ~= "/bin/lua"
		and ag ~= arguments[0] then
			cmd = cmd .. ag .. " "
		end
	end
	local final = [[su -c "]] .. cmd .. [[" root]]
	x(final)
end





return system
