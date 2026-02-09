{
  # Window rules
  windowrule = [
    # Terminal transparency
    "opacity 0.80 0.80,^(ghostty)$"
    "opacity 0.80 0.80,^(Alacritty)$"
    
    # Float rules
    "float,class:org.pulseaudio.pavucontrol"
    "center,class:org.pulseaudio.pavucontrol"
    
    "float,class:blueman-manager"
    "center,class:blueman-manager"
    
    "float,class:nm-connection-editor"
    "center,class:nm-connection-editor"
    
    "float,class:waypaper"
    "center,class:waypaper"
    
    "float,class:Tk"
    "center,class:Tk"
    
    "float,class:qalculate-gtk"
    
    # Suppress maximize events
    "suppressevent maximize,class:.*"
    
    # Fix dragging issues with XWayland
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
  ];

  # Layer rules
  layerrule = [
    "dimaround,wofi"
    "blur,waybar"
    "ignorezero,waybar"
  ];

  # Workspace rules
  windowrulev2 = [
    # Idle inhibit for fullscreen apps
    "idleinhibit fullscreen,class:.*"
    "idleinhibit focus,class:^(mpv)$"
    "idleinhibit focus,title:^(.*YouTube.*)$"
  ];
}
