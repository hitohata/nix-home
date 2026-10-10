{
  "$mainMod" = "SUPER";

  # Application variables
  "$terminal" = "ghostty";
  "$fileManager" = "nautilus";
  "$menu" = "wofi --show drun";
  "$locker" = "swaylock -f";
  "$browser" = "firefox";
  "$editor" = "code";

  bind = [
    # Familiar GNOME-style actions
    "$mainMod, A, exec, pkill wofi || $menu"
    "$mainMod, L, exec, $locker"
    "ALT, TAB, cyclenext,"
    "ALT SHIFT, TAB, cyclenext, prev"
    "$mainMod, PAGE_DOWN, workspace, e+1"
    "$mainMod, PAGE_UP, workspace, e-1"
    "$mainMod SHIFT, PAGE_DOWN, movetoworkspace, e+1"
    "$mainMod SHIFT, PAGE_UP, movetoworkspace, e-1"
    ", PRINT, exec, grim - | wl-copy"
    "SHIFT, PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"

    # Everyday applications
    "$mainMod, RETURN, exec, $terminal"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, B, exec, $browser"
    "$mainMod, C, exec, $editor"

    # Window behavior
    "ALT, F4, killactive,"
    "$mainMod, Q, fullscreenstate, 3 0"
    "$mainMod, V, togglefloating,"
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    # Directional window focus and movement
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod SHIFT, left, movewindow, l"
    "$mainMod SHIFT, right, movewindow, r"
    "$mainMod SHIFT, up, movewindow, u"
    "$mainMod SHIFT, down, movewindow, d"

    # Numbered workspaces remain available for quick access.
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

    # A convenient mouse alternative to the touchpad gesture.
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
    "$mainMod, N, exec, swaync-client -t -sw"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  bindel = [
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
  ];

  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
  ];
}
