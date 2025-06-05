# Tool Kit
These tools will help in a CTF's, Red Team operations, or Pentesting assessment.

![logo](https://user-images.githubusercontent.com/96146875/234340251-7165ccd5-d5c0-40d0-b671-52a105b795ee.png)

             
Directories :
|     |                                |
|-----|--------------------------------|
| API |- basic api recon.              |
|                                      |
|Windows| - PowerShell scripts.        |


-----------------------------------------------------------------------------------------------------------------------

|  Scripts     |        Defenitions                                                                                    |
| ------------ |:------------------------------------------------------------------------------------------------------|
| R3coN        |-the script will search for DNS records, waw00f and whatweb, by deafault is basic mode(records A,MX or                  TXT), fierce (domains and subdomains)
|              |                                                                                                        |
| CIR.sh       | - this bash is from HTB, credits to the academy. hackthebox.                                           |
|              |
| Enumeration  | - enumerate WP websites, checking for version, index, plugs, and themes. (directory index based on plugs) | [curl]      |
|              |                                                                                                        |
| search       | -a script that help to find any info using locate, which, and whereis.                                 |
|              |                                                                                                        |
| Port_CK      |  - simple script that check for open ports in the host machine, using nestat,ss,lsof and nmap.         |
|              |
|Rate_limit_checker| -by HTB, check the limit of web application(brute force).                                          |
|              |                                                                                                        |
|nm4p_IDSFrecon| -script that use nmap to avoid IDS and Firewalls.                                                      |
|              |                                                                                                        |
|nm4p_HTTPenum | -script that use nmap to scan for directories on php.                                                  |
|              |                                                                                                        |
|Re4shell      | -easy resevershell.                                                                                    |
|              |                                                                                                        |
|meta          | -check for metadata mnipulation.                                                                       |
|              |                                                                                                        |
|network_discovery| -  simple bash script that can be used to discover the CIDR and range of a network.                 |
|              |                                                                                                        |
|privilege_chk  | -check for basic privilege escalation.                                                                 |
|              |                                                                                                        |
|exploitdb     | -easyway to find vuln, using nmap,searchsploit and metasploit.                                         |
|              |                                                                                                        |
|Lynis_basicrun| -basic lynis script that will do a security task.                                                       |
|              |                                                                                                        |
|Nm4p_Bas1c    | -script that make a basic nmap scna using the follow flags -SCV, -Pn (optional) and -oA for report     |
|              |                                                                                                        |
|Auto          |-This script prompts the user for the target URL, then uses curl to fetch the HTTP headers and cookies from the target URL. The script then prompts the user to run an SSL/TLS vulnerability scan, extract data from the target URL, and enumerate open ports on the target system. If the user runs an SSL/TLS vulnerability scan, the script uses openssl to test for vulnerabilities and saves the results to separate text files. If the user chooses to extract data from the target URL, the script prompts the user to enter a search string and uses grep to extract data from the target URL that contains that string. If the user chooses to enumerate open ports on the target system, the script prompts the user|
|               |                                                                                                       |
|LFI_Tra        | -Python script that checks a target web page for potential Local File Inclusion (LFI) and File Traversal vulnerabilities. It does this by sending requests to the target URL with different payloads, and trying to access sensitive files using various directory traversal patterns.|
|               |                                                                                                       |
| NmapWin       |- performs a network port scan and vulnerability assessment on a target system. It uses the Nmap tool to scan for open ports on the target and then checks for vulnerabilities associated with each open port. The script also checks if the target is a Windows system and suggests potential vulnerabilities associated with common Windows services, such as RPC, NetBIOS, and SMB. It then uses the smbclient tool to connect to the SMB service, test for write access, and download files from the service. |
|                |                                                                                                       |
