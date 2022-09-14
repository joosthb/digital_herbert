#!/bin/bash

if [ -z $1 ]
then
  echo "Please define SSH target eg; example@raspberrypi"
  exit 1
fi

ssh -q $1 "sudo apt-get update && sudo apt-get upgrade -y"
ssh -q $1 "sudo apt-get install -y git"
ssh -q $1 "ssh-keygen -q -t rsa -b 2048 -N \"\" -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub"
echo "Add key above to github repo as deployment key and press enter..."
read
echo "Enter github author info for future commits"
echo "E-mail:"
read EMAIL
ssh -q $1 "git config --global user.email \"$EMAIL\""
echo "Full name:"
read FULLNAME
ssh -q $1 "git config --global user.name \"$FULLNAME\""

# auto accept fingerprint (unsafe)
ssh -q $1 "ssh-keyscan github.com >> ~/.ssh/known_hosts"
# clone repo to default config dir
ssh -q $1 "git clone git@github.com:joosthb/digital_herbert.git ~/.homeassistant"