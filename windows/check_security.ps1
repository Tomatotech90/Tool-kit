# Check for Misconfigured Permissions and Security Controls PowerShell Script

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the target domain
$domain = "contoso.local"

# Define the target OU
$ou = "OU=Servers,DC=contoso,DC=local"

# Define the target groups
$admin_group = "Domain Admins"
$backup_group = "Backup Operators"

# Get a list of all servers in the target OU
$servers = Get-ADComputer -Filter {OperatingSystem -like "*server*"} -SearchBase $ou

# Loop through each server
foreach ($server in $servers) {

    # Define the target server
    $target = $server.Name

    # Check if the current user is a member of the admin group
    $is_admin = (Get-ADGroupMember -Identity $admin_group -Recursive | Select-Object -ExpandProperty SamAccountName) -contains $env:USERNAME

    # Check if the current user is a member of the backup group
    $is_backup = (Get-ADGroupMember -Identity $backup_group -Recursive | Select-Object -ExpandProperty SamAccountName) -contains $env:USERNAME

    # Check for misconfigured permissions on the target server
    if ($is_admin) {
        # Run a PowerShell command to check for misconfigured permissions on the target server
        Invoke-Command -ComputerName $target -ScriptBlock {Get-Acl C:\ | Format-List | Out-String}
    }

    # Check for security controls on the target server
    if ($is_backup) {
        # Run a PowerShell command to check for security controls on the target server
        Invoke-Command -ComputerName $target -ScriptBlock {Get-Service | Where-Object {$_.Name -like "*Firewall*"}}
    }
}
