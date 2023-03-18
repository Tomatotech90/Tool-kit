#Windows Scritps
-Basic windows scripts for reconnaissence. 

-----------------------------------------------------------------------------------------------------------------------

|  Scripts     |        Defenitions                                                                                    |
| ------------ |:------------------------------------------------------------------------------------------------------|
| Basic        |- PowerShell script that collects information about a target system, including user accounts, network shares, running processes, installed software, and open ports|
|              |                                                                                                       |
|check_security|-This script checks for misconfigured permissions and security controls by checking if the current user is a member of the "Domain Admins" and "Backup Operators" groups, respectively. If the user is a member of these groups, the script runs PowerShell commands on the target server to check for misconfigured permissions and security controls. The script can be customized to check for other misconfigured permissions and security controls as well.|
|              |                                                                                                       |
|1check_group_permissions|-This script checks for excessive permissions in groups and users, misconfigured permissions in administrators, and provides recommendations for reducing exposure to potential attacks.|
|               |                                                                                                      |
|2check_group_permissions| - new version: This updated script checks for misconfigured permissions in the local Administrators group, checks if any users have the SeDebugPrivilege privilege enabled, and checks for any misconfigured permissions on network shares. To optimize the script, I have used more specific cmdlets and optimized the filters used to gather information.|
|              |                                                                                                       |
