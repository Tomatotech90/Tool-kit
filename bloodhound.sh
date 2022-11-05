#!/bin/bash
#this script will search the records of a website using 
#host, dig, whois, nslookup, dnsrecon and whatweb

#HOST
 
 function space  {
  
  echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 
 }
 
 echo "  welcome ^_^  "
 
 echo "what is the target: "
 
 read Target
 
#-------------------------------------------------------
 echo "WHOIS"
 echo " "
 whois -a $Target 
 echo " "
 whois $Target
 
 space 
#-------------------------------------------------------
echo " HOST"
 host  $Target
 echo " "
 host -al $Target
 
 space
#-------------------------------------------------------
 echo " DIG "
 echo " A records "
 dig $Target  +nocomments

 space
#-------------------------------------------------------
 echo " NSLOOKUP "
 echo " "
 
 nslookup -query=afxr $Target
 
 space
#-------------------------------------------------------
echo " DNSRECON "
echo " "

dnsrecon -d $Target

space
#-------------------------------------------------------
 echo " Wafw00f "
 echo " "
 echo "------------------"
 wafw00f -a $Target -v
 echo "------------------"

space

#-------------------------------------------------------
echo " WHATWEB "
 echo "HTTPS"
 echo "------------------"
 whatweb -a3 $Target -v
 echo "------------------"
 #-----------------------------------------------------
 echo "recon dns and subdomains using fierce"
 echo " "
 echo "Note: youcan stop here if you dont want to peforme brute force"
 echo " "
 fierce --domains $Target
 space
 echo " DONE "
