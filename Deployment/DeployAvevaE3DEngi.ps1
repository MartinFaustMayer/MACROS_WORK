#echo $PSScriptRoot

$msmq = Get-WindowsOptionalFeature -FeatureName MSMQ-Server -Online

if ($msmq.state -ne "Enabled") {
	"Installing MSMQ"
	Enable-WindowsOptionalFeature -FeatureName MSMQ-Server -Online -NoRestart
} else {
	"MSMQ Active"
}

$deployment = '\\eundc\eundcDATA\Install\02_Deployment'

$pcmPath = '\Aveva_Abhaengigkeiten\20250130_PointCloud\InstallPointCloud.ps1'
$e3dPath = '\Aveva_Everything3D\20241213_3.1.5.0\InstallE3D.ps1'
$adminPath = '\Aveva_Administration\20241213_Admin2.1\InstallAdmin.ps1'
$engiPath = '\Aveva_Engineering\20250108_Engi157x64\InstallEngineering.ps1'

$pcm = join-path $deployment $pcmPath
$e3d = join-path $deployment $e3dPath
$admin = join-path $deployment $adminPath
$engi = join-path $deployment $engiPath

$installAdmin = $false
$excl = "!"

$userPrompt = {
	$inputA = (Read-Host 'Install Admin? (Y/N)').ToUpper()
	if ( $inputA -eq "Y" ){
		"YES Admininistration"
		# $installAdmin = $true
		return $true
	} elseif ( $inputA -eq "N" ){
		"NO Admininistration"
		# $installAdmin = $false
		return $false
	} else {
		"Invalid Answer, try again$excl"
		$excl = $excl + $excl
		&$userPrompt
	}	
}

#$installAdmin = &$userPrompt

"###################"
"# Starte Installs #"
"###################"

powershell $e3d

powershell $pcm

#$installAdmin = &$userPrompt
#if ($installAdmin){
#	powershell $admin
#}

powershell $engi

"##################################################################################################"
"# Vor der Admin Installation: Windows Desktop Runtime x64 pruefen! (Es muss Version 6.0.13 sein) #"
"##################################################################################################"
