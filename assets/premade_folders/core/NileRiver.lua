local NileRiver = {}



NileRiver.initializeIO = function(frontend_IO)
	read  = frontend_IO.inp
	write = frontend_IO.outp
	say   = frontend_IO.foutp
	say2  = frontend_IO.afoutp
	fault = frontend_IO.err
end

local json = dofile("/var/NileRiver/core/libraries/json.lua")
jsonStringify = json.stringify
jsonParse     = json.parse

local GlobalData = dofile("/var/NileRiver/core/libraries/Nile_Global_Data.lua")
userName                 = GlobalData.userName
homeDir                  = GlobalData.homeDir
initSystem               = GlobalData.initSystem
nativePkgManager     = GlobalData.nativePkgManager
packageSecType           = GlobalData.packageSecType
configurablePrograms     = GlobalData.configurablePrograms
i3ConfigSheet            = GlobalData.i3ConfigSheet
gtkConfigSheet           = GlobalData.gtkConfigSheet
systemdCommandSheet      = GlobalData.systemdCommandSheet
runitCommandSheet        = GlobalData.runitCommandSheet
openrcCommandSheet       = GlobalData.openrcCommandSheet
amdGpuDriverPackages     = GlobalData.amdGpuDriverPackages
nvidiaPropDriverPackages = GlobalData.nvidiaPropDriverPackages
nvidiaFossDriverPackages = GlobalData.nvidiaFossDriverPackages
intelDriverPackages      = GlobalData.intelDriverPackages
UITable                  = GlobalData.UITable
integerCharacterSheet    = GlobalData.integerCharacterSheet
hexCharacterSheet        = GlobalData.hexCharacterSheet

local UtilityFunctions = dofile("/var/NileRiver/core/libraries/Nile_Utility_Functions.lua")
x            = UtilityFunctions.x
xs           = UtilityFunctions.xs
xaf          = UtilityFunctions.xaf
runAsRoot    = UtilityFunctions.runAsRoot
readCommand  = UtilityFunctions.readCommand
iPkg         = UtilityFunctions.iPkg
rPkg         = UtilityFunctions.rPkg
sudo         = UtilityFunctions.sudo
checkFile    = UtilityFunctions.checkFile
readFile     = UtilityFunctions.readFile
writeFile    = UtilityFunctions.writeFile
splitString  = UtilityFunctions.splitString
trimWhite    = UtilityFunctions.trimWhite
isInt        = UtilityFunctions.isInt
isHex        = UtilityFunctions.isHex
wifiManager  = UtilityFunctions.wifiManager
writeSetting = UtilityFunctions.writeSetting
checkC       = UtilityFunctions.checkC
iDesktop     = UtilityFunctions.iDesktop
rDesktop     = UtilityFunctions.rDesktop
exit         = UtilityFunctions.exit

local PackageManager = dofile("/var/NileRiver/core/libraries/Nile_OPMS.lua")
installMPackage  = PackageManager.installMPackage
removeMPackage   = PackageManager.removeMPackage
updateMPackage   = PackageManager.updateMPackage
checkPkgSecLevel = PackageManager.checkPkgSecLevel
listInstalled    = PackageManager.listInstalled
listRepo         = PackageManager.listRepo

NileRiver.System = {}

local SystemFunctions = dofile("/var/NileRiver/core/libraries/Nile_System_Functions.lua")
NileRiver.System.info     = SystemFunctions.info
NileRiver.System.config   = SystemFunctions.config
NileRiver.System.csafety  = SystemFunctions.csafety
NileRiver.System.service  = SystemFunctions.service
NileRiver.System.graphics = SystemFunctions.graphics
NileRiver.System.network  = SystemFunctions.network
NileRiver.System.software = SystemFunctions.software
NileRiver.System.update   = SystemFunctions.update
NileRiver.System.start    = SystemFunctions.start



return NileRiver
