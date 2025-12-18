#!/usr/bin/env bash

if ! command -v yay &> /dev/null; then
    echo ":: Installig yay"
    sudo pacman -S --needed --noconfirm git base-devel
    
    echo ":: Cloning yay repo"
    git clone https://aur.archlinux.org/yay.git /tmp/yay_install
    
    echo ":: Compiling yay"
    cd /tmp/yay_install
    makepkg -si --noconfirm

    cd ~
    rm -rf /tmp/yay_install
    
    echo ":: Yay installed"
else
    echo ":: Yay is already installed"
fi