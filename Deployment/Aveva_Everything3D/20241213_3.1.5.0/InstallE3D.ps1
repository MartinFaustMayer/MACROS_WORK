$installUNC = "\\eundc\eundcDATA\Install\"

"#Erstelle C-Temp"
mkdir C:\temp -erroraction silentlycontinue

"#################"
"# Aveva E3D 3.1 #"
"#################"

#Basispfad für E3D 3.1
$e3d310Inst = join-path $installUNC "02_Deployment\Aveva_Everything3D\20241213_3.1.5.0"

#$ccsPath = join-path $e3d310Inst 'ClientCacheService\ClientCacheService.msi'

"#Installiere Client Cache Service"
$ccsArg = @(
	"/i"
	"`"$(join-path $e3d310Inst '\E3D3.1\E3D 3.1\ClientCacheService\ClientCacheService.msi')`""
	"/qn"
	"/log C:\temp\AvevaInst-ccs.log"
)
start-process msiexec.exe -argumentlist $ccsArg -wait

"#Installiere E3D 3.1"
$e3dArg = @(
	"/i"
	"`"$(join-path $e3d310Inst '\E3D3.1\E3D 3.1\E3D3.10.msi')`""
	"/log C:\temp\AvevaInst-msi.log"
	"DESKTOPSHORTCUTS=0"
	"/qn"
)
start-process msiexec.exe -argumentlist $e3dArg -wait

"#Installiere Fix 05"
$e3dFix = join-path $e3d310Inst '\E3D3.1-FIX\E3D3.1.5.0\E3D3.1.5.0.exe' 
start-process $e3dFix -argumentlist "/Q" -wait

"#Kopiere Hoops"

#$tempHoops = 'C:\temp\temphoops'
#Expand-Archive (join-path $e3d310inst \E3D3.1-Fix\hoops.zip) $tempHoops
#cp -Path (join-path $temphoops \HOOPS) -Destination 'C:\Program Files (x86)\AVEVA\Everything3D3.1\Common\' -Force -Recurse

cp -Path (join-path $e3d310Inst \HOOPS) -Destination 'C:\Program Files (x86)\AVEVA\Everything3D3.1\Common\' -Force -Recurse

"#Installiere TS-Interop"
$tsInteropArg = @(
	"/i"
	"`"$(join-path $e3d310Inst \TeklaStructures-E3D_Interoperability\TeklaStructures-E3D_Interoperability_3.1_17_6_x64.msi)`""
	"/qn"
	"/log C:\temp\AvevaInst-msi.log"
	"INSTALLDIR=C:\AVEVA\TS_E3D"
)
Start-Process  msiexec.exe -ArgumentList $tsInteropArg -wait

"#Kopiere TS-Interop DLL"
$tsInteropDll = "\\eundc.local\eundcdata\CAD\Avev\AVEVA-QA\E3D310\EUC\MACROS\MACROS-NEW-CAFS\CAF\E3D_310\TSE3D\at.eundc.TSEThreeD.dll"
cp -Path $tsInteropDll -Destination "C:\AVEVA\TS_E3D\3.1\TS-E3D_Library\"

"######"
"# oK #"
"######"
