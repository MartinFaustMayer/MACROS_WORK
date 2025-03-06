$installUNC = "\\eundc\eundcDATA\Install\"

"##############################"
"# Aveva Engineering 15.7.3.2 #"
"##############################"

#Basispfad für Engineering
$engiInst = join-path $installUNC "\02_Deployment\Aveva_Engineering\20250108_Engi157x64"

"#Installiere Engineering"
$engiArg = @(
	"/i"
	"`"$(join-path $engiInst '\Engineering15.7.1x64\Engineering15.7.1.msi')`""
	"/qn"
	"DESKTOPSHORTCUTS=0"
	"/log C:\temp\AvevaInst-msi.log"
)
start-process msiexec.exe $engiArg -wait

"#Installiere Fix 3.2"
$engiFix = join-path $engiInst '\AVEVA Engineering 15.7.3.2\Engineering15.7.3.2.exe' 
start-process $engiFix -argumentlist "/Q" -wait

"######"
"# oK #"
"######"
