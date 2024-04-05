local NileRiver = dofile("/var/NileRiver/core/NileRiver.lua")

if arg[1] == "installthemepackages" then
    NileRiver.system.software("fetch", {"The-Duat/Nile-Dark-Theme"}, false, true)
end