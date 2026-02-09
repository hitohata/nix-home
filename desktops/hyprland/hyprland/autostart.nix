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
    
    # Wallpaper daemon and set random wallpaper
    "swww-daemon && sleep 0.5 && random-wallpaper"
    
    # Start waybar
    "sleep 1; waybar"
    
    # Set cursor theme
    "hyprctl setcursor rose-pine-hyprcursor 24"
  ];
}
