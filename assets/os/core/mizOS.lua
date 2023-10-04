local mizOS = {}



mizOS.initializeIO = function(frontend_IO)
	read  = frontend_IO.inp
	write = frontend_IO.outp
	say   = frontend_IO.foutp
	say2  = frontend_IO.afoutp
	fault = frontend_IO.err
end

local json = dofile("/var/mizOS/core/libraries/json.lua")
jsonStringify = json.stringify
jsonParse     = json.parse

local GlobalData = dofile("/var/mizOS/core/libraries/mOS_Global_Data.lua")
userName                 = GlobalData.userName
homeDir                  = GlobalData.homeDir
initSystem               = GlobalData.initSystem
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

local UtilityFunctions = dofile("/var/mizOS/core/libraries/mOS_Utility_Functions.lua")
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

local PackageManager = dofile("/var/mizOS/core/libraries/mOS_Package_Manager.lua")
installMPackage  = PackageManager.installMPackage
removeMPackage   = PackageManager.removeMPackage
updateMPackage   = PackageManager.updateMPackage
checkPkgSecLevel = PackageManager.checkPkgSecLevel
listInstalled    = PackageManager.listInstalled
listRepo         = PackageManager.listRepo

mizOS.System = {}

local SystemFunctions = dofile("/var/mizOS/core/libraries/mOS_System_Functions.lua")
mizOS.System.info     = SystemFunctions.info
mizOS.System.config   = SystemFunctions.config
mizOS.System.csafety  = SystemFunctions.csafety
mizOS.System.service  = SystemFunctions.service
mizOS.System.graphics = SystemFunctions.graphics
mizOS.System.network  = SystemFunctions.network
mizOS.System.software = SystemFunctions.software
mizOS.System.update   = SystemFunctions.update



return mizOS
