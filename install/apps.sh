#!/usr/bin/env bash

apps=(
anytype-bin
bat
btop
cava
code
discord
docker
duf
fastfetch
fzf
jq
kitty
lazydocker
lazygit
less
lsd
nvim
openssh
pacman-contrib
postgresql
python-websockets
starship
ttf-cascadia-code-nerd
zellij
zen-browser-bin
zoxide
zsh
plasma6-applets-catwalk
plasma6-applets-kurve
)

services=(
    docker.service
    postgresql.service
)

for app in "${apps[@]}";do
    yay -S --needed --noconfirm "${app}"
done

# enable services
for service in "${services[@]}"; do
    if ! systemctl is-enabled "$service" &>/dev/null; then
        echo "Enabling $service"
        sudo systemctl enable "$service"
    else
        echo -e "\n$service is already enabled"
    fi
done