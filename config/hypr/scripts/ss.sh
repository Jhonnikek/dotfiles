#!/bin/bash

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${SS_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures/Screenshots}}"

mkdir -p "$OUTPUT_DIR"

FILENAME="$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

pkill slurp || hyprshot -m ${1:-region} --raw |
  satty --filename - \
    --output-filename "$FILENAME" \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --copy-command 'wl-copy'

if [[ -f "$FILENAME" ]]; then
    notify-send "Screenshot" "Saved and copied to clipboard" -i "$FILENAME" -t 3000
fi