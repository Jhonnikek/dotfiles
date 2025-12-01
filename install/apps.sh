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
    zellij
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

read -p $'\n-Do you want to install gaming apps? [y/N]: ' confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo -e "\nInstalling gaming apps\n"
    for gaming_app in "${gaming_apps[@]}";do
        sudo pacman -S --noconfirm --needed ${gaming_app}
        yay -S --noconfirm --needed heroic-games-launcher-bin protonplus
    done
else
    echo -e "\nSkipping gaming apps..."
fi