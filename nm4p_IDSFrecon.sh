#!/bin/bash

# Nmap recon
# Interact script is based on the results
# Feel free to change the script
# -----------------------------------------------------------------------------------

echo "First check who is on the other side"

echo -n "Target IP: "
read Target

echo "Wafw00f"
echo
echo "------------------"
wafw00f -a $Target -v
echo "------------------"

# -----------------------------------------------------------------------------------

echo "Nmap scanning"
echo "Using D (decoy) and RND (random)"
echo

# Change the flags if you have a decoy
# You can choose how many random IPs, e.g., RND:#
sudo nmap -sS -sV -D RND: $Target

echo

# ---------------------------------------------------------------------------------

echo "Nmap using script firewalk"

nmap -sS --script=firewalk --traceroute $Target

echo

# ----------------------------------------------------------------------------------

# The mtu is the size of the package, based on 8, 16, ...
echo "Fragment the packages"
echo -n "The size of mtu: "

read size

sudo nmap -sS -sV -F --mtu $size -D $Target

echo

# ------------------------------------------------------------------------------------

echo "Banner"
echo
echo "Will perform two commands, if you want you can comment one"
echo
echo "The commands are the following:"
echo "sudo nmap -sS -sV -D RND: $Target"
echo "sudo nmap -sS -sV --mtu $size -D $Target"

# Based on the results, you might need to change this
sudo nmap -F -T4 --script banner -D RND: $Target
echo
echo
sudo nmap -F -T4 --script banner --mtu $size -D $Target

echo "Done"
