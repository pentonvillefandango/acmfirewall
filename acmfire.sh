#!/bin/bash
VERSION='v0.4'
# acmfirewall script
#
# This script will Interrogate/Activate/Deactviate the acm firewall for one or more IPs / CIDR blocks

# help function
    
acmfirehelp() {
    echo
    echo " 
    This script enables the user to block a range of CIDRs from the active query function, list the 
    CIDRs that are currently blocked, and unblock ranges of CIDRs to enable active query again.

    Usage is as follows:

    acmfire.sh -h                     Display this help function
    acmfire.sh -l                     Display the currently blocked CIDRs
    acmfire.sh -b path/to/inputfile   Blocks the CIDRs listed in the inputfile
    acmfire.sh -u path/to/inputfile   Blocks the CIDRs listed in the inputfile

    The format expected for inputfile is as follows:

    10.23.45.0/24
    10.33.45.0/24

    Blocking/Unblocking single IPs is possible by using a 32 bit subnet mask as follows:

    192.168.1.23/32

    IPs without a following subnet mask are not permitted and may cause unpredictable results.
    
    The curent version ${VERSION} has very little error handling and expects an accurate inputfile
    to be provided.
    "

}

filenotexist() {
    if [[ ! -f $1 ]]
        then
            echo "No file provided or does not exist - please check the filename and path"
            exit 1
    fi
}   
# detelgy function

dtelegy() {
    path=$1
    shift
    curl "http://127.0.0.1:8083/v1/$path" -H '_token_info: {"username": "admin", "role": "AdminRole", "groups": ["b4373447-c6d1-4c57-bd9a-ec895de5d26f"]}' "$@"
}

# Check user is root

if [[ ${UID} -ne 0 ]]
    then
        echo "This script needs superuser rights  - Please use sudo"
        exit 1
fi

# process arguments

while getopts ulhb OPTION
do
    case ${OPTION} in
        h)
            acmfirehelp
            exit 0
            ;;
        u)
            MODE='unblock'
            OPERATION='-XDELETE'
            echo
            echo "All CIDRs in supplied file will be UNBLOCKED"
            echo    
            ;;
        b)
            MODE='block'
            OPERATION='-XPOST'
            echo
            echo "All CIDRs in supplied file will be BLOCKED"
            echo
            ;;
        l)
            MODE='list'
            echo
            echo "BLOCKED CIDRs will be LISTED"
            echo
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

INPUTFILE=${1}

if [[ "${MODE}" != 'list' ]]
    then
        filenotexist ${INPUTFILE}
fi

# main script block

if [[ "${MODE}" = 'list' ]]
    then
        dtelegy activeclients/firewall -XGET | jq -jr '.[] | .target, "\n"' | sed s/null// | sed 's/Type//'
        echo
        echo 'All blocked CIDRs have been listed'
        echo 
elif [[ "${MODE}" = 'unblock' ]] 
    then
        # detelegy unblock
        UNBLOCKED=0
        while read CIDR
            do
                dtelegy activeclients/firewall $OPERATION -d '{"target": "'"$CIDR"'"}'
                echo "$CIDR"
                (( UNBLOCKED++ ))
            done < ${INPUTFILE}
            echo
            echo "$UNBLOCKED CIDRs have been unblocked"
            echo
elif [[ "${MODE}" = 'block' ]]
    then
        # dtelegy block
        BLOCKED=0
        while read CIDR
            do
                dtelegy activeclients/firewall $OPERATION -d '{"target": "'"$CIDR"'"}'
                echo "$CIDR"
                (( BLOCKED++ ))
            done < ${INPUTFILE}      
            echo
            echo "$BLOCKED CIDRs have been blocked"
            echo    
fi

