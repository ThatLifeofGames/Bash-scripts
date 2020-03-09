#!/bin/bash

#
# Test rclone team drive remotes are still working
#

# Define colours

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m'

# Perform tests and display results

echo "${WHITE}-------------------------------------------------\n"
echo "Testing backup remotes... This may take some time\n"
echo "-------------------------------------------------\n\n"

# Test personal backup

printf "[Home] Chris Backup... "

if rclone mkdir gcrypt:/Test > /dev/null 2>&1 ; then
        printf "${GREEN}[OK]${WHITE}\n"
        rclone purge gcrypt:/Test
else
        printf "${RED}[FAIL]${WHITE}\n"
fi

# Test personal backup mirror

printf "[Home] Chris Backup (Mirror)... "

# Test torrenting backup

printf "[Home] Torrenting Backup... "

# Test torrenting backup mirror

#printf "[Home] Torrenting Backup (Mirror)... "

printf "${NC}"
