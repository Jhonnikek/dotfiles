#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
STATE_FILE="$HOME/.config/hypr/current.wall" 

apply_wallpaper() {
    local wallpaper_path="$1"
    
    if [ -n "$wallpaper_path" ] && [ -f "$wallpaper_path" ]; then
        hyprctl hyprpaper preload "$wallpaper_path"
        hyprctl hyprpaper wallpaper ",$wallpaper_path"
    else
        echo "Error: The wallpaper file was not found in '$wallpaper_path'."
    fi
}

case "$1" in
    "init")
        sleep 0.5

        if [ -s "$STATE_FILE" ]; then
            LAST_WALL=$(cat "$STATE_FILE")
            apply_wallpaper "$LAST_WALL"
        else
            RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
            apply_wallpaper "$RANDOM_WALL"
            echo "$RANDOM_WALL" > "$STATE_FILE"
        fi
        ;;

    *)
        CURRENT_WALL=$(cat "$STATE_FILE" 2>/dev/null)
        
        NEW_WALL=$(find "$WALLPAPER_DIR" -type f ! -path "$CURRENT_WALL" | shuf -n 1)

        apply_wallpaper "$NEW_WALL"
        echo "$NEW_WALL" > "$STATE_FILE"
        ;;
esac