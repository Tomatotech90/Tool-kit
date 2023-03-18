# Get all local user accounts and their group membership
$localUsers = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'"
foreach ($user in $localUsers) {
    Write-Output "Local user account found: $($user.Name)"
    $groups = Get-WmiObject -Class Win32_GroupUser -Filter "PartComponent=""Win32_UserAccount.Domain='$($user.Domain)',Name='$($user.Name)'""" | ForEach-Object { $_.GroupComponent -replace '^Win32_Group.Domain="([^"]+)",Name="([^"]+)".*$', '$1\\$2' }
    Write-Output "    Group membership: $($groups -join ', ')"
}

# Check for any misconfigured permissions in the local Administrators group
$adminGroup = Get-LocalGroupMember -Name Administrators
foreach ($member in $adminGroup) {
    if ($member.ObjectClass -eq "User") {
        $user = Get-LocalUser -Name $member.Name
        if ($user.Enabled -eq $false) {
            Write-Output "User $($user.Name) is a member of the Administrators group, but their account is disabled."
        }
        if ($user.PasswordNeverExpires -eq $false) {
            Write-Output "User $($user.Name) is a member of the Administrators group, but their password does not expire."
        }
    }
    elseif ($member.ObjectClass -eq "Group") {
        $group = Get-LocalGroup -Name $member.Name
        if ($group.Members.Count -gt 0) {
            Write-Output "Group $($group.Name) is a member of the Administrators group, but it has members other than the default built-in accounts."
        }
    }
}

# Check if any users have the SeDebugPrivilege privilege enabled
$seDebugPrivilege = Get-Privilege -Name SeDebugPrivilege
$userPrivileges = Get-UserPrivilege
foreach ($userPrivilege in $userPrivileges) {
    if ($userPrivilege.Privileges.Contains($seDebugPrivilege)) {
        Write-Output "User $($userPrivilege.IdentityReference) has the SeDebugPrivilege privilege enabled."
    }
}

# Check for any misconfigured permissions on network shares
$shares = Get-WmiObject -Class Win32_Share
foreach ($share in $shares) {
    if ($share.Type -eq 0) {
        Write-Output "Network share found: $($share.Name)"
        $permissions = Get-Acl -Path "\\$($env:COMPUTERNAME)\$($share.Name)" | Select-Object -ExpandProperty Access
        foreach ($permission in $permissions) {
            if ($permission.IdentityReference -eq "Everyone" -and $permission.FileSystemRights -gt "ReadAndExecute") {
                Write-Output "    Everyone has excessive permissions: $($permission.FileSystemRights)"
            }
            if ($permission.IdentityReference -eq "Authenticated Users" -and $permission.FileSystemRights -gt "ReadAndExecute") {
                Write-Output "    Authenticated Users has excessive permissions: $($permission.FileSystemRights)"
            }
        }
    }
}
