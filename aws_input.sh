#!/bin/bash
instance_id="i-0c1928487b8xxxx"
echo "Hey user, this script will start/stop your $instance_id"
# Ask the user for their input
echo "Do you want to start or stop the script (enter start/stop)?"
read varname
#echo "You chose to $varname the instance. Please confirm (yes/no)?"
#read input
#if $input == "yes"; then
aws ec2 $varname-instances --instance-ids $instance_id
echo "Starting instance $instance_id."
#else
#echo Please try again.
#fi