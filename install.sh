#!/usr/bin/env bash

logo='
██╗  ██╗███████╗██╗  ██╗██████╗  ██████╗ ████████╗███████╗
██║ ██╔╝██╔════╝██║ ██╔╝██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
█████╔╝ █████╗  █████╔╝ ██║  ██║██║   ██║   ██║   ███████╗
██╔═██╗ ██╔══╝  ██╔═██╗ ██║  ██║██║   ██║   ██║   ╚════██║
██║  ██╗███████╗██║  ██╗██████╔╝╚██████╔╝   ██║   ███████║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝'

clear
echo -e "\n$logo\n"

sudo pacman -Syu git --noconfirm --needed
echo -e "Cloning repo\n"
git clone https://github.com/Jhonnikek/dotfiles.git 
cd dotfiles

echo -e "Creating symlinks...\n"
source $HOME/dotfiles/install/symlinks.sh
echo "Symlinks created."

echo -e "\nInstalling apps...\n"
source $HOME/dotfiles/install/apps.sh
echo -e "\nApps installed.\n"

read -p "-Do you want to install devtools? [y/N]: " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    source $HOME/dotfiles/install/devtools.sh
    echo "Devtools installed."
else
    echo -e "\nSkipping devtools..."
fi

echo -e "\nSetup complete."