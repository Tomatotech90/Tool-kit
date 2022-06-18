#!/bin/bash
#this script will search the records of a website using 
#host, dig, whois, nslookup, and whatweb

#HOST
 
 echo" HOST "
 
 echo "what is the target: "
 
 read Target	
 echo "WHOIS"
 echo " "
 whois -a $Target 
 echo " "
 whois $Target
 echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 host  $Target
 echo " "
 host -al $Target
 echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 echo " DIG "
 echo " A records "
 dig $Target
 echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 echo " NSLOOKUP"
 echo " "
 
 nslookup -query=afxr $Target
 echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 echo " WHATWEB "
 
 whatweb -a $Target -v
 
 echo " DONE "
 

 
 
