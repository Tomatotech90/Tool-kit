#!/bin/bash

# A script that performs reconnaissance on a website using various tools
# such as host, dig, whois, nslookup, dnsrecon, wafw00f, whatweb, fierce,
# subfinder, amass, eyewitness, dirsearch, and nikto.

# Define a function to print a separator with a message
function separator() {
  echo " "
  echo "--------------------------------------------------"
  echo "---------------------- $1 -----------------------"
  echo "--------------------------------------------------"
  echo " "
}

# Print a welcome message
echo "Welcome to the website reconnaissance script!"

# Prompt the user for the target website
echo "What is the target website?"
read target

# Use whois to retrieve registration information about the domain name
separator "WHOIS"
echo "Retrieving WHOIS information for $target..."
whois -a $target
echo " "
whois $target

# Use host to get IP address and domain name mappings, as well as all the DNS records associated with the domain name
separator "HOST"
echo "Retrieving host information for $target..."
host $target
echo " "
host -al $target

# Use dig to retrieve DNS information about the domain name
separator "DIG"
echo "Retrieving DNS information for $target..."
dig $target +nocomments

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
wafw00f -a $target -v

# Use whatweb to identify the technologies used by the website
separator "WHATWEB"
echo "Identifying technologies used by $target..."
whatweb -a3 $target -v

# Use subfinder to perform subdomain enumeration
separator "SUBFINDER"
echo "Performing subdomain enumeration on $target..."
subfinder -d $target -o subdomains.txt

# Use amass to perform subdomain enumeration
separator "AMASS"
echo "Performing subdomain enumeration on $target..."
amass enum -d $target -o subdomains.txt

# Use eyewitness to take screenshots of the website
separator "EYEWITNESS"
echo "Taking screenshots of $target..."
eyewitness -f eyewitness-report --no-prompt -d screenshots $target

# Use dirsearch to perform directory enumeration
separator "DIRSEARCH"
echo "Performing directory enumeration on $target..."
dirsearch -u https://$target -e php,asp,aspx,jsp,html,zip,jar -o dirsearch-report.txt

# Use nikto to perform vulnerability scanning
separator "NIKTO"
echo "Performing vulnerability scanning on $target..."
nikto -h $target -output nikto-report.txt

# Print a done message
separator "DONE"
echo "Thank you for using the website reconnaissance script!"
