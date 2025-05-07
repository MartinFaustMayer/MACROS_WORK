# 240701 - MMA - Script to Upload ZIP of STPs to Nextcloud
# Source: TS-InteropShare
# target: Nextcloud
# requirement: Valid STP-Converter License, E3D & License, LauncherTTY

"Starting automatic Export"

"Change to current Script-Path"
Push-Location $PSScriptRoot
echo $PSScriptRoot

"Mount M: as M"
net use M: \\eundc.local\eundcDATA\CAD\Avev

"Macro Path"
# $macPath = Join-Path $PSScriptRoot "export.mac"
$macPath = Join-Path $PSScriptRoot "eaf-singlepipe.mac"
echo $macPath

$macPath_IFC = Join-Path $PSScriptRoot "eaf-singlepipe_IFC.mac"
echo $macPath_IFC

"RVM Path"
$rvmPath = Resolve-Path '.\RVM\'

"STP temp storage"
$stpPath = Resolve-Path '.\STP\'

$launch = $false
$launch = $true

if ($launch)
{
	"delete files from RVM Path"
	rm $rvmPath* -recurse

	"delete files from temp"
	rm $stpPath* -recurse
	
}

$copy_to_L = $false
$copy_to_L = $true

# $userPath = "M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\USERDATA\RVM-NWD\"
$userPath = $rvmPath

if ($launch)
{
	"Launch E3D"
	#20250303 Update auf "PROD_EundC-E3D2.1" von "EUNDC"
	Start-Process "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" -ArgumentList "--origin Server --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode EAF --user ECADM --password EUNDC4600 --mdb /E_EC_Project_DBs --macropath $macPath" -wait
	# Start-Process "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" -ArgumentList "--origin Server --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode EAF --user ECADM --password EUNDC4600 --mdb /E_EC_Project_DBs --macropath $macPath_IFC" -Wait

	"wait for E3D to finish and continue"
	sleep 1
	while (Get-Process des -ErrorAction SilentlyContinue) {"running"; sleep 1}
	"exited"
} else {
	"skipped E3D"
}


# C:\Unitec\UniConvSTEP_01015001\UniConvSTEP.exe .\Outputs\EQUI_1.stp .\Inputs\EAF-EC-EAF-EQUI.rvm -nowire -all -asm -1 0.0/0.0/0.0 /false

# files to collect and convert
# $siteRVM = Get-Item @(
# 	'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\CPCJ8HS1-F_WRG_Piping_Assy-INSU.rvm'
# )

# old style site RVMs
# $oldSiteRVM = Get-Item @(
# 'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\EAF-EC-EAF-TERR.rvm',
# 'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\EAF-EC-EAF-PIPE.rvm',
# 'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\EAF-EC-EAF-EQUI.rvm',
# 'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\EAF-EC-EAF-STL.rvm'
# 'M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\EAF-EC-EAF-PIPE-INSU.rvm'
# )

#new style single-Pipe-RVMs
# $P1 = ls -Path M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\FULL-MODEL\RVM-NWD\ -Filter 'EC_EAF*-INSU.RVM'
# $P1 = ls -Path M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\USERDATA\RVM-NWD\ -Filter 'EC_EAF*-INSU.RVM'
# $P1 = ls -Path M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\USERDATA\RVM-NWD\ -Filter '*-INSU.RVM'
# $P1 = ls -Path M:\TS-InterOpShare\EAF\01_MEM_OUTPUT\USERDATA\RVM-NWD\ -Recurse -Filter '*-INSU.RVM'

#choose one style:
# $inRVM = $($siteRVM;$P1)
# $inRVM = $P1
# $inRVM = $siteRVM

$inRVM = ls -Path $rvmPath -Recurse -Filter '*.RVM'

"loop all RVM through STP-Converter"
foreach( $rvm in $inRVM )
{
	# copy -Path $rvm -Destination $rvms
	# $crvm = Join-Path $rvms $rvm.split('\')[-1]
	$sdirectory = Join-Path $stpPath $rvm.directoryname.replace($userPath , '')
	# $sdirectory = Join-Path $stpPath $rvm.fullname.replace($userPath , '')
	mkdir $sdirectory -ErrorAction SilentlyContinue
	$stp = Join-Path $stpPath $rvm.fullname.replace($userPath , '').replace('.rvm', '.stp').replace('-INSU.','.')
	# echo File:
	# echo $sdirectory
	# echo $basePath
	# echo $stp
	$fullRVM = $rvm.FullName
	"$fullRVM"
	$command = "C:\Unitec\UniConvSTEP_01015001\UniConvSTEP.exe $stp $fullRVM -nowire -all -asm -1 0.0/0.0/0.0 /false"
	echo $command
	Invoke-Expression $command
	# cmd.exe /C "$command"
}

$archName = (Get-Date -Format 'yyyyMMdd') + "_EC_EAF_STP_IFC.ZIP"

# Compress-Archive -Path .\STP\* -DestinationPath .\Zips\$((Get-Date -Format 'yyMMdd') + "_EC_EAF_STP_IFC.ZIP")
Compress-Archive -Path $stpPath* -DestinationPath .\Zips\$archName -Force

"Mount nextcloud as L:"
# $netName = "https://cloud.eundc.at/remote.php/dav/files/5CF3411F-996C-4FB1-90EF-A02D3F0F8DD3/2024-017_PRI_EAF Voest Linz/034-Datenaustausch _ step%2Cifc%2C.../01_E%26C - PRI"
$netName = "https://cloud.eundc.at/remote.php/dav/files/5CF3411F-996C-4FB1-90EF-A02D3F0F8DD3/2024-017_PRI_EAF Voest Linz/034-Datenaustausch _ step%2Cifc%2Cetc/01_E%26C - PRI"
net use l: $netName /user:h.zoechling@eundc.at Sommer2025!

# sleep 5

#### START Create Copy for Updates ####
mkdir '.\STP\STP-Update' -ErrorAction SilentlyContinue

$wDir = $PSScriptRoot 

$lastUpdateString = Get-Content .\lastUpdate.txt -TotalCount 1
$lUpdate = [DateTime]::ParseExact($lastUpdateString, 'dd.MM.yyyy', $null)

$updated = @()

$mod = Import-Csv -Path .\STP\Moddates.csv -Delimiter ";"

foreach ($line in $mod)
{
	$dString = $line.Modified
	
	$d = [DateTime]::ParseExact($dString, 'dd.MM.yyyy', $null)
	
	if ($d.CompareTo($lUpdate) -ge 0)
	{
		$updated += $line
		$STP = [IO.Path]::Combine($wDir, 'STP\STP', $line.SITE, $line.ZONE, $line.PIPE) + '.stp'
		#$STP
		#Test-Path $STP
		$upDir = [IO.Path]::Combine($wDir, 'STP\STP-Update', $line.SITE, $line.ZONE)
		mkdir $upDir -ErrorAction SilentlyContinue
		copy $STP $upDir -ErrorAction Ignore
	}
	
}

$currentDate = Get-Date -Format 'dd.MM.yyyy' 
Set-Content .\lastUpdate.txt $currentDate

echo 'Export date:' $currentDate 'changes since:' $lastUpdateString 'file Count:' $updated.Count '' >> changes.txt

#### END Create Copy for Updates ####

if($copy_to_L)
{
	"Copy Archive to L:"
	copy .\Zips\$archName L:\
}

"Exit directory"
Pop-Location

"done"
