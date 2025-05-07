$launcher = Get-Item "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe"

$n = Get-Item .\nothing.mac
$nothing = $n.Fullname

$arg = @(
	"--origin Local"
	"--setup PROD_EundC-E3D3.1" 
	"--softwareid DESI_310" 
	"--projectcode AAE"
	"--user ECADM" 
	"--password EUNDC4600"
	"--mdb /A_AAE_Kocherei"
	"--macropath $nothing"
)

Start-process $launcher -argumentList $arg
