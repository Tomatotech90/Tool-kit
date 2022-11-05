#!/bin/bash

#Nmap HTTP enumeration
#interact script is base on the results
#feel free to change the script
#-----------------------------------------------------------------------------------
 echo "WELCOME"
 
 echo" "
 
#-----------------------------------------------------------------------------------
 echo " Target Ip: "
 read Target
#------------------------------------------------------------------------------------
 #quick scan to check port 80
 echo "Nmap will do a recon scan"
 
 sudo nmap -F -sV -T5 $Target
 
#-------------------------------------------------------------------------------------
 echo "Nmap will check port 80"
 echo " "
 echo "using scritp http-enum"

 sudo nmap -sV -p 80 --script http-enum $Target
 #------------------------------------------------------------------------------------
 
 
 
