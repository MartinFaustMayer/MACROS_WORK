$installUNC = "\\eundc\eundcDATA\Install\"

#$asp = Get-WindowsOptionalFeature -FeatureName IIS-ASPNET45 -Online
#
#if ($asp.state -ne "Enabled") {
#	"Installing IIS-ASPNET45"
#	Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET45 -Online -All -NoRestart
#} else {
#	"IIS-ASPNET45 Active"
#}

"############################"
"# Aveva Administration 2.1 #"
"############################"

#Basispfad für Admin
$adminInst = join-path $installUNC "02_Deployment\Aveva_Administration\20241213_Admin2.1"

"#Installiere MVC 4"
start-process ( join-path $adminInst '\Admin2.1\Administration2.1.0\AspNetMVC4\AspNetMVC4Setup.exe' ) -argumentlist "/install /quiet /norestart /log C:\temp\WINASP.log" -wait

"#Installiere Desktop Runtime"
start-process ( join-path $adminInst '\Admin2.1\Administration2.1.0\DotNet\windowsdesktop-runtime-6.0.13-win-x64.exe' ) -argumentlist "/install /quiet /norestart /log C:\temp\WINRUN.log" -wait

"#Installiere ImDisk"
$imdArg = @(
	"/i"
	"`"$(join-path $adminInst '\Admin2.1\Administration2.1.0\ImDisk\ImDisk3.10.msi')`""
	"/log C:\temp\AvevaInst-imd.log"
	"/qn"
)
start-process msiexec.exe $imdArg -wait

"#Installiere Admin 2.1:"
$adminArg = @(
	"/i"
	"`"$(join-path $adminInst '\Admin2.1\Administration2.1.0\Administration2.1.0.msi')`""
	"/log C:\temp\AvevaInst-msi.log"
	"DESKTOPSHORTCUTS=0"
	"/qn"
)
start-process msiexec.exe -argumentlist $adminArg -wait

"#Installiere Patch 2"
$adminFix = join-path $adminInst '\Admin_patch-2.1.2\Administration2.1.2.0.exe' 
start-process $adminFix -argumentlist "/Q" -wait

"######"
"# oK #"
"######"
