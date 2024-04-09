#!/bin/zsh

if [-z "$@" ]; then
    echo "Please provide your username"
    exit 1
fi

username=$1

# check if rbilpr, remotelpr and populateSSHconfig.sh file exists
if [ ! -f "rbilpr" ]; then
    echo "rbilpr file does not exist"
    exit 1
fi
if [ ! -f "remotelpr" ]; then
    echo "remotelpr file does not exist"
    exit 1
fi
if [ ! -f "populateSSHconfig.sh" ]; then
    echo "populateSSHconfig.sh file does not exist"
    exit 1
fi
if [ ! -f "setupRBI.sh" ]; then
    echo "setupRBI.sh file does not exist"
    exit 1
fi

echo "Warning: you will be prompted for your rbi password multiple times. For more convenience, you can use ssh keys."

# ssh part
echo "Adding ssh config for rbi servers"
./populateSSHconfig.sh $username

# rbi part
echo "Creating directories on rbi servers and copying files"
scp remotelpr rbi:~/
scp setupRBI.sh rbi:~/
ssh rbi "chmod +x setupRBI.sh && ./setupRBI.sh"
ssh rbi "rm setupRBI.sh"

# local part
echo "Do you want to copy the rbilpr file to your local bin directory? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    cp rbilpr ~/.local/bin
    chmod +x ~/.local/bin/rbilpr
    echo "rbilpr file copied to ~/.local/bin"
fi

exit 0
