{ pkgs, ... }: {
  home.packages = [ pkgs.libnotify pkgs.swaynotificationcenter ];

  # Use SwayNC (Sway Notification Center) instead of mako for better Wayland support
  services.mako = {
    enable = false;  # Disable mako in favor of swaync
  };

  # SwayNC configuration
  home.file.".config/swaync/style.css".text = ''
    * {
      font-family: "JetBrains Mono Nerd Font";
      font-weight: bold;
      font-size: 14px;
    }

    .notification {
      background-color: rgba(30, 30, 46, 0.95);
      border: 2px solid rgba(137, 180, 250, 0.5);
      border-radius: 12px;
      padding: 10px;
      margin: 5px;
    }

    .notification-default {
      border-left: 4px solid #89b4fa;
    }

    .notification-critical {
      border-left: 4px solid #f38ba8;
    }

    .notification-low {
      border-left: 4px solid #a6adc8;
    }

    .control-center {
      background-color: rgba(30, 30, 46, 0.95);
      border: 2px solid rgba(137, 180, 250, 0.5);
      border-radius: 12px;
    }

    .notification-row {
      outline: none;
      background-color: transparent;
    }

    .notification-row:hover {
      background-color: rgba(137, 180, 250, 0.2);
    }

    .notification-content {
      padding: 8px;
    }

    .summary {
      font-weight: bold;
      color: #cdd6f4;
    }

    .body {
      color: #a6adc8;
    }

    .close-button {
      background-color: #f38ba8;
      color: #1e1e2e;
      border-radius: 6px;
      padding: 4px;
    }

    .close-button:hover {
      background-color: #eba0ac;
    }
  '';

  home.file.".config/swaync/config.json".text = builtins.toJSON {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "overlay";
    layer-shell = true;
    cssPriority = "user";
    control-center-margin-top = 10;
    control-center-margin-bottom = 10;
    control-center-margin-right = 10;
    control-center-margin-left = 10;
    notification-2fa-action = true;
    notification-inline-replies = false;
    notification-icon-size = 64;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 5;
    timeout-low = 3;
    timeout-critical = 0;
    fit-to-screen = true;
    control-center-width = 400;
    control-center-height = 600;
    notification-window-width = 400;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "swaync"
  ];
}
