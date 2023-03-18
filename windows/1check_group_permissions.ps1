# Check for group misconfigurations

# Get all groups and their members
$groups = Get-ADGroup -Filter *
foreach ($group in $groups) {
    $members = Get-ADGroupMember $group.Name | Select-Object SamAccountName

    # Check for groups with excessive permissions
    if ($members.Count -gt 10) {
        Write-Host "Group $($group.Name) has $($members.Count) members. Consider reducing the number of members to limit exposure to potential attacks."
    }

    # Check for groups with no members
    if ($members.Count -eq 0) {
        Write-Host "Group $($group.Name) has no members. Consider removing the group if it is no longer needed."
    }

    # Check for groups with misconfigured permissions
    if ($group.GroupScope -eq "DomainLocal" -and $group.GroupCategory -eq "Security") {
        Write-Host "Group $($group.Name) has misconfigured permissions. Verify that the group is only used for the intended purpose and that its members have appropriate permissions."
    }
}

# Check for user misconfigurations

# Get all users and their group memberships
$users = Get-ADUser -Filter *
foreach ($user in $users) {
    $groups = Get-ADPrincipalGroupMembership $user.SamAccountName | Select-Object Name

    # Check for users with excessive group memberships
    if ($groups.Count -gt 10) {
        Write-Host "User $($user.SamAccountName) is a member of $($groups.Count) groups. Consider reducing the number of group memberships to limit exposure to potential attacks."
    }

    # Check for users with misconfigured permissions
    if ($user.Enabled -eq $false) {
        Write-Host "User $($user.SamAccountName) has a misconfigured permission. Verify that the user is disabled intentionally and that it is no longer needed."
    }
}

# Check for misconfigurations in administrators

# Get all administrators
$administrators = Get-ADGroupMember "Domain Admins" | Select-Object SamAccountName

# Check for excessive administrators
if ($administrators.Count -gt 10) {
    Write-Host "There are $($administrators.Count) members in the Domain Admins group. Consider reducing the number of administrators to limit exposure to potential attacks."
}

# Check for misconfigured administrator permissions
foreach ($administrator in $administrators) {
    $user = Get-ADUser $administrator.SamAccountName -Properties MemberOf
    if ($user.MemberOf -notcontains "Domain Admins") {
        Write-Host "User $($user.SamAccountName) has a misconfigured permission. Verify that the user is a member of the Domain Admins group and that it has appropriate permissions."
    }
}
