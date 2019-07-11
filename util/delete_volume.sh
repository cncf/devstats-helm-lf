#!/bin/bash
if [ -z "$AWS_PROFILE" ]
then
  echo "$0: you must set AWS_PROFILE=..."
  exit 1
fi
if [ -z "$1" ]
then
  echo "$0: you must specify volume-id, like vol-05d73f1686cbfe351"
  exit 2
fi
if [ -z "$2" ]
then
  aws ec2 detach-volume --volume-id "$1" --force
else
  aws ec2 detach-volume --volume-id "$1" --force --instance-id "$2"
fi
aws ec2 delete-volume --volume-id "$1"
