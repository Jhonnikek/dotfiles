#!/usr/bin/env bash

if command -v yay &>/dev/null; then
  aur=yay
  echo ":: Using $aur"
elif command -v paru &>/dev/null; then
  aur=paru
  echo ":: Using $aur"
else
  aur=None
  echo ":: No aur detected"
fi

if [ "$aur" = "None" ]; then
  echo ":: Installing yay"

  echo ":: Installing dependencies"
  sudo pacman -S --needed --noconfirm git base-devel

  echo ":: Cloning yay repo"
  git clone https://aur.archlinux.org/yay.git /tmp/yay_install

  echo ":: Compiling yay"
  cd /tmp/yay_install || exit
  makepkg -si --noconfirm

  cd "$HOME" || exit
  rm -rf /tmp/yay_install

  echo ":: Yay installed"
  aur=yay
fi

apps=(
  alacritty atuin bat btop docker duf fastfetch fd fzf lazydocker
  lazygit less lsd npm nvim obsidian openssh pacman-contrib pgcli
  postgresql ripgrep ruff starship tree tree-sitter-cli
  ttf-cascadia-code-nerd ty uv wl-clipboard yazi zellij zoxide zsh
)

echo -e "\n:: Installing packages\n"
"$aur" -S --needed --noconfirm "${apps[@]}"

echo -e "\n:: Configuring Services\n"

if [ ! -d "/var/lib/postgres/data" ] || [ -z "$(ls -A /var/lib/postgres/data 2>/dev/null)" ]; then
  echo ":: Initializing db"
  sudo -u postgres initdb -D /var/lib/postgres/data
fi

services=(
  docker.service
  postgresql.service
)

for service in "${services[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    echo "Enabling and starting $service"
    sudo systemctl enable --now "$service"
  else
    echo -e "\n$service is already enabled"
  fi
done
