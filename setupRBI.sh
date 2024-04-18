#!/bin/sh

# check if PDF and scripts directory exists
if [ ! -d "PDF" ]; then
    mkdir -p PDF
fi
if [ ! -d "scripts" ]; then
    mkdir -p scripts
fi

# if remotelpr in scripts dir already exists, replace it with new one
if [ -f "scripts/remotelpr" ]; then
    echo "remotelpr file already exists in scripts directory"
    echo "Do you want to replace it with the new one? (y/n)"
    while true; do
        read answer
        if [ "$answer" = "y" ]; then
            rm scripts/remotelpr
            break
        elif [ "$answer" = "n" ]; then
            break
        else
            echo "Please enter y or n"
        fi
    done
    if [ "$answer" = "n" ]; then
        exit 0
    fi
fi

mv remotelpr scripts/

# check if scripts dir is already in PATH
if [[ ":$PATH:" == *":$(pwd)/scripts:"* ]]; then
    echo "scripts directory is already in PATH"
else
    echo "export PATH=$PATH:$(pwd)/scripts" >> ~/.bashrc
fi