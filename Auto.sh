#!/bin/bash

# A script that analyzes HTTP headers and cookies, scans for SSL/TLS vulnerabilities,
# extracts data from a web page or API response, and enumerates open ports on a target system.

# Prompt the user for the target URL
echo "Enter the target URL:"
read target_url

# Use curl to fetch the HTTP headers and cookies from the target URL
echo "Fetching HTTP headers and cookies from $target_url..."
curl -I -c cookies.txt $target_url > headers.txt
echo "HTTP headers and cookies saved to headers.txt and cookies.txt"

# Prompt the user to run an SSL/TLS vulnerability scan
echo "Do you want to run an SSL/TLS vulnerability scan? (y/n)"
read scan_ssl
if [ "$scan_ssl" = "y" ]; then
  # Use openssl to test for SSL/TLS vulnerabilities
  echo "Running SSL/TLS vulnerability scan on $target_url..."
  openssl s_client -connect $target_url:443 -ssl3 < /dev/null > ssl3.txt
  openssl s_client -connect $target_url:443 -tls1 < /dev/null > tls1.txt
  openssl s_client -connect $target_url:443 -tls1_1 < /dev/null > tls1_1.txt
  openssl s_client -connect $target_url:443 -tls1_2 < /dev/null > tls1_2.txt
  echo "SSL/TLS vulnerability scan complete. Results saved to ssl3.txt, tls1.txt, tls1_1.txt, and tls1_2.txt"
fi

# Prompt the user to extract data from the target URL
echo "Do you want to extract data from $target_url? (y/n)"
read extract_data
if [ "$extract_data" = "y" ]; then
  # Use grep to extract data from the target URL
  echo "Enter the string to search for:"
  read search_string
  echo "Extracting data from $target_url that contains '$search_string'..."
  curl $target_url | grep "$search_string" > extracted_data.txt
  echo "Extracted data saved to extracted_data.txt"
fi

# Prompt the user to enumerate open ports on the target system
echo "Do you want to enumerate open ports on the target system? (y/n)"
read enumerate_ports
if [ "$enumerate_ports" = "y" ]; then
  # Use nmap to enumerate open ports on the target system
  echo "Enter the IP address of the target system:"
  read target_ip
  echo "Enumerating open ports on $target_ip..."
  nmap $target_ip > open_ports.txt
  echo "Open ports enumerated. Results saved to open_ports.txt"
fi
