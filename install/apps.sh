#!/usr/bin/env bash

apps=(
  alacritty
  anytype-bin
  atuin
  bat
  btop
  chafa
  code
  docker
  duf
  fastfetch
  fzf
  go
  jq
  lazydocker
  lazygit
  less
  lsd
  npm
  nvim
  openssh
  pacman-contrib
  postgresql
  python-uv
  starship
  ttf-cascadia-code-nerd
  wl-clipboard
  zellij
  zoxide
  zsh
)

services=(
  docker.service
  postgresql.service
)

for app in "${apps[@]}"; do
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

#load autin offline config
atuin import auto
