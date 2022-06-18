#!/bin/bash
#this script will search the records of a website using 
#host, dig, whois, nslookup, and whatweb

#HOST
 
 function space  {
  
  echo " "
 echo "--------------------------------------------------"
 echo "---------------------- ^_^ -----------------------"
 echo "--------------------------------------------------"
 echo " "
 
 }
 
 echo " HOST "
 
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
 dig $Target

 space
#-------------------------------------------------------
 echo " NSLOOKUP"
 echo " "
 
 nslookup -query=afxr $Target
 
 space
#-------------------------------------------------------
 echo " WHATWEB "
 echo "HTTPS"
 echo "------------------"
 whatweb -a3 $Target -v
 echo "------------------"
 
 echo " DONE "
