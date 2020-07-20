#!/bin/bash -x
FILE=$1
USER=$2
SSHPASS=$3 # This is not secure -> 
while IFS= read -r HOST || [ -n "$HOST" ]; do # sets to read each line into var host and for reads the last line without a newline
    echo -e "distributing ssh keys to $HOST"
    sshpass -p $SSHPASS ssh-copy-id -o StrictHostKeyChecking=no $USER@$HOST > /dev/null 2>&1; # Not secure
    # echo "$?"
    STATUS=$? 
    if [[ $STATUS -ne 0 ]]; then    
            if ! ping -c 2 $HOST > /dev/null 2>&1; then
                PINGFAIL+=($HOST) # Array of hosts whose ping failed
                $STATUS=0
            fi
            if [[ $STATUS -eq 1 ]]; then #Ping failed error
                    # echo -e "Authenitcation failed: $HOST \n";
                    AUTHFAIL+=($HOST) # Array of hosts whose authentication failed - Mostly due to no user svc_ansible
            fi
            if [[ $STATUS -eq 5 ]]; then #permission denied error
                    # echo -e "Permission denied: $HOST \n";
                    PERMDENIED+=($HOST) # Array of hosts
            fi
    else
        SUCCESS+=($HOST) # Array of successfull hosts
    fi
    ssh-keyscan $HOST 
done < "$FILE"
echo -e "Authenitcation failed";
printf '%s\n' "${AUTHFAIL[@]}" #Prints hosts which authentication failed
echo -e "Permission denied: Check domain user exists in server";
printf '%s\n' "${PERMDENIED[@]}" #Prints hosts which doesn't have the appropriate permissions
echo -e "Successfully distributed keys";
printf '%s\n' "${SUCCESS[@]}" #Prints the hosts which successfully distributed keys to.

