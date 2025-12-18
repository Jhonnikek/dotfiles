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

sudo pacman -Syu --needed --noconfirm git
echo -e ":: Cloning repo\n"
git clone https://github.com/Jhonnikek/dotfiles.git
cd dotfiles

source "$HOME/dotfiles/install/utils.sh"

echo -e "\n:: Installing apps\n"
source "$HOME/dotfiles/install/apps.sh"
echo -e "\nApps installed\n"

echo -e ":: Creating symlinks\n"
source "$HOME/dotfiles/install/symlinks.sh"
echo -e "\nSymlinks created"

echo -e "\n:: Setting up git"
source "$HOME/dotfiles/install/git-setup.sh"
echo -e "Completed\n"

echo "::Copying plasma config"
source "$HOME/dotfiles/install/plasma.sh"

echo -e "\nSetup completed"

read -p ":: Reboot now? [Y/n]: " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo -e "\nRebooting system"
    sleep 3
    systemctl reboot
else
    echo -e "\nSkipping reboot"
fi