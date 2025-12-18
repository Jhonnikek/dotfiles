#!/usr/bin/env bash

for f in "$HOME/dotfiles/dots/.config/"*; do
    ln -sfn "$f" "$HOME/.config/"
done

ln -s "$HOME/dotfiles/walls" "$HOME/Pictures/"

ln -sfn "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/dotfiles/dots/scripts/"* "$HOME/.local/bin"

mkdir -p "$HOME/.zen/zen"
ln -sfn "$HOME/dotfiles/dots/zen/profiles.ini" "$HOME/.zen/profiles.ini"
ln -sfn "$HOME/dotfiles/dots/zen/prefs.js" "$HOME/.zen/zen/prefs.js"
ln -sfn "$HOME/dotfiles/dots/zen/chrome" "$HOME/.zen/zen/chrome"
cp "$HOME/dotfiles/dots/zen/sessionstore.jsonlz4" "$HOME/.zen/zen/sessionstore.jsonlz4"

mkdir -p "$HOME/.config/Code - OSS/User/"
ln -sfn "$HOME/dotfiles/dots/code/settings.json" "$HOME/.config/Code - OSS/User/settings.json"
cat "$HOME/dotfiles/dots/code/extensions.txt" | xargs -L 1 code-oss --install-extension

mkdir -p "$HOME/.local/share/icons/"
for i in "$HOME/dotfiles/dots/icons/"*; do
    tar -xzf "$i" -C "$HOME/.local/share/icons/"
done