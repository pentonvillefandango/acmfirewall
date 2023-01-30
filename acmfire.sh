#!/bin/bash

# acmfirewall v0.1
#
# This script will Interrogate/Activate/Deactviate the acm firewall for one or more IPs / CIDR
# -v verbose -h help -f file -l log -b block -u unblock - i interogate -h header
# WARNING - not everything above is implemented yet. See README.md for details of this version


# Check user is root
if [[ ${UID} -ne 0 ]]
then
    echo "This script needs superuser rights  - Please use sudo"
    exit 1
fi

# Check provided file exists

if [[ ! -f ${1} ]]
then
    echo "file provided does not exist - please check the filename and path"
    exit 1
fi


# process arguments




# usage function



# log function



# help function


# dtelegy function


# report funntion

