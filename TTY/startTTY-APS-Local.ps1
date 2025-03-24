$n = Get-Item .\nothing.mac
$nothing = $n.Fullname
& "C:\Program Files (x86)\EuC\Launcher 2.0\TTY\LauncherTTY.exe" --origin Local --setup PROD_EundC-E3D3.1 --softwareid DESI_310 --projectcode APS --user SYSTEM --password XXXXXX --mdb /ALL --macropath $nothing