# Set random terminal background image from wallpapers
# Changes background periodically

_set_terminal_background() {
  local IMG_DIR="$HOME/Pictures/wallpapers"
  local CONFIG_FILE="$HOME/.config/ghostty/config"

  # Check if config file exists
  [ ! -f "$CONFIG_FILE" ] && return

  # Check if wallpaper directory exists
  [ ! -d "$IMG_DIR" ] && return

  # Select random image (png, jpg, jpeg, webp)
  local SELECTED_IMG
  SELECTED_IMG=$(find -L "$IMG_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | shuf -n 1)

  if [ -n "$SELECTED_IMG" ]; then
    # Update background-image line in Ghostty config
    if grep -q "^background-image = " "$CONFIG_FILE" 2>/dev/null; then
      sed -i "s|^background-image = .*|background-image = $SELECTED_IMG|" "$CONFIG_FILE" 2>/dev/null
    fi
  fi
}

# Start background loop if not already running
_start_terminal_background_loop() {
  local LOCK_FILE="/tmp/terminal-background-loop-$$.lock"
  local INTERVAL=300  # 5 minutes
  
  # Set initial background
  _set_terminal_background
  
  # Run loop in background
  (
    while true; do
      sleep "$INTERVAL"
      _set_terminal_background
    done
  ) &>/dev/null &
  disown
}

_start_terminal_background_loop
