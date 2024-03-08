local pluginManager = {}



--[=[ Execute a Plugin ]=]--
pluginManager.executePlugin = function (pluginName, arguments)
    say("Looking for plugin " .. pluginName)
    local pluginFile
    local success, error = pcall(function()
        pluginFile = dofile("/var/NileRiver/plugins/" .. pluginName .. "/plugin.lua")
    end)
    if success then
        say2("Plugin found. Running.")
        pluginFile.execute(arguments)
    else
        fault("The plugin " .. pluginName .. "is not installed.")
    end
end


--[=[ Install a Plugin ]=]--
pluginManager.installPluginFromFile = function (pathToPlugin)
    x("sudo mv " .. pathToPlugin .. " /var/NileRiver/plugins/")
    x("sudo chown -R root:root /var/NileRiver/plugins")
    x("sudo chmod -R 755 /var/NileRiver/plugins")
end


--[=[ Remove a Plugin ]=]--
pluginManager.removeInstalledPlugin = function (pluginName)
    x("sudo rm -rf /var/NileRiver/plugins/" .. pluginName)
end



return pluginManager