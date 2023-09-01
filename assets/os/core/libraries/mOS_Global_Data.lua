local Data = {}

Data.userName = os.getenv("USER")

Data.homeDir = os.getenv("HOME")

Data.initSystem = dofile("/var/mizOS/init/init.lua")

Data.packageSecType = dofile("/var/mizOS/security/active/type.lua")

Data.integerCharacterSheet = "0123456789"

Data.hexCharacterSheet = "0123456789abcdef"

Data.configurablePrograms = {
	["alacritty"] = true,
	["fish"]      = true,
	["gtk"]       = true,
	["i3"]        = true,
	["picom"]     = true,
	["wallpaper"] = true
}

Data.i3ConfigSheet = {
	["bar-color"]     = "hex",
	["bar-position"]  = "special_bar",
	["border-color1"] = "hex",
	["border-color2"] = "hex",
	["border-color3"] = "hex",
	["border-size"]   = "int",
	["gaps-inner"]    = "int",
	["gaps-outer"]    = "int",
	["mod-key"]       = "special_mod",
	["ws-bg-color1"]  = "hex",
	["ws-bg-color2"]  = "hex",
	["ws-bg-color3"]  = "hex",
	["ws-txt-color1"] = "hex",
	["ws-txt-color2"] = "hex",
	["ws-txt-color3"] = "hex"
}

Data.gtkConfigSheet = {
	["gtk-theme"]    = true,
	["icon-theme"]   = true,
	["cursor-theme"] = true
}

Data.systemdCommandSheet = {
	["link"]    = {"runit_only"},
	["unlink"]  = {"runit_only"},
	["disable"] = {"systemctl disable %s"},
	["enable"]  = {"systemctl enable %s"},
	["start"]   = {"systemctl start %s"},
	["stop"]    = {"systemctl stop %s"},
	["restart"] = {"systemctl restart %s"},
	["list"]    = {"special", {
		["installed"] = "systemctl list-units --type=service --all",
		["linked"]    = "systemctl list-units --state=enabled"
	}}
}

Data.runitCommandSheet = {
	["link"]    = {"ln -s /etc/runit/sv/%s /run/runit/service/"},
	["unlink"]  = {"rm /run/runit/service/%s"},
	["disable"] = {"touch /run/runit/service/%s/down"},
	["enable"]  = {"rm /run/runit/service/%s/down"},
	["start"]   = {"sv start %s"},
	["stop"]    = {"sv stop %s"},
	["restart"] = {"sv restart %s"},
	["list"]    = {"special", {
		["installed"] = "ls /etc/runit/sv",
		["linked"]    = "ls /run/runit/service"
	}}
}

Data.openrcCommandSheet = {
	["linked"]  = {"runit_only"},
	["unlink"]  = {"runit_only"},
	["disable"] = {"rc-update del %s default"},
	["enable"]  = {"rc-update add %s default"},
	["start"]   = {"rc-service %s start"},
	["stop"]    = {"rc-service %s stop"},
	["restart"] = {"rc-service %s restart"},
	["list"]    = {"special", {
		["installed"] = "rc-update show",
		["linked"]    = "rc-update -v show"
	}}
}

Data.amdGpuDriverPackages = {
	"amdgpu",
	"mesa",
	"lib32-mesa",
	"xf86-video-amdgpu",
	"vulkan-radeon",
	"lib32-vulkan-radeon",
	"libva-mesa-driver",
	"lib32-libva-mesa-driver",
	"mesa-vdpau",
	"lib32-mesa-vdpau"
}

Data.nvidiaPropDriverPackages = {
	"nvidia",
	"nvidia-utils",
	"lib32-nvidia-utils"
}

Data.nvidiaFossDriverPackages = {
	"noveau",
	"mesa",
	"lib32-mesa"
}

Data.intelDriverPackages = {
	"mesa",
	"lib32-mesa",
	"vulkan-intel",
	"lib32-vulkan-intels"
}

Data.UITable = {
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



return Data
