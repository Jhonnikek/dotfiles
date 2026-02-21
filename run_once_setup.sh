#!/usr/bin/env bash

set -e

dir=$CHEZMOI_SOURCE_DIR

bash "$dir/scripts/install.sh"

bash "$dir/scripts/ssh.sh"

bash "$dir/scripts/icons.sh"

chsh -s $(which zsh)
