#!/bin/sh

mkdir -p PDF
mkdir -p scripts

mv remotelpr scripts/

echo "export PATH=$PATH:$(pwd)/scripts" >> ~/.bashrc