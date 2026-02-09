#!/usr/bin/env bash

WALLPAPER_DIR="${1:-$HOME/Pictures/wallpapers}"

# Follow symlinks with -L
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Directory not found: $WALLPAPER_DIR"
  exit 1
fi

WALLPAPER=$(find -L "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
  echo "Error: No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

$HOME/.local/bin/set-wallpaper "$WALLPAPER"
