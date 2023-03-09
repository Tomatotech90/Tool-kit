#!/bin/bash

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
  echo "Running as root"
else
  echo "Not running as root"
fi

# Check for unprotected suid files
echo "Checking for unprotected SUID files..."
find / -perm -4000 -type f 2>/dev/null

# Check for world-writable files
echo "Checking for world-writable files..."
find / -perm -2 -type f 2>/dev/null

# Check for unprotected directories
echo "Checking for unprotected directories..."
find / -perm -2 -type d 2>/dev/null

# Check for misconfigured sudoers file
if [ -f "/etc/sudoers" ]; then
  echo "Checking for misconfigured sudoers file..."
  visudo -c
fi

# Check sudo version
echo "Checking sudo version..."
sudo -V

# Check for known sudo vulnerabilities
echo "Checking for known sudo vulnerabilities..."
searchsploit sudo

# Check for recent CVEs
echo "Checking for recent CVEs..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -s | grep -Eo 'CVE-[0-9]{4}-[0-9]{4}' | sort -u

# Check for sudoedit vulnerabilities
echo "Checking for sudoedit vulnerabilities..."
sudoedit -s '\' `perl -e 'print "A"x100'`

# Check for sudo privilege escalation vulnerabilities
echo "Checking for sudo privilege escalation vulnerabilities..."
sudo -l

# Check for sudo pty vulnerabilities
echo "Checking for sudo pty vulnerabilities..."
sudo sh -c 'echo A | sudo -S su' 2>/dev/null

# Check for sudo heap overflow vulnerabilities
echo "Checking for sudo heap overflow vulnerabilities..."
sudoedit -s '\' `perl -e 'print "A"x40000'`

# Check for sudo format string vulnerabilities
echo "Checking for sudo format string vulnerabilities..."
sudoedit -s '\' `printf "%s\n" "%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n
