local Data = {}

Data.userName = os.getenv("USER")

Data.homeDir = os.getenv("HOME")

Data.initSystem = dofile("/var/NileRiver/init/init.lua")

Data.nativePkgManager = dofile("/var/NileRiver/pkgmanager/pm.lua")

Data.packageSecType = dofile("/var/NileRiver/security/active/type.lua")

Data.integerCharacterSheet = "0123456789"

Data.hexCharacterSheet = "0123456789abcdef"

Data.configurablePrograms = {
	["alacritty"] = true,
	["fish"]      = true,
	["gtk"]       = true,
	["i3"]        = true,
	["picom"]     = true,
	["wallpaper"] = true,
	["*"]         = true
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

Data.alacrittyConfigSheet = {
	["bright-black"]         = "hex",
	["bright-blue"]          = "hex",
	["bright-cyan"]          = "hex",
	["bright-green"]         = "hex",
	["bright-magenta"]       = "hex",
	["bright-red"]           = "hex",
	["bright-white"]         = "hex",
	["bright-yellow"]        = "hex",
	["cursor-cursor"]        = "hex",
	["cursor-text"]          = "hex",
	["dim-black"]            = "hex",
	["dim-blue"]             = "hex",
	["dim-cyan"]             = "hex",
	["dim-green"]            = "hex",
	["dim-magenta"]          = "hex",
	["dim-red"]              = "hex",
	["dim-white"]            = "hex",
	["dim-yellow"]           = "hex",
	["footerbar-bg"]         = "hex",
	["footerbar-fg"]         = "hex",
	["hintend-bg"]           = "hex",
	["hintend-fg"]           = "hex",
	["hintstart-bg"]         = "hex",
	["hintstart-fg"]         = "hex",
	["index16"]              = "hex",
	["index17"]              = "hex",
	["normal-black"]         = "hex",
	["normal-blue"]          = "hex",
	["normal-cyan"]          = "hex",
	["normal-green"]         = "hex",
	["normal-magenta"]       = "hex",
	["normal-red"]           = "hex",
	["normal-white"]         = "hex",
	["normal-yellow"]        = "hex",
	["primary-bg"]           = "hex",
	["primary-dimbg"]        = "hex",
	["primary-fg"]           = "hex",
	["primary-dimfg"]        = "hex",
	["search-focusmatch-bg"] = "hex",
	["search-focusmatch-fg"] = "hex",
	["search-matches-bg"]    = "hex",
	["search-matches-fg"]    = "hex",
	["selection-bg"]         = "hex",
	["selection-text"]       = "hex",
	["vicursor-cursor"]      = "hex",
	["vicursor-text"]        = "hex"
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

Data.pmCommandSheet = {
	["pacman"] = {
		["install"] = "sudo pacman -S",
		["remove"] = "sudo pacman -Rn"
	},
	["apt"] = {
		["install"] = "sudo apt install",
		["remove"] = "sudo apt remove"
	},
	["xbps"] = {
		["install"] = "sudo xbps-install -S",
		["remove"] = "sudo xbps-remove -Rf"
	},
	["dnf"] = {
		["install"] = "sudo dnf install",
		["remove"] = "sudo dnf remove"
	},
	["zypper"] = {
		["install"] = "sudo zypper install",
		["remove"] = "sudo zypper remove"
	},
}

return Data
