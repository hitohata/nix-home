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
    
    # Start wallpaper loop (changes every 3 minutes)
    "sleep 2 && $HOME/.local/bin/wallpaper-loop 180"
    
    # Start waybar
    "sleep 1; waybar"
    
    # Set cursor theme
    "hyprctl setcursor rose-pine-hyprcursor 24"
  ];
}
