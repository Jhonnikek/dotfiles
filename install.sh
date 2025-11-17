#!/usr/bin/env bash

sudo pacman -Syu git --noconfirm --needed
echo "cloning repo"
git clone https://github.com/Jhonnikek/dotfiles.git 

cd dotfiles

echo "Creating symlinks..."
source $HOME/dotfiles/install/symlinks.sh
echo "Symlinks created."

echo "Installing apps..."
source $HOME/dotfiles/install/apps.sh

read -p "Do you want to install devtools? [y/N]: " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo "Installing devtools"
    source $HOME/dotfiles/install/devtools.sh
else
    echo "Skipping devtools..."
fi

echo "Installation complete."