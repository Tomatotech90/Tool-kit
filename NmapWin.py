import nmap
import subprocess

# Create an nmap scanner object
scanner = nmap.PortScanner()

# Prompt the user for the target to scan
target = input("Enter the target IP address or hostname: ")

# Use nmap to scan the target
scanner.scan(hosts=target, arguments="-n -sS -f -T4 -sC -sV")

# Print the results
print("Host:", target)
print("State:", scanner[target].state())

# Check if the target is a Windows system
os_type = scanner[target]['osmatch'][0]['osclass'][0]['osfamily']
if os_type.lower() == 'windows':
    print("OS Type: Windows")
    print("Potential vulnerabilities:")
    if 135 in scanner[target]['tcp']:
        print("- RPC endpoint mapper service (port 135) is open")
    if 139 in scanner[target]['tcp']:
        print("- NetBIOS Session Service (port 139) is open")
    if 445 in scanner[target]['tcp']:
        print("- SMB file sharing service (port 445) is open")
        # Try to connect to the SMB service using smbclient
        smb_client = subprocess.run(['smbclient', '-N', '-L', f'//{target}/'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if smb_client.returncode == 0:
            print("- SMB file sharing service (port 445) is accessible (anonymous login)")
            print("  - Shares:")
            print(smb_client.stdout.decode())
            smb_login = subprocess.run(['smbclient', '-N', f'//{target}/IPC$', '-c', 'dir'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if smb_login.returncode == 0:
                print("  - Anonymous login is possible")
                smb_download = subprocess.run(['smbclient', '-N', f'//{target}/C$', '-c', 'get boot.ini'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                if smb_download.returncode == 0:
                    print("  - Boot.ini file downloaded successfully")
    if 3389 in scanner[target]['tcp']:
        print("- Remote Desktop Protocol (port 3389) is open")
else:
    print("OS Type:", os_type)

print("Open ports:", scanner[target].all_tcp())

# Additional suggestions based on open ports
if 25 in scanner[target]['tcp']:
    print("- SMTP service (port 25) is open")
if 110 in scanner[target]['tcp']:
    print("- POP3 service (port 110) is open")
if 143 in scanner[target]['tcp']:
    print("- IMAP service (port 143) is open")
if 993 in scanner[target]['tcp']:
    print("- IMAPS service (port 993) is open")
if 80 in scanner[target]['tcp']:
    print("- HTTP service (port 80) is open")
# Check for open ports associated with file transfer services, such as SFTP (port 22) or FTPS (port 21 or 990)
if 22 in scanner[target]['tcp']:
    print("- SFTP service (port 22) is open")
if 990 in scanner[target]['tcp']:
    print("- FTPS service (port 990) is open")

# Check for the presence of known vulnerabilities and test for write access to the SMB service
if 445 in scanner[target]['tcp']:
    print("Checking for known vulnerabilities and testing write access to SMB service...")
    smb_vuln = subprocess.run(['smb-vuln-ms17-010', target], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if 'VULNERABLE' in smb_vuln.stdout.decode():
        print("- SMB service is vulnerable to EternalBlue exploit (MS17-010)")
    smb_upload = subprocess.run(['smbclient', '-N', f'//{target}/C$', '-c', 'put smbtest.txt'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if smb_upload.returncode == 0:
        print("- Write access to SMB service is possible")

# Check for anonymous login and test for write access to the FTP service
if 21 in scanner[target]['tcp']:
    print("Checking for anonymous login and testing write access to FTP service...")
    ftp_login = subprocess.run(['ftp', '-nv', target], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if 'connected.' in ftp_login.stderr.decode():
        print("- Anonymous login is possible")
        ftp_upload = subprocess.run(['ftp', '-n', target], input=b'quote USER anonymous\nquote PASS anonymous\nput ftp_test.txt\nquit\n', stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if '226 Transfer complete.' in ftp_upload.stderr.decode():
            print("- Write access to FTP service is possible")
            ftp_download = subprocess.run(['ftp', '-nv', target], input=b'quote USER anonymous\nquote PASS anonymous\nget /etc/passwd\nquit\n', stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if '226 Transfer complete.' in ftp_download.stderr.decode():
                print("- /etc/passwd file downloaded successfully")

# Additional suggestions based on open ports
if 110 in scanner[target]['tcp']:
    print("- POP3 service (port 110) is open")
if 143 in scanner[target]['tcp']:
    print("- IMAP service (port 143) is open")
if 80 in scanner[target]['tcp']:
    print("- HTTP service (port 80) is open")
    if 443 in scanner[target]['tcp']:
        print("  - HTTPS service (port 443) is also open")
if 8080 in scanner[target]['tcp']:
    print("- Tomcat service (port 8080) is open")
if 443 in scanner[target]['tcp']:
    print("- Apache HTTPS service (port 443) is open")
if 23 in scanner[target]['tcp']:
    print("- Telnet service (port 23) is open")
if 3306 in scanner[target]['tcp']:
    print("- MySQL service (port 3306) is open")
if 5432 in scanner[target]['tcp']:
    print("- PostgreSQL service (port 5432) is open")
if 9100 in scanner[target]['tcp']:
    print("- HP JetDirect printer service (port 9100) is open")

