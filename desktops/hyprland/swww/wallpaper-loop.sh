#!/usr/bin/env bash

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

INTERVAL="${1:-180}"  # Default 3 minutes (180 seconds)

while true; do
  $HOME/.local/bin/random-wallpaper
  sleep "$INTERVAL"
done
