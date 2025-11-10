#!/bin/bash

LOGO_DIR="$HOME/.config/fastfetch/logos"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"

SELECTED_LOGO=$(find "$LOGO_DIR" -type f -name "*.txt" | shuf -n 1)

jq --arg logoPath "$SELECTED_LOGO" \
    '.logo.source = $logoPath' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

fastfetch -c "$CONFIG_FILE"