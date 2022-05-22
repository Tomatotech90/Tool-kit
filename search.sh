#!/bin/bash
#search for files, directories and binaries, in one script ^_^
echo "what do you looking for:  "
read a

echo "*******locate******"

echo " locate count"

locate -c $a

locate  $a | less 

echo "**************************"

echo "******-whereis-******"

whereis $a 

echo "**************************"

echo "******-which-******"

which $a


echo "**************************"

echo "******-done-******"




