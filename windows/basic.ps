# Collect system information
$hostname = $env:COMPUTERNAME
$os = Get-CimInstance Win32_OperatingSystem
$osName = $os.Caption
$osVersion = $os.Version
$processor = Get-CimInstance Win32_Processor
$processorName = $processor.Name
$processorCores = $processor.NumberOfCores
$memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$memoryCapacity = $memory.Sum / 1GB

# Collect user account information
$users = Get-LocalUser

# Collect network share information
$shares = Get-SmbShare

# Collect running process information
$processes = Get-Process

# Collect installed software information
$software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*

# Collect open port information
$ports = Get-NetTCPConnection | Where-Object {$_.State -eq 'Listen'}

# Display collected information
Write-Host "System Information"
Write-Host "Hostname: $hostname"
Write-Host "Operating System: $osName ($osVersion)"
Write-Host "Processor: $processorName ($processorCores cores)"
Write-Host "Memory: $memoryCapacity GB"
Write-Host ""
Write-Host "User Accounts"
$users | Format-Table -AutoSize
Write-Host ""
Write-Host "Network Shares"
$shares | Format-Table -AutoSize
Write-Host ""
Write-Host "Running Processes"
$processes | Format-Table -AutoSize
Write-Host ""
Write-Host "Installed Software"
$software | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize
Write-Host ""
Write-Host "Open Ports"
$ports | Select-Object LocalAddress, LocalPort | Format-Table -AutoSize
