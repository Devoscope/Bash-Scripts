#!/bin/sh
echo "Starting QAT-prod jumpoint "
date
aws ec2 start-instances --instance-ids i-0c1928487b86xxxx
sleep 5;
echo "Starting instance i-0c1928487b86xxxx."
