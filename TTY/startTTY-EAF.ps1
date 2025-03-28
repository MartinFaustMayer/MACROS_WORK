$launcher = Get-Item "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe"

$n = Get-Item .\nothing.mac
$nothing = $n.Fullname

$arg = @(
	"--origin Server"
	"--setup PROD_EundC-E3D3.1" 
	"--softwareid DESI_310" 
	"--projectcode EAF"
	"--user ECADM" 
	"--password EUNDC4600"
	"--mdb /E_EC_Import_DBs"
	"--macropath $nothing"
)

Start-process $launcher -argumentList $arg
