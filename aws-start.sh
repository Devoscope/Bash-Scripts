#!/bin/sh
echo "Starting QAT-prod jumpoint "
date
aws ec2 start-instances --instance-ids i-0c1928487b86ece18
sleep 5;
echo "Starting QAT-prod jumpoint."
