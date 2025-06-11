$path = get-item \\eundc\eundcdata\Install\02_Deployment\Aveva_Abhaengigkeiten\20250415_NET5uVCpp

$net564 = Join-Path $path "VC_redist_14-42-34438.x64.exe"
$net586 = Join-Path $path "VC_redist_14-42-34438.x86.exe"
$VCpp64 = Join-Path $path "windowsdesktop-runtime-5.0.17-win-x64.exe"
$VCpp86 = Join-Path $path "windowsdesktop-runtime-5.0.17-win-x86.exe"

Start-Process  $net564 -ArgumentList "/quiet /norestart /Log C:\Temp\VC64.log" -wait
Start-Process  $net586 -ArgumentList "/quiet /norestart /Log C:\Temp\VC86.log" -wait
Start-Process  $VCpp64 -ArgumentList "/quiet /norestart /Log C:\Temp\net564.log" -wait
Start-Process  $VCpp86 -ArgumentList "/quiet /norestart /Log C:\Temp\net586.log" -wait
