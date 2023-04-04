#!/bin/bash

# A script that searches for files, directories, and binaries on the system using the locate, whereis, and which commands.

# Define color codes
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
reset='\033[0m'

# Define separator function
separator() {
  echo -e "${green}\n--------------------------------------------------${reset}"
  echo -e "${green}---------------------- $1 -----------------------${reset}"
  echo -e "${green}--------------------------------------------------\n${reset}"
}

# Prompt the user for the name of the file, directory, or binary they're searching for
echo -e "${yellow}What are you searching for?${reset}"
read search_query

# Use the locate command to search for the object
separator "LOCATE"
echo -e "${yellow}Searching for $search_query with locate...${reset}"
locate_count=$(locate -c $search_query) # Store the number of results in a variable
if [ $locate_count -eq 0 ]; then
  echo -e "${red}No results found with locate.${reset}"
else
  echo -e "${green}Found $locate_count result(s) with locate:${reset}"
  locate $search_query | less # Paginate the output with less
fi

# Use the whereis command to search for the binary, source, and manual page files associated with the object
separator "WHEREIS"
echo -e "${yellow}Searching for $search_query with whereis...${reset}"
whereis_result=$(whereis $search_query) # Store the result in a variable
if [ -z "$whereis_result" ]; then
  echo -e "${red}No results found with whereis.${reset}"
else
  echo -e "${green}Found the following result(s) with whereis:${reset}"
  echo "$whereis_result"
fi

# Use the which command to search for the binary file associated with the object
separator "WHICH"
echo -e "${yellow}Searching for $search_query with which...${reset}"
which_result=$(which $search_query) # Store the result in a variable
if [ -z "$which_result" ]; then
  echo -e "${red}No results found with which.${reset}"
else
  echo -e "${green}Found the following result(s) with which:${reset}"
  echo "$which_result"
fi

# Print a message indicating whether the searched object is a file, binary, or directory
separator "DONE"
if [ -d "$search_query" ]; then
  echo -e "${green}$search_query is a directory.${reset}"
elif [ -x "$search_query" ]; then
  echo -e "${green}$search_query is a binary.${reset}"
elif [ -f "$search_query" ]; then
  echo -e "${green}$search_query is a file.${reset}"
else
  echo -e "${red}Could not determine the type of $search_query.${reset}"
fi
