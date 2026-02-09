{
  # Window rules using windowrule (Firstp1ck style)
  windowrule = [
    # Suppress maximize events
    "suppressevent maximize, class:.*"
    
    # XWayland video bridge
    "opacity 0.0 override, class:xwaylandvideobridge"
    "noanim, class:xwaylandvideobridge"
    "noinitialfocus, class:xwaylandvideobridge"
    "maxsize 1 1, class:xwaylandvideobridge"
    "noblur, class:xwaylandvideobridge"
    "nofocus, class:xwaylandvideobridge"
    
    # Float rules
    "float, class:org.pulseaudio.pavucontrol"
    "center, class:org.pulseaudio.pavucontrol"
    
    "float, class:blueman-manager"
    "center, class:blueman-manager"
    
    "float, class:nm-connection-editor"
    "center, class:nm-connection-editor"
    
    "float, class:waypaper"
    "center, class:waypaper"
    
    "float, class:Tk"
    "center, class:Tk"
    
    "float, class:qalculate-gtk"
    
    # Terminal notes
    "float, class:ghostty, title:Notes"
    "center, class:ghostty, title:Notes"
    "size 800 600, class:ghostty, title:Notes"
  ];

  # Windowrulev2 for more complex rules
  windowrulev2 = [
    # Terminal transparency
    "opacity 0.80 0.80, class:^(ghostty)$"
    "opacity 0.80 0.80, class:^(Alacritty)$"
    
    # Idle inhibit
    "idleinhibit fullscreen, class:.*"
    "idleinhibit focus, class:^(mpv)$"
    "idleinhibit focus, title:^(.*YouTube.*)$"
  ];

  # Layer rules
  layerrule = [
    "dimaround, wofi"
    "blur, waybar"
    "ignorezero, waybar"
  ];
}
