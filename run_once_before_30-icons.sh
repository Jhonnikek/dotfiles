#!/usr/bin/env bash

mkdir -p "$HOME/.local/share/icons/"
for i in "$HOME/.local/share/chezmoi/icons/"*; do
  tar -xzf "$i" -C "$HOME/.local/share/icons/"
done
