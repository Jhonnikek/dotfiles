#!/usr/bin/env bash

set -e

dir=$CHEZMOI_SOURCE_DIR

bash "$dir/scripts/install.sh"

bash "$dir/scripts/ssh.sh"

bash "$dir/scripts/icons.sh"

git clone https://github.com/Jhonnikek/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

chsh -s $(which zsh)
