{
  # Hyprland 0.55 uses the unified windowrule syntax.  Rule names and match
  # selectors are snake_case / `match:*`; windowrulev2 is no longer supported.
  windowrule = [
    # Suppress maximize events
    "suppress_event maximize, match:class .*"

    # Preserve the previous global dwindle pseudotile behavior.  In 0.55 this
    # is a window rule rather than a dwindle configuration option.
    "pseudo on, match:class .*"
    
    # XWayland video bridge
    "opacity 0.0 override, match:class xwaylandvideobridge"
    "no_anim on, match:class xwaylandvideobridge"
    "no_initial_focus on, match:class xwaylandvideobridge"
    "max_size 1 1, match:class xwaylandvideobridge"
    "no_blur on, match:class xwaylandvideobridge"
    "no_focus on, match:class xwaylandvideobridge"
    
    # Float rules
    "float on, match:class org.pulseaudio.pavucontrol"
    "center on, match:class org.pulseaudio.pavucontrol"
    
    "float on, match:class blueman-manager"
    "center on, match:class blueman-manager"
    
    "float on, match:class nm-connection-editor"
    "center on, match:class nm-connection-editor"
    
    "float on, match:class waypaper"
    "center on, match:class waypaper"
    
    "float on, match:class Tk"
    "center on, match:class Tk"
    
    "float on, match:class qalculate-gtk"
    
    # Terminal notes
    "float on, match:class ghostty, match:title Notes"
    "center on, match:class ghostty, match:title Notes"
    "size 800 600, match:class ghostty, match:title Notes"

    # Terminal transparency
    "opacity 0.80 0.80, match:class ^(ghostty)$"
    "opacity 0.80 0.80, match:class ^(Alacritty)$"
    
    # Idle inhibit
    "idle_inhibit fullscreen, match:class .*"
    "idle_inhibit focus, match:class ^(mpv)$"
    "idle_inhibit focus, match:title ^(.*YouTube.*)$"
  ];

  # Layer rules
  layerrule = [
    "dim_around on, match:namespace wofi"
    "blur on, match:namespace waybar"
    "ignore_alpha 0.0, match:namespace waybar"
  ];
}
