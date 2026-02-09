#!/usr/bin/env bash

WALLPAPER="$1"

if [ -z "$WALLPAPER" ]; then
  echo "Usage: set-wallpaper <path-to-image>"
  exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
  echo "Error: File not found: $WALLPAPER"
  exit 1
fi

# Random transition effects
TRANSITIONS=("fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer")
POSITIONS=("center" "top" "left" "right" "bottom" "top-left" "top-right" "bottom-left" "bottom-right")

TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
POSITION=${POSITIONS[$RANDOM % ${#POSITIONS[@]}]}
ANGLE=$((RANDOM % 360))

swww img "$WALLPAPER" \
  --resize crop \
  --transition-type "$TRANSITION" \
  --transition-step 255 \
  --transition-duration 1 \
  --transition-fps 60 \
  --transition-angle "$ANGLE" \
  --transition-pos "$POSITION"
