#!/bin/bash




#It is important to note that xmlrpc.php being enabled on a WordPress instance is not a vulnerability. 
#Depending on the methods allowed, xmlrpc.php can facilitate some enumeration and exploitation activities.

 echo " Target Ip: "
 read Target


#---------------------------------------------------------------------------------------------------------------

echo " "


curl -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>CORRECT-PASSWORD</value></param></params></methodCall>" http://$Target/xmlrpc.php >> report_xlrpc.txt


echo " "

#----------------------------------------------------------------------------------------------------------------

echo " "

curl -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>WRONG-PASSWORD</value></param></params></methodCall>"  http://$Target/xmlrpc.php  >> report_xlrpc.txt

echo " "

#----------------------------------------------------------------------------------------------------------------
 
echo " "

curl -s -X POST -d "<methodCall><methodName>system.listMethods</methodName></methodCall>" http://$Target/xmlrpc.php  >> report_xlrpc.txt
