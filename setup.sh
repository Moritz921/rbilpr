#!/bin/zsh

# check if username is provided
if [ -z "$1" ]; then
    echo "No username provided. Exiting..."
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

echo "Do you want to copy your ssh key to rbi servers for passwordless login? (y/n)"
while true; do
    read answer
    if [ "$answer" = "y" ]; then
        ssh-copy-id rbi
        break
    elif [ "$answer" = "n" ]; then
        break
    else
        echo "Please enter y or n"
    fi
done

if [ "$answer" = "y" ]; then
    if [ ! -f "~/.ssh/id_rsa.pub" ]; then
        echo "No ssh key found. Please generate one using ssh-keygen"
        exit 1
    fi
    ssh-copy-id $username@adrastos.rbi.cs.uni-frankfurt.de
fi

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
