#!/usr/bin/env bash

systemctl --user stop plasma-plasmashell.service

sleep 3

rm -rf "$HOME/.cache/plasma"* "$HOME/.cache/kwin"*

config_files=(
  "kglobalshortcutsrc"
  "ksplashrc"
  "kdeglobals"
  "plasma-org.kde.plasma.desktop-appletsrc"
  "plasmashellrc"
  "krunnerrc"
  "kwinrc"
)

for file in "${config_files[@]}"; do
  rm -f "$HOME/.config/$file"
  cp "$HOME/dotfiles/dots/plasma/$file" "$HOME/.config/"
done