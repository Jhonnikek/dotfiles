#!/usr/bin/env bash

apps=(
    flatpak
    discord
    kitty
    zsh
    starship
    btop
    fastfetch
    bat
    lsd
    fzf
    zoxide
    duf
    nvim
    jq
    pacman-contrib
    ttf-cascadia-code-nerd
)

gaming_apps=(
    mangohud
    steam
    lutris
    prismlauncher 
)

for app in "${apps[@]}";do
    sudo pacman -S --noconfirm --needed ${app}
done
echo "Apps installed."
read -p "Do you want to install gaming apps? [y/N]: " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo "Installing gaming apps"
    for gaming_app in "${gaming_apps[@]}";do
        sudo pacman -S --noconfirm --needed ${gaming_app}
        yay -S --noconfirm --needed protonplus
    done
else
    echo "Skipping gaming apps..."
fi