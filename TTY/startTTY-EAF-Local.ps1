$launcher = Get-Item "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe"

$n = Get-Item .\nothing.mac
$nothing = $n.Fullname

$arg = @(
	"--origin Local"
	"--setup PROD_EundC-E3D2.1" 
	"--softwareid E3D_210" 
	"--projectcode EAF"
	"--user ECADM" 
	"--password EUNDC4600"
	"--mdb /E_EC_Import_DBs"
	"--macropath $nothing"
)

Start-process $launcher -argumentList $arg
