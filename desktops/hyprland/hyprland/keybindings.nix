{
  "$mainMod" = "SUPER";
  "$mainMod1" = "CTRL";
  "$mainMod2" = "SHIFT";
  "$mainMod3" = "ALT";

  # Application variables
  "$terminal" = "ghostty";
  "$fileManager" = "nautilus";
  "$menu" = "wofi --show drun";
  "$browser" = "firefox";
  "$editor" = "code";

  # Open Programs
  bind = [
    "$mainMod, SPACE, exec, pkill wofi || $menu"
    "$mainMod1, Y, exec, $terminal"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, F, exec, $browser"
    "$mainMod, C, exec, $editor"
    "$mainMod, RETURN, exec, $terminal"
    
    # Window behavior
    "$mainMod, X, killactive,"
    "$mainMod, Q, fullscreenstate, 3 0"
    "$mainMod, V, togglefloating,"
    "$mainMod, B, pseudo,"
    "$mainMod, N, togglesplit,"
    
    # Special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"
    
    # Focus movement
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    
    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"
    "$mainMod, k, movefocus, u"
    "$mainMod, j, movefocus, d"
    
    # Window movement
    "$mainMod SHIFT, left, movewindow, l"
    "$mainMod SHIFT, right, movewindow, r"
    "$mainMod SHIFT, up, movewindow, u"
    "$mainMod SHIFT, down, movewindow, d"
    
    "$mainMod SHIFT, h, movewindow, l"
    "$mainMod SHIFT, l, movewindow, r"
    "$mainMod SHIFT, k, movewindow, u"
    "$mainMod SHIFT, j, movewindow, d"
    
    # Workspace switching
    ", F1, workspace, 1"
    ", F2, workspace, 2"
    ", F3, workspace, 3"
    ", F4, workspace, 4"
    ", F5, workspace, 5"
    ", F6, workspace, 6"
    ", F7, workspace, 7"
    ", F8, workspace, 8"
    ", F9, workspace, 9"
    ", F10, workspace, 10"
    
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"
    
    # Move window to workspace
    "$mainMod2, F1, movetoworkspace, 1"
    "$mainMod2, F2, movetoworkspace, 2"
    "$mainMod2, F3, movetoworkspace, 3"
    "$mainMod2, F4, movetoworkspace, 4"
    "$mainMod2, F5, movetoworkspace, 5"
    "$mainMod2, F6, movetoworkspace, 6"
    "$mainMod2, F7, movetoworkspace, 7"
    "$mainMod2, F8, movetoworkspace, 8"
    "$mainMod2, F9, movetoworkspace, 9"
    "$mainMod2, F10, movetoworkspace, 10"
    
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"
    
    # Scroll through workspaces
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
    
    # Notification center
    "$mainMod, grave, exec, swaync-client -t -sw"
  ];

  # Mouse bindings
  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  # Laptop multimedia keys
  bindel = [
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
  ];

  # Media player controls
  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
  ];
}
