#!/usr/bin/env bash

if ! command -v yay &>/dev/null; then
  echo ":: Installig yay"
  sudo pacman -S --needed --noconfirm git base-devel

  echo ":: Cloning yay repo"
  git clone https://aur.archlinux.org/yay.git /tmp/yay_install

  echo ":: Compiling yay"
  cd /tmp/yay_install
  makepkg -si --noconfirm

  cd $HOME
  rm -rf /tmp/yay_install

  echo ":: Yay installed"
else
  echo ":: Yay is already installed"
fi

apps=(
  alacritty
  atuin
  bat
  btop
  chafa
  code
  docker
  duf
  fastfetch
  fd
  fzf
  go
  lazydocker
  lazygit
  less
  lsd
  npm
  nvim
  obsidian
  openssh
  pacman-contrib
  pgcli
  postgresql
  ruff
  starship
  tree
  ttf-cascadia-code-nerd
  ty
  uv
  wl-clipboard
  yazi
  zellij
  zoxide
  zsh
)

echo -e "\n:: Installing packages\n"
for app in "${apps[@]}"; do
  yay -S --needed --noconfirm "${app}"
done

services=(
  docker.service
  postgresql.service
)

for service in "${services[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    echo "Enabling $service"
    sudo systemctl enable "$service"
  else
    echo -e "\n$service is already enabled"
  fi
done
