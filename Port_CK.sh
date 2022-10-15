#!/bin/bash

# Port Checker

# use netstat, ss (dump socket statistcs), and nmap



#space

function space  {

  

  echo " "

 echo "---------------------------------------------------------------"

 echo "--------------------       ^_^         ------------------------"

 echo "---------------------------------------------------------------"

 echo " "

 

 }


#--------------------------------------------------------------------------------------------------------- 


echo "******************************"

echo "*       Port Checker         *"

echo "******************************"


echo " "

space

echo " "

echo  "NESTAT"


sudo netstat -tulpn | grep LISTEN 




echo " "

space

echo " "

#---------------------------------------------------------------------------------------------------------



echo "SS"


sudo ss -tulpn





echo " "

space

echo " "

#---------------------------------------------------------------------------------------------------------



echo "lsof"

echo " "


sudo lsof -i -P -n | grep LISTEN


echo " "

space

echo " "

#---------------------------------------------------------------------------------------------------------



echo "NMAP"


echo " "

echo "Note: nmap user a local host, you can change this with the local IP"

echo " "


sudo nmap -sTU -O localhost
