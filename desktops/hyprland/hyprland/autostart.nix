{
  exec-once = [
    # Polkit authentication agent
    "systemctl --user start hyprpolkitagent"
    
    # Notification daemon
    "swaync"
    
    # Network manager applet
    "nm-applet --indicator"
    
    # Bluetooth manager
    "blueman-applet"
    
    # Clipboard manager
    "wl-clip-persist --clipboard regular"
    "wl-clipboard-history -t"
    
    # Wallpaper daemon
    "swww-daemon"
    
    # Set random wallpaper (with delay to ensure swww-daemon is ready)
    "sleep 2 && $HOME/.local/bin/random-wallpaper"
    
    # Start waybar
    "sleep 1; waybar"
    
    # Set cursor theme
    "hyprctl setcursor rose-pine-hyprcursor 24"
  ];
}
