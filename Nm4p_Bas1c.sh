#!/bin/bash

read -p "Enter target name: " A
read -p "Enter target IP address: " IP

read -p "Add -Pn flag? (yes/no): " use_Pn
if [[ $use_Pn == "yes" ]]; then
    nmap_command="sudo nmap -sCV --reason -oA $A -Pn $IP"
else
    nmap_command="sudo nmap -sCV --reason -oA $A $IP"
fi

echo "Running Nmap scan with command: $nmap_command"
eval $nmap_command

read -p "Convert to HTML using xsltproc? (yes/no): " use_xsltproc
if [[ $use_xsltproc == "yes" ]]; then
    xsltproc_command="xsltproc $A.xml -o $A.html"
    echo "Running xsltproc with command: $xsltproc_command"
    eval $xsltproc_command
fi
