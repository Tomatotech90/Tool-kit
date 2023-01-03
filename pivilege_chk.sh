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
