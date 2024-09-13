#!/bin/sh
echo "Below is the status of QAT-prod jumpoint "

aws ec2 describe-instance-status \
    --instance-ids i-086ae91c3ed9bd4ad

