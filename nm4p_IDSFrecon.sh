#!/bin/bash

#Nmap recon
#interact script is base on the results
#feel free to change the script
#-----------------------------------------------------------------------------------

 echo "First check who is in the other side"

 echo " Target Ip: "
 read Target

 echo " Wafw00f "
 echo " "
 echo "------------------"
 wafw00f -a $Target -v
 echo "------------------"

#-----------------------------------------------------------------------------------

 echo "Nmap scanning"
 echo " using D (decoy) and RND (random) "
 echo " "
#changet the flags if you have a decoy
#you can choo how many random ips exam: RND:#
 sudo nmap -sS -sV  -D RND: $Target

 echo " "
#----------------------------------------------------------------------------------
#the mtu is the size of the package, base on 8,16....
 echo "fragment teh packages"
 echo "the size of mtu: "

 read size

  sudo nmap -sS -sV --mtu $size -D  $Target

 echo " "
#------------------------------------------------------------------------------------

 echo " Banner "
 echo " "
 echo "will perform two commands, if you want you comment one "
 echo " "
 echo "the command is the following: sudo nmap -sS -sV  -D RND: $Target"
 echo " "
 echo "sudo nmap -sS -sV --mtu $size -D  $Target "
 
 #base on the results you need to change this
 sudo nmap -F -T4 --script banner  -D RND: $Target
 echo " "
 echo " "
 sudo nmap -F -T4 --script banner --mtu $size -D  $Target
  
 echo "Done"
