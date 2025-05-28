$pcs = @{
	"PCEC24" = "ALA"
	"PCEC26" = "TKO"
	"PCEC27" = "PKA"
	"PCEC31" = "CET"
	"PCEC32" = "MBI"
	"PCEC33" = "GEI"
	"PCEC38" = "DNA"
	"PCEC39" = "PWA"
	"PCEC41" = "HHA"
	"PCEC42" = "NLO"
	"PCEC43" = "SBA"
	"PCEC44" = "AKL"
	"PCEC47" = "MHA"
	"PCEC48" = "UGE"
	"PCEC51" = "RBA"
	"PCEC52" = "PDE"
	"PCEC54" = "PBR"
	"PCEC56" = "TNA"
	"PCEC57" = "BSC"
	"PCEC58" = "RRE"
	"PCEC59" = "PMI"
	"PCEC60" = "MAL"
	"PCEC61" = "AMO"
	"PCEC62" = "MWO"
	"PCEC63" = "YSC"
	"PCEC64" = "AHA"
	"PCEC65" = "JHO"
	"PCEC66" = "IRI"
	"PCEC68" = "MMI"
	"PCEC69" = "SNI"
	"PCEC70" = "GSI"
	"PCEC71" = "SMO"
	"PCEC72" = "SBR"
	"PCEC73" = "HZO"
	"PCEC74" = "MMA"
	"PCEC75" = "BBE"
	"PCEC76" = "PST"
	"PCEC77" = "FHI"
	"PCEC78" = "W11"
	"PCEC79" = "W11"
	"PCEC80" = "ALA"
	"PCEC81" = "ALA"
	"PCEC112" = "CDE"
	"PCEC113" = "MME"
}

$tpcs = @{
	"PCEC73" = "HZO"
	"PCEC74" = "MMA"
	"PCEC75" = "BBE"
}

$output = @()

foreach ($computer in $pcs.Keys){
	
	if (Test-Connection -ComputerName $computer -Quiet -Count 1){
		#$SN = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject win32_bios | Select-Object SerialNumber} -ErrorAction Ignore
		#$SN = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject win32_processor | Select-Object Name} -ErrorAction Ignore
		#$SN = Invoke-Command -ComputerName $computer -ScriptBlock {Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption} -ErrorAction Ignore
		#$SN = Invoke-Command -ComputerName $computer -ScriptBlock {(Get-WmiObject -Class Win32_computersystem).username} -ErrorAction Ignore
		
		$data = Invoke-Command -ComputerName $computer -ScriptBlock {Get-WmiObject WmiMonitorID -Namespace root\wmi |
		Select-Object @{l="Manufacturer";e={[System.Text.Encoding]::ASCII.GetString($_.ManufacturerName)}},
		@{l="Model";e={[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName)}},
		@{l="SerialNumber";e={[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID)}}
		}
		
		#$pcs.$computer
		#Write-host $computer
		$output += $data
	} else {
		Write-host $computer "not connected"
	}
}

# $output | format-table

$table = New-Object System.Data.DataTable

$column1 = New-Object System.Data.DataColumn("Manufacturer", [string])
$column2 = New-Object System.Data.DataColumn("Model", [string])
$column3 = New-Object System.Data.DataColumn("SerialNumber", [string])
$column4 = New-Object System.Data.DataColumn("Host", [string])
$column5 = New-Object System.Data.DataColumn("User", [string])

$table.Columns.Add($column1)
$table.Columns.Add($column2)
$table.Columns.Add($column3)
$table.Columns.Add($column4)
$table.Columns.Add($column5)

foreach ($monitor in $output){
	$row = $table.NewRow()
	$row.Manufacturer = $monitor.Manufacturer
	$row.Model = $monitor.Model
	$row.SerialNumber = $monitor.SerialNumber
	$row.Host = $monitor.PSComputerName
	$row.User = $pcs.$($monitor.PSComputerName)
	
	$table.Rows.Add($row)
}

return $table

