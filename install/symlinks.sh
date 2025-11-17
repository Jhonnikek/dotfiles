#!/usr/bin/env bash

for f in "$HOME/dotfiles/.config/"*; do
    file=$(basename "$f")
    if [ -e "$HOME/.config/$file" ]; then
        echo "'$file' exists, creating backup..."
        mv "$HOME/.config/$file" "$HOME/.config/$file.bak"
    fi
    echo "Linking $f"
    ln -sfn "$f" "$HOME/.config/"
done

echo "Linking walls"
ln -sfn $HOME/dotfiles/walls $HOME/Pictures/

echo "Linking zsh"
ln -sfn $HOME/dotfiles/.zshrc $HOME/.zshrc

echo "Linking scripts"
ln -sfn $HOME/dotfiles/scripts $HOME/.local/bin