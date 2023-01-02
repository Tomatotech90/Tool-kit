#!/bin/bash

# Get the network address
echo -n "Enter the network address (e.g. 192.168.0.0): "
read network

# Get the subnet mask
echo -n "Enter the subnet mask (e.g. 255.255.255.0): "
read mask

# Calculate the network CIDR
IFS=. read -r i1 i2 i3 i4 <<< "$mask"
cidr=$((i1+i2+i3+i4))

# Calculate the network range
IFS=. read -r n1 n2 n3 n4 <<< "$network"
start=`printf "%d.%d.%d.%d" "$((n1 & i1))" "$((n2 & i2))" "$((n3 & i3))" "$((n4 & i4))"`
end=`printf "%d.%d.%d.%d" "$((n1 | (~i1 & 255)))" "$((n2 | (~i2 & 255)))" "$((n3 | (~i3 & 255)))" "$((n4 | (~i4 & 255)))"`

# Print the results
echo "Network CIDR: $cidr"
echo "Network range: $start - $end"
