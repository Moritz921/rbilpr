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
    ssh-copy-id "$(username)@adrastos.rbi.cs.uni-frankfurt.de"
fi

# ssh part
echo "Adding ssh config for rbi servers"
./populateSSHconfig.sh $username

# rbi part
echo "Do you want to copy the rbilpr file to rbi servers? (y/n)"
while true; do
    read answer
    if [ "$answer" = "y" ]; then
        scp rbilpr rbi:~/
        break
    elif [ "$answer" = "n" ]; then
        break
    else
        echo "Please enter y or n"
    fi
done
if [ "$answer" = "y" ]; then
    echo "Creating directories on rbi servers and copying files"
    scp remotelpr rbi:~/
    scp setupRBI.sh rbi:~/
    ssh rbi "chmod +x setupRBI.sh && ./setupRBI.sh"
    ssh rbi "rm setupRBI.sh"
fi

# local part
# check if rbilpr file is already linked to local bin or bin directory
if [ ! -h ~/.local/bin/rbilpr ] && [ ! -h ~/bin/rbilpr ]; then
    echo "Do you want to symlink the rbilpr file to your local bin directory? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
        ln -s $(pwd)/rbilpr ~/.local/bin/rbilpr
        chmod +x ./rbilpr
        echo "rbilpr file linked to ~/.local/bin"
    fi
else

# autocompletions for zsh
# check if using ZSH and oh-my-zsh is installed
if [ -n "$ZSH_VERSION" ] && [ -d "$ZSH" ] && [ ! -h ~/.oh-my-zsh/completions/_rbilpr ]; then
    echo "Do you want to add autocompletions for rbilpr? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
        if [ ! -d ~/.oh-my-zsh/completions ]; then
            mkdir ~/.oh-my-zsh/completions
        fi
        ln -s $(pwd)/_rbilpr ~/.oh-my-zsh/completions/_rbilpr
        echo "Autocompletions added for rbilpr"
    fi
fi
fi

exit 0
