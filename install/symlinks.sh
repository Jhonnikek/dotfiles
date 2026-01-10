#!/usr/bin/env bash

for f in "$HOME/dotfiles/dots/.config/"*; do
    ln -sfn "$f" "$HOME/.config/"
done

ln -s "$HOME/dotfiles/walls" "$HOME/Pictures/"

ln -sfn "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/dotfiles/dots/scripts/"* "$HOME/.local/bin"

mkdir -p "$HOME/.config/Code - OSS/User/"
ln -sfn "$HOME/dotfiles/dots/code/settings.json" "$HOME/.config/Code - OSS/User/settings.json"
cat "$HOME/dotfiles/dots/code/extensions.txt" | xargs -L 1 code-oss --install-extension

mkdir -p "$HOME/.local/share/icons/"
for i in "$HOME/dotfiles/dots/icons/"*; do
    tar -xzf "$i" -C "$HOME/.local/share/icons/"
done