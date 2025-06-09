#!/bin/bash

# A script to search for files, directories, and binaries using locate, whereis, and which commands.

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Define separator function
separator() {
  echo -e "${GREEN}\n--------------------------------------------------${reset}"
  echo -e "${GREEN}---------------------- $1 -----------------------${reset}"
  echo -e "${GREEN}--------------------------------------------------\n${reset}"
}

# Function to check if a command is available
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "${RED}Error: '$1' command not found. Please install it to use this feature.${RESET}"
    return 1
  fi
  return 0
}

# Check for required commands
for cmd in locate whereis which; do
  check_command "$cmd" || exit 1
done

# Prompt for search query with validation
while true; do
  echo -e "${YELLOW}What are you searching for? (Enter a file, directory, or binary name, or 'q' to quit)${RESET}"
  read -r search_query
  [[ "$search_query" == "q" ]] && exit 0
  if [[ -z "$search_query" ]]; then
    echo -e "${RED}Error: Search query cannot be empty. Please try again.${RESET}"
  else
    break
  fi
done

# Update locate database if needed (optional, requires sudo)
if [[ -n "$UPDATE_LOCATE" ]]; then
  echo -e "${YELLOW}Updating locate database...${RESET}"
  if sudo updatedb; then
    echo -e "${GREEN}Locate database updated successfully.${RESET}"
  else
    echo -e "${RED}Failed to update locate database.${RESET}"
  fi
fi

# Use locate command to search
separator "LOCATE"
echo -e "${YELLOW}Searching for '$search_query' with locate...${RESET}"
locate_count=$(locate -c "$search_query" 2>/dev/null)
if [[ $? -ne 0 ]]; then
  echo -e "${RED}Error running locate. Check if the database is accessible.${RESET}"
elif [[ $locate_count -eq 0 ]]; then
  echo -e "${RED}No results found with locate.${RESET}"
else
  echo -e "${GREEN}Found $locate_count result(s) with locate:${RESET}"
  locate "$search_query" | less
fi

# Use whereis command to search
separator "WHEREIS"
echo -e "${YELLOW}Searching for '$search_query' with whereis...${RESET}"
whereis_result=$(whereis "$search_query" 2>/dev/null)
if [[ $? -ne 0 ]] || [[ -z "$whereis_result" ]]; then
  echo -e "${RED}No results found with whereis or an error occurred.${RESET}"
else
  echo -e "${GREEN}Found the following result(s) with whereis:${RESET}"
  echo "$whereis_result"
fi

# Use which command to search
separator "WHICH"
echo -e "${YELLOW}Searching for '$search_query' with which...${RESET}"
which_result=$(which "$search_query" 2>/dev/null)
if [[ $? -ne 0 ]] || [[ -z "$which_result" ]]; then
  echo -e "${RED}No results found with which or an error occurred.${RESET}"
else
  echo -e "${GREEN}Found the following result(s) with which:${RESET}"
  echo "$which_result"
fi

# Determine the type of the search query
separator "DONE"
# Check if the result from 'which' or absolute path exists
if [[ -n "$which_result" ]] && [[ -x "$which_result" ]]; then
  echo -e "${GREEN}'$search_query' is an executable (binary).${RESET}"
elif [[ -d "/$search_query" ]] || [[ -d "$search_query" ]]; then
  echo -e "${GREEN}'$search_query' is a directory.${RESET}"
elif [[ -f "/$search_query" ]] || [[ -f "$search_query" ]]; then
  echo -e "${GREEN}'$search_query' is a file.${RESET}"
else
  echo -e "${RED}Could not determine the type of '$search_query'.${RESET}"
fi

# Offer to search again
echo -e "${YELLOW}\nWould you like to search again? (y/n)${RESET}"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  exec "$0"
fi
