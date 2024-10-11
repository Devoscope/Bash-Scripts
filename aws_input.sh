#!/bin/bash
echo "#####################################  WARNING  #####################################"
echo "You are about to modify the instance."
echo
instance_id="i-0c1928487b8xxxx"

VAR_SMALL_Y="y"
VAR_CAP_Y="Y"
VAR_SMALL_N="n"
VAR_CAP_N="N"
echo "Hey user, this script will start/stop your $instance_id"
echo "Do you want to start or stop the script (enter start/stop)?"
read varname
read -p "Are you sure you want to proceed? (Y/N)" RESPONSE
if [ $RESPONSE = 'Y' ] || [ $RESPONSE = 'y' ] || [ $RESPONSE = 'N' ] || [ $RESPONSE = 'n' ]
then
        if [ $RESPONSE = 'Y' ] || [ $RESPONSE = 'y' ]
        then
                echo "$varname instance"
                aws ec2 $varname-instances --instance-ids $instance_id
                echo "Action completed"
        else 
                echo "Restore aborted based on input"
        fi
else
        echo "Incorrect input received"
fi
