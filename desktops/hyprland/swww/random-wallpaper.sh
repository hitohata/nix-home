#!/usr/bin/env bash

WALLPAPER_DIR="${1:-$HOME/Pictures/wallpapers}"

if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Directory not found: $WALLPAPER_DIR"
  exit 1
fi

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
  echo "Error: No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

~/.local/bin/set-wallpaper "$WALLPAPER"
