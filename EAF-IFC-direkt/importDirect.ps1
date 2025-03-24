# Just simply overwrite the previous import-db with an empty copy
# cp .\eaf110120_0001-fresh .\eaf110120_0001

echo $PSScriptRoot

$source = "\_BXT_MP-KIB\"
$source = "\input\"
$dest = "\output\"

$ifcPath = Join-Path $PSScriptRoot $source
$macPath = Join-Path $PSScriptRoot $dest

echo $ifcPath

$ifcs = Get-ChildItem -Path $ifcPath -Filter "*.ifc"

#new-item -Path .\ -Name "importStraight.mac" -Force

foreach($ifc in $ifcs)
{
	$name = $ifc.Name.Replace($ifc.Extension, '')
	
	$cleanName = $name.replace(" ", "")
	
	$macName = $cleanName + ".mac"
	
	$macFile = Join-Path $macPath $macName
	
	$macFileObj = new-item $macFile -Force
	
	$macFull = $macFileObj.FullName
	
	#write-Host $macFull
	
	(Get-Content .\directImpTemp.mac ) -replace 'replaceME', $name | Set-Content $macFile
	
	#$eLine = "`$M `"" + $macFull + "`""
	#echo $eLine > .\$macName
	
	#Start-Process "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" -ArgumentList "--origin Server --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode EAF --user ECADM --password EUNDC4600 --mdb /E_EC_Import_DBs --macropath $macFull"
	Start-Process "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" -ArgumentList "--origin Local --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode FUG --user ECADM --password EUNDC4600 --mdb /E_EC_Project_DBs --macropath $macFull"
	
}
