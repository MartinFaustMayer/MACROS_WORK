$input = "\input\"
$output = "\output\"

$inputPath = Join-Path $PSScriptRoot $input
$ifcPath = Join-Path $PSScriptRoot $output

if (-not (test-path $inputPath))
{
	"Input Path Missing, Stopping"
	Return
}

"Import-Export Started:" 
get-date -Format "HH:mm:ss"

mkdir $ifcPath -erroraction silentlycontinue

$ifcs = ls $inputPath -Filter "*.ifc"

#echo $PSScriptRoot

"Macro Path"
$macPath = Join-Path $PSScriptRoot "enter.mac"
#echo $macPath

Get-ChildItem -Path $inputPath -File | Rename-Item -NewName { $_.Name -replace ' ','' }

new-item -Path .\ -Name "todo.mac" -Force

new-item -Path .\ -Name "importToProj.mac" -Force

"Empty out Output"
rm $ifcPath*

foreach($ifc in $ifcs)
{
	$name = $ifc.Name.Replace($ifc.Extension, '')
	
	$cleanName = $name.replace(" ", "")
	
	$macName = $cleanName + ".mac"
	
	new-item -Path $inputPath -Name $macName -Force
	
	(Get-Content .\impexptemp.mac ) -replace 'replaceME', $cleanName | Set-Content -Path ($inputPath + $macName)
	
	$macFile = Get-Item $($inputPath + $macName)
	
	$macFull = $macFile.FullName
	
	$eLine = "`$M `"" + $macFull + "`""
	
	echo $eLine > .\todo.mac
	
	#Import Macro
	
	$mode = "_2x3"
	#$mode = "_4x0"
	
	$pMacName = $cleanName + $mode + ".mac"
	
	$cleanIFC = $cleanName + $mode
	
	$pMacFile = new-item -Path $ifcPath -Name $pMacName -Force
	
	(Get-Content .\imptemp.mac ) -replace 'replaceME', $cleanIFC | Set-Content -Path ($ifcPath + $pMacName)
	
	$pMacFile = Get-Item $($ifcPath + $pMacName)
	
	$pMacFull = $pMacFile.FullName
	
	$peLine = "`$M `"" + $pMacFull + "`""
	
	"Launch E3D!"

	# & "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" --origin Server --setup PROD_EundC-E3D3.1 --softwareid E3D_210 --projectcode EAF --user ECADM --password EUNDC4600 --mdb /E_EC_Project_DBs 
	# --macropath C:\Users\sys-avevaglobal\Desktop\EAF\export.mac
	Start-Process "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" -ArgumentList "--origin Local --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode APS --user SYSTEM --password XXXXXX --mdb /ALL --macropath $macPath" -Wait
	"Waiting for E3D to finish..."
	""

	echo $peLine >> .\importToProj.mac

}

"Import-Export Finished:" 
get-date -Format "HH:mm:ss"
"importToProj.mac ready!"
