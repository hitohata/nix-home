{
  input = {
    # Match the US/Japanese layout switching configured for GNOME on x1.
    kb_layout = "us,jp";
    kb_variant = "";
    kb_model = "";
    kb_options = "grp:win_space_toggle";
    kb_rules = "";
    numlock_by_default = true;

    follow_mouse = 1;
    sensitivity = 0.0;
    accel_profile = "flat";
    force_no_accel = true;
    scroll_factor = 1.0;

    touchpad = {
      natural_scroll = true;
      tap-to-click = true;
      drag_lock = true;
      disable_while_typing = true;
    };
  };

  # Three-finger horizontal swipes behave like GNOME workspace swipes.
  # Hyprland 0.55 moved the finger count/action into a separate gesture rule.
  gesture = [
    "3, horizontal, workspace"
  ];

  gestures = {
    workspace_swipe_distance = 300;
    workspace_swipe_invert = false;
    workspace_swipe_min_speed_to_force = 30;
    workspace_swipe_cancel_ratio = 0.5;
    workspace_swipe_create_new = true;
    workspace_swipe_forever = true;
  };
}
