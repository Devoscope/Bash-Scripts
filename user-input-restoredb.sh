#!/bin/bash
echo "#####################################  WARNING  #####################################"
echo "You are about to restore the UAT database with $1."
echo "#####################################################################################"
echo
VAR_SMALL_Y="y"
VAR_CAP_Y="Y"
VAR_SMALL_N="n"
VAR_CAP_N="N"

read -p "Are you sure you want to proceed? (Y/N)" RESPONSE
if [ $RESPONSE = 'Y' ] || [ $RESPONSE = 'y' ] || [ $RESPONSE = 'N' ] || [ $RESPONSE = 'n' ]
then
        if [ $RESPONSE = 'Y' ] || [ $RESPONSE = 'y' ]
        then
                echo "Starting restore"
                mysql -u <username> -p -h <url> <DB name> < $1
                echo "Restore completed"
        else 
                echo "Restore aborted based on input"
        fi
else
        echo "Incorrect input received"
fi
