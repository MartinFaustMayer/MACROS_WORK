$installUNC = "\\eundc\eundcDATA\Install\"

$deployment = join-path $installUNC '\02_Deployment'

$depPath = join-path $deployment '\Aveva_Abhaengigkeiten\20250130_PointCloud'

"#######################"
"# Point Cloud Manager #"
"#######################"

"#Installiere Desktop Runtime"
start-process ( join-path $depPath 'windowsdesktop-runtime-6.0.25-win-x86.exe' ) -argumentlist "/install /quiet /norestart /log C:\temp\WINRUN.log" -wait

"#Installiere Dotnet 5.0.17"
start-process ( join-path $depPath 'dotnet-runtime-5.0.17-win-x86.exe' ) -argumentlist "/install /quiet /norestart /log C:\temp\DOTNET.log" -wait
#"\\eundc\eundcdata\Install\02_Deployment> .\Aveva_Abhaengigkeiten\20250130_PointCloud\dotnet-runtime-5.0.17-win-x86.exe /install /quiet /log C:\temp\DOTNET.log"

"#Installiere Point Cloud Manager"
start-process ( join-path $depPath 'AVEVA Point Cloud ManagerSetup.5.7.0.1.exe' ) -argumentlist "/VERYSILENT /NORESTART /NOCLOSEAPPLICATIONS /NOICONS /log=C:\temp\PCM.log" -wait

"#Loesche Symbol"
$publicPath = $env:public
rm -path "$publicPath\desktop\AVEVA Point Cloud Manager.lnk"

"######"
"# oK #"
"######"
