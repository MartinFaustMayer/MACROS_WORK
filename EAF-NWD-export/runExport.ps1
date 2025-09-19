$launcher = Get-Item "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe"
$FTR = Get-item "C:\Program Files\Autodesk\Navisworks Manage 2026\FiletoolsTaskRunner.exe"
$date = (Get-Date -Format "yyyyMMdd")
$archName = $date + "_EC_EAF_NWD.ZIP"

& 'C:\Program Files\Autodesk\Navisworks Manage 2026\Roamer.exe' -licensing AdLM

"Mount M: as M"
net use M: \\eundc.local\eundcDATA\CAD\Avev

"Change to current Script-Path"
Push-Location $PSScriptRoot

$launch = $true
#$launch = $false

$copy_to_L = $true
#$copy_to_L = $false

$e = Get-Item .\export.mac
$exportMac = $e.Fullname

$arg = @(
	"--origin Server"
	"--setup PROD_EundC-E3D3.1" 
	"--softwareid DESI_310" 
	"--projectcode EAF"
	"--user ECADM" 
	"--password EUNDC4600"
	"--mdb /A_EC_Spool_Isos"
	"--macropath $exportMac"
)

if ($launch) {
	rm .\RVM\PIPE\* -ErrorAction SilentlyContinue
	rm .\RVM\SUPP\* -ErrorAction SilentlyContinue
	"Launch E3D"
	Start-process $launcher -argumentList $arg -wait
}

$expTypes = @(
	"Piping"
	"Supports"
)

foreach ($type in $expTypes) {
	$navisArg = @(
		[string]::Format("/i {0}\file_{1}.txt", $PSScriptRoot, $type)
		[string]::Format("/of {0}\NWD\{2}_C.PCJ8_Datenaustausch_{1}.nwd", $PSScriptRoot, $type, $date)
		"/version 2022"
	)
	"Launch Convert $type"
	Start-Process $FTR -argumentlist $navisArg -wait
}

Compress-Archive -Path .\NWD\$date* -DestinationPath .\ZIP\$archName -Force

$netName = "https://cloud.eundc.at/remote.php/dav/files/6289DF12-712A-4E4B-8FF7-D920E3EA769E/2024-017_PRI_EAF Voest Linz/034-Datenaustausch _ step%2Cifc%2Cetc/01_E%26C - PRI"
net use L: $netName /user:m.mayer@eundc.at NoMexico2025!

if($copy_to_L)
{
	"Copy Archive to L:"
	copy .\ZIP\$archName L:\
}

"Exit directory"
Pop-Location

"done"
