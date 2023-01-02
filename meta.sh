#!/bin/bash

# Check if exiftool, identify, file, and md5sum are installed
if ! [ -x "$(command -v exiftool)" ]; then
  echo 'Error: exiftool is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v identify)" ]; then
  echo 'Error: identify is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v file)" ]; then
  echo 'Error: file is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v md5sum)" ]; then
  echo 'Error: md5sum is not installed.' >&2
  exit 1
fi

# Check if an image file was provided as an argument
if [ $# -eq 0 ]; then
  echo "Error: no image file provided" >&2
  exit 1
fi

# Extract metadata
metadata=$(exiftool "$1")

# Check if image has been manipulated
manipulated=0
if echo "$metadata" | grep -q "Modify Date" && echo "$metadata" | grep -q "Create Date"; then
  modify_date=$(echo "$metadata" | grep "Modify Date" | awk '{print $4}')
  create_date=$(echo "$metadata" | grep "Create Date" | awk '{print $4}')
  if [ "$modify_date" != "$create_date" ]; then
    manipulated=1
  fi
fi

# Check image signature
signature=$(identify -verbose "$1" | grep Signature | awk '{print $2}')

# Check file type
file_type=$(file "$1")

# Check creation date
creation_date=$(echo "$metadata" | grep "Create Date" | awk '{print $4}')

# Extract encoded strings
encoded_strings=$(strings -o "$1")

# Calculate checksum
checksum=$(md5sum "$1")

# Print results
echo "$metadata"
if [ $manipulated -eq 1 ]; then
  echo "This image has been manipulated."
else
  echo "This image has not been manipulated."
fi
echo "Signature: $signature"
echo "File type: $file_type"
echo "Creation date: $creation_date"
echo "Encoded strings:"
echo "$encoded_strings"
echo "Checksum: $checksum"
