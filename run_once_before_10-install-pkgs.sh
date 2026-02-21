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

echo -e "\n:: Installing packages\n"
yay -S --needed --noconfirm - < packages.txt

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
