# Just simply overwrite the previous import-db with an empty copy
# cp .\eaf110120_0001-fresh .\eaf110120_0001

echo $PSScriptRoot

$source = "\_BXT_MP-KIB\"
$source = "\input\"

$ifcPath = Join-Path $PSScriptRoot $source

echo $ifcPath

$ifcs = Get-ChildItem -Path $ifcPath -Filter "*.ifc"

new-item -Path .\ -Name "importStraight.mac" -Force

foreach($ifc in $ifcs)
{
	$name = $ifc.Name.Replace($ifc.Extension, '')
	
	$cleanName = $name.replace(" ", "")
	
	$macName = $cleanName + ".mac"
	
	new-item -Path $ifcPath -Name $macName -Force
	
	(Get-Content .\imptemp.mac ) -replace 'replaceME', $cleanName | Set-Content -Path ($ifcPath + $macName)
	
	$macFile = Get-Item $($ifcPath + $macName)
	
	$macFull = $macFile.FullName
	
	$eLine = "`$M `"" + $macFull + "`""
	
	echo $eLine >> .\importStraight.mac
}

# & "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" --origin Server --setup EundC --softwareid E3D_210 --projectcode EAF --user ECADM --password EUNDC4600 --mdb /E_EC_Import_DBs --macropath D:\IFC\IFC-test\importToProj.mac
