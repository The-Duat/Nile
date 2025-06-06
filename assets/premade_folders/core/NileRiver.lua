NileRiver = {}

Posix = require("posix")

NileRiver.InitializeIO = function(frontend_IO)
	Read  = frontend_IO.inp
	Write = frontend_IO.outp
	Say   = frontend_IO.foutp
	Say2  = frontend_IO.afoutp
	Fault = frontend_IO.err
end

local Json = dofile("/NileRiver/core/libraries-thirdparty/json.lua")
JsonStringify = Json.stringify
JsonParse     = Json.parse

local GlobalData = dofile("/NileRiver/core/libraries/Nile_Global_Data.lua")
UserName                 = GlobalData.UserName
HomeDir                  = GlobalData.HomeDir
InitSystem               = GlobalData.InitSystem
NativePkgManager         = GlobalData.NativePkgManager
OpmsSecurityLevel        = GlobalData.OpmsSecurityLevel
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

local UtilityFunctions = dofile("/NileRiver/core/libraries/Nile_Utility_Functions.lua")
X                 = UtilityFunctions.X
Xs                = UtilityFunctions.Xs
RunAsRoot         = UtilityFunctions.RunAsRoot
ReadCommand       = UtilityFunctions.ReadCommand
IPkg              = UtilityFunctions.IPkg
RPkg              = UtilityFunctions.RPkg
DirExists         = UtilityFunctions.DirExists
CheckFile         = UtilityFunctions.CheckFile
ReadFile          = UtilityFunctions.ReadFile
WriteFile         = UtilityFunctions.WriteFile
Ls                = UtilityFunctions.Ls
SlideDirectory    = UtilityFunctions.SlideDirectory
DownloadFile      = UtilityFunctions.DownloadFile
SplitString       = UtilityFunctions.SplitString
TrimWhite         = UtilityFunctions.TrimWhite
IsInt             = UtilityFunctions.IsInt
IsHex             = UtilityFunctions.IsHex
WifiManager       = UtilityFunctions.WifiManager
GetNativePackages = UtilityFunctions.GetNativePackages
WriteSetting      = UtilityFunctions.WriteSetting
ViewSettings      = UtilityFunctions.ViewSettings
CheckRoot         = UtilityFunctions.CheckRoot
Exit              = UtilityFunctions.Exit

local PackageManager = dofile("/NileRiver/core/libraries/Nile_OPMS.lua")
InstallOsirisPackage      = PackageManager.InstallOsirisPackage
RemoveOsirisPackage       = PackageManager.RemovesOsirisPackage
UpdateOsirisPackage       = PackageManager.UpdateOsirisPackage
GetOsirisPackagePlacement = PackageManager.GetOsirisPackagePlacement
GetOsirisPackages         = PackageManager.GetOsirisPackages
ListRepo                  = PackageManager.ListRepo

NileRiver.Main = {}

local MainFunctions = dofile("/NileRiver/core/libraries/Nile_Main_Functions.lua")
NileRiver.Main.Info     = MainFunctions.Info
NileRiver.Main.Config   = MainFunctions.Config
NileRiver.Main.Theme    = MainFunctions.Theme
NileRiver.Main.Service  = MainFunctions.Service
NileRiver.Main.Graphics = MainFunctions.Graphics
NileRiver.Main.Network  = MainFunctions.Network
NileRiver.Main.Pm       = MainFunctions.Pm
NileRiver.Main.Update   = MainFunctions.Update
NileRiver.Main.Start    = MainFunctions.Start
NileRiver.Main.Plugin   = MainFunctions.Plugin



return NileRiver
