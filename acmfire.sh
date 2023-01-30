#!/bin/bash

# acmfirewall v0.1
#
# This script will Interrogate/Activate/Deactviate the acm firewall for one or more IPs / CIDR
# -v verbose -h help -f file -l log -b block -u unblock - l list output -h header
# WARNING - not everything above is implemented yet. See README.md for details of this version
# process arguments

# Check provided file exists function

filexist() {
if [[ ! -f ${1} ]]
then
    echo "No file provided or does not exist - please check the filename and path"
    exit 1
fi
}   

# detelgy function

dtelegy() {
 path=$1

 curl "http://127.0.0.1:8083/v1/$path" -H '_token_info: {"username": "admin", "role": "AdminRole", "groups": ["b4373447-c6d1-4c57-bd9a-ec895de5d26f"]}' "$@"
}




# Check user is root
if [[ ${UID} -ne 0 ]]
then
    echo "This script needs superuser rights  - Please use sudo"
    exit 1
fi




while getopts ulb OPTION
do
    case ${OPTION} in
        u)
            MODE='unblock'
            echo "CIDRs in file will be UNBLOCKED"
            ;;
        b)
            MODE='block'
            echo "CIDRs will be BLOCKED"
            ;;
        l)
            MODE='list'
            echo "BLOCKED CIDRs will be LISTED"
            ;;
        ?)
            # insert usage function later
            echo 'Invalid option' >&2 
            exit 1
            ;;
    esac
done

# Remove options and leave filename

shift "$(( OPTIND -1 ))"

# if requested mode is not list then check if the file exists

if [[ "${MODE}" != 'list' ]]
    then
        filexist ${1}
fi

# main script block
#
if [[ "${MODE}" = 'list' ]]
    then
        dtelegy activeclients/firewall
        echo 'CIDRs have been listed'
elif [[ "${MODE}" = 'unblock' ]] 
    then
        # detelegy unblock
        while read line
            do
               echo "Record is : $line"
               done < testfile      
               echo 'CIDRs have been unblocked'
elif [[ "${MODE}" = 'block' ]]
    then
        # dtelegy block
        echo 'CIDRs have been blocked'
fi
    
    



# process arguments
# usage function
# log function
# help function
# report funntion

