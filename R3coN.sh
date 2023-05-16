#!/bin/bash

# A script that performs reconnaissance on a target using various tools
# such as host, dig, whois, nslookup, dnsrecon, wafw00f, whatweb, nikto, nmap, curl and ping.

# Define a function to print a separator with a message
function separator() {
  echo " "
  echo "--------------------------------------------------"
  echo "---------------------- $1 -----------------------"
  echo "--------------------------------------------------"
  echo " "
}

# Print a welcome message
echo "Welcome to the reconnaissance script!"

# Prompt the user for the target
echo "What is the target (IP address or website)?"
read target

# Use whois to retrieve registration information about the domain name
separator "WHOIS"
echo "Retrieving WHOIS information for $target..."
whois -a $target

# Use host to get IP address and domain name mappings, as well as all the DNS records associated with the domain name
separator "HOST"
echo "Retrieving host information for $target..."
host $target

# Use dig to retrieve DNS information about the domain name
separator "DIG"
echo "Retrieving DNS information for $target..."
dig $target +nocomments

# Use dig for subdomain enumeration
separator "SUBDOMAIN ENUMERATION"
echo "Performing subdomain enumeration on $target..."
dig +short -t axfr $target

# Use nslookup to perform a DNS lookup on the domain name
separator "NSLOOKUP"
echo "Performing DNS lookup for $target..."
nslookup -query=afxr $target

# Use dnsrecon to perform DNS reconnaissance on the domain name
separator "DNSRECON"
echo "Performing DNS reconnaissance on $target..."
dnsrecon -d $target

# Use wafw00f to check if the website is behind a Web Application Firewall (WAF)
separator "WAFW00F"
echo "Checking if $target is behind a WAF..."
wafw00f -a $target

# Use whatweb to identify the technologies used by the website
separator "WHATWEB"
echo "Identifying technologies used by $target..."
whatweb -a3 $target

# Use nmap to perform a port scan
separator "NMAP"
echo "Performing a port scan on $target..."
nmap -p 1-1000 -T4 -A -v $target

# Use curl to check HTTP headers
separator "CURL"
echo "Checking HTTP headers for $target..."
curl -I $target

# Use ping to check network connectivity
separator "PING"
echo "Pinging $target..."
ping -c 4 $target

# Use gobuster to perform directory enumeration
separator "GOBUSTER"
echo "Performing directory enumeration on $target..."
gobuster dir -u http://$target -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster-report.txt

# Use nikto to perform vulnerability scanning
separator "NIKTO"
echo "Performing vulnerability scanning on $target..."
nikto -h $target -output nikto-report.txt

# Print a done message
separator "DONE"
echo "Thank you for using the reconnaissance script!"

