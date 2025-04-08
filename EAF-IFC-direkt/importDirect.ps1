# Just simply overwrite the previous import-db with an empty copy
# cp .\eaf110120_0001-fresh .\eaf110120_0001

#Maximum number of concurrent des.exe:
$maxDes = 5

echo $PSScriptRoot

$source = "\_BXT_MP-KIB\"
$source = "\input\"
$dest = "\output\"

$ifcPath = Join-Path $PSScriptRoot $source
$macPath = Join-Path $PSScriptRoot $dest

echo $ifcPath

$ifcs = Get-ChildItem -Path $ifcPath -Filter "*.ifc"

#new-item -Path .\ -Name "importStraight.mac" -Force

$desCountOld = 0

foreach($ifc in $ifcs)
{
	
	#current File:
	$name = $ifc.Name.Replace($ifc.Extension, '')
	
	#don't allow too many des.exe
	$des = Get-Process -Name des
	$desCount = $des.Length
	
	while($desCount -ge $maxDes)
	{
		$des = Get-Process -Name des
		$desCount = $des.Length
		
		#sleep loop:
		sleep 1
		
		#display current count if changed
		if($desCountOld -ne $desCount)
		{
			Write-Host "Current Number of Designs: " $desCount
			Write-Host "Next in queue: " $name
			$desCountOld = $desCount
		}
	}
	
	
	#prepare IFC:
	$cleanName = $name.replace(" ", "")
	
	$macName = $cleanName + ".mac"
	
	$macFile = Join-Path $macPath $macName
	
	$macFileObj = new-item $macFile -Force
	
	$macFull = $macFileObj.FullName
	
	#write-Host $macFull
	
	(Get-Content .\directImpTemp.mac ) -replace 'replaceME', $name -replace 'replaceRootPath', $PSScriptRoot | Set-Content $macFile
	#(Get-Content .\directImpTemp.mac ) -replace 'replaceRootPath', $PSScriptRoot | Set-Content $macFile
	
	#$eLine = "`$M `"" + $macFull + "`""
	#echo $eLine > .\$macName
	
	$launcher = Get-Item "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe"
	
	$arg = @(
		"--origin Server"
		"--setup PROD_EundC-E3D3.1" 
		"--softwareid DESI_310" 
		"--projectcode EAF"
		"--user ECADM" 
		"--password EUNDC4600"
		"--mdb /E_EC_Import_DBs_11"
		"--macropath $macFull"
	)
	
	$argTest = @(
		"--origin Local"
		"--setup PROD_EundC-E3D3.1" 
		"--softwareid DESI_310" 
		"--projectcode FUG"
		"--user ECADM" 
		"--password EUNDC4600"
		"--mdb /E_EC_Project_DBs"
		"--macropath $macFull"
	)
	
	Write-Host "Start Design, wait 5 seconds"
	
	Start-Process $launcher -ArgumentList $arg
	
	sleep 5
}
