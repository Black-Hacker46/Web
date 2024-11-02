#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# Function to get the IP address of a target website
get_ip() {
    local domain=$1
    ip=$(dig +short "$domain")
    if [ -z "$ip" ]; then
        echo -e "${RED}Could not find IP address for ${domain}.${NC}"
    else
        echo -e "${GREEN}The IP address of ${domain} is: ${YELLOW}$ip${NC}"
    fi
}

# Main script
clear
echo -e "${GREEN}"
read -p "Enter the website domain (e.g., example.com): " website
get_ip "$website"
