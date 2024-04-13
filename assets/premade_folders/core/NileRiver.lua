NileRiver = {}



NileRiver.InitializeIO = function(frontend_IO)
	Read  = frontend_IO.inp
	Write = frontend_IO.outp
	Say   = frontend_IO.foutp
	Say2  = frontend_IO.afoutp
	Fault = frontend_IO.err
end

local Json = dofile("/var/NileRiver/core/libraries/json.lua")
JsonStringify = Json.stringify
JsonParse     = Json.parse

local GlobalData = dofile("/var/NileRiver/core/libraries/Nile_Global_Data.lua")
UserName                 = GlobalData.UserName
HomeDir                  = GlobalData.HomeDir
InitSystem               = GlobalData.InitSystem
NativePkgManager         = GlobalData.NativePkgManager
OpmsSecurityLevel        = GlobalData.PackageSecType
ConfigurablePrograms     = GlobalData.ConfigurablePrograms
I3ConfigSheet            = GlobalData.I3ConfigSheet
AlacrittyConfigSheet     = GlobalData.AlacrittyConfigSheet
GtkConfigSheet           = GlobalData.GtkConfigSheet
SystemdCommandSheet      = GlobalData.SystemdCommandSheet
RunitCommandSheet        = GlobalData.RunitCommandSheet
OpenrcCommandSheet       = GlobalData.OpenrcCommandSheet
IntegerCharacterSheet    = GlobalData.IntegerCharacterSheet
HexCharacterSheet        = GlobalData.HexCharacterSheet
PmCommandSheet           = GlobalData.PmCommandSheet

local UtilityFunctions = dofile("/var/NileRiver/core/libraries/Nile_Utility_Functions.lua")
X            = UtilityFunctions.X
Xs           = UtilityFunctions.Xs
Xaf          = UtilityFunctions.Xaf
RunAsRoot    = UtilityFunctions.RunAsRoot
ReadCommand  = UtilityFunctions.ReadCommand
IPkg         = UtilityFunctions.IPkg
RPkg         = UtilityFunctions.RPkg
CheckFile    = UtilityFunctions.CheckFile
ReadFile     = UtilityFunctions.ReadFile
WriteFile    = UtilityFunctions.WriteFile
SplitString  = UtilityFunctions.SplitString
TrimWhite    = UtilityFunctions.TrimWhite
IsInt        = UtilityFunctions.IsInt
IsHex        = UtilityFunctions.IsHex
WifiManager  = UtilityFunctions.WifiManager
WriteSetting = UtilityFunctions.WriteSetting
ViewSettings = UtilityFunctions.ViewSettings
CheckC       = UtilityFunctions.CheckC
Exit         = UtilityFunctions.Exit

local PackageManager = dofile("/var/NileRiver/core/libraries/Nile_OPMS.lua")
InstallOsirisPackage      = PackageManager.InstallOsirisPackage
RemoveOsirisPackage       = PackageManager.RemovesOsirisPackage
UpdateOsirisPackage       = PackageManager.UpdateOsirisPackage
GetOsirisPackagePlacement = PackageManager.GetOsirisPackagePlacement
ListInstalled             = PackageManager.ListInstalled
ListRepo                  = PackageManager.ListRepo

NileRiver.System = {}

local SystemFunctions = dofile("/var/NileRiver/core/libraries/Nile_System_Functions.lua")
NileRiver.System.Info     = SystemFunctions.Info
NileRiver.System.Config   = SystemFunctions.Config
NileRiver.System.Theme    = SystemFunctions.Theme
NileRiver.System.Service  = SystemFunctions.Service
NileRiver.System.Graphics = SystemFunctions.Graphics
NileRiver.System.Network  = SystemFunctions.Network
NileRiver.System.Software = SystemFunctions.Software
NileRiver.System.Update   = SystemFunctions.Update
NileRiver.System.Start    = SystemFunctions.Start
NileRiver.System.Plugin   = SystemFunctions.Plugin



return NileRiver
