
#!/bin/bash
#cURL script that help to enumerate a wordpress website 

#Target 

echo "what is the target: "
echo "(format: target.com) "

read target


#----------------------------------------------------------------
echo " WP Version "

curl -s  -X  GET http://$target | grep '<meta="generator "'

echo "---------------------------------------------------"

#------------------------------------------------------------------
echo " WP Plugins "

curl  -s -X GET  http://$target | sed 's/href=/\n/g' | sed 's/src=/\n/g' | grep 'wp-content/plugins/*' | cut -d"'" -f2
echo "---------------------------------------------------"
#-------------------------------------------------------------------

echo " Themes "

curl -s -X GET http://$target  | sed 's/href=/\n/g' | sed 's/src=/\n/g' | grep 'themes' | cut -d"'" -f2

echo "---------------------------------------------------"

# Directory indexing
echo ""
echo "Directoy Indexing"
echo " "
echo  "Want to index any directory? [y/N] "
read  response
if [  $response = y ]
 then
     echo "************************************************"
     echo "* NOTE: the package html2text is necesssary!!! *"
     echo "************************************************"
     echo " what is the directory?"
     echo " the format is: http:// target/directory"
     read d
    curl -s -X GET http://$d | html2text
else
    echo " DONE "
fi
