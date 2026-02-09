{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        
        modules-left = [
          "hyprland/workspaces"
          "mpris"
        ];
        
        modules-center = [
          "memory"
          "cpu"
          "temperature"
        ];
        
        modules-right = [
          "idle_inhibitor"
          "battery"
          "backlight"
          "pulseaudio"
          "network"
          "clock"
          "tray"
        ];

        # Hyprland modules
        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace r-1";
          on-scroll-down = "hyprctl dispatch workspace r+1";
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # System modules
        memory = {
          format = "󰍛 {}%";
          tooltip-format = "RAM: {used:0.1f}GB / {total:0.1f}GB";
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip-format = "CPU: {usage}%";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["󰔐" "󱃃" "󰸁" "󱃂" "󰸂"];
          tooltip-format = "Temperature: {temperatureC}°C";
        };

        # Idle inhibitor
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
          tooltip-format-activated = "Idle inhibitor: ON";
          tooltip-format-deactivated = "Idle inhibitor: OFF";
        };

        # Battery
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "Battery: {capacity}%\n{timeTo}";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          on-scroll-down = "brightnessctl set 5%-";
          on-scroll-up = "brightnessctl set +5%";
          tooltip-format = "Brightness: {percent}%";
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-bluetooth = "󰂰 {volume}%";
          format-muted = "󰖁 muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡏";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -ui 2";
          on-scroll-down = "pamixer -ud 2";
          tooltip-format = "Volume: {volume}%";
        };

        network = {
          format = "{ifname}";
          format-wifi = "󰖩 {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰖪 Disconnected";
          tooltip-format = "󰈀 {ifname} via {gwaddri}";
          tooltip-format-wifi = "󰖩 {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz";
          tooltip-format-ethernet = "󰈀 {ifname}\nIP: {ipaddr}";
          tooltip-format-disconnected = "󰖪 Disconnected";
          max-length = 50;
          on-click = "notify-send 'Network Info' \"Interface: {ifname}\nIP Address: {ipaddr}\nGateway: {gwaddr}\" -t 5000";
          on-click-right = "nm-connection-editor";
        };

        clock = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%d/%m/%Y  %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          interval = 1;
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          max-length = 50;
          player-icons = {
            default = "󰝚";
            mpv = "󰐹";
            spotify = "󰓇";
            firefox = "󰈹";
          };
          status-icons = {
            paused = "󰏤";
            playing = "󰐊";
            stopped = "󰓛";
          };
          tooltip-format = "{player}: {dynamic}";
        };

        tray = {
          icon-size = 20;
          spacing = 10;
          show-passive-items = true;
          reverse-direction = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: 'JetBrains Mono', 'Hack Nerd Font', monospace;
        font-size: 14px;
        font-weight: 600;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: rgba(15, 15, 20, 0.3);
        border-bottom: 1px solid rgba(149, 127, 184, 0.3);
      }

      tooltip {
        background: rgba(30, 30, 46, 0.95);
        color: #cdd6f4;
        border: 1px solid #89b4fa;
        border-radius: 8px;
        padding: 8px 12px;
      }

      #workspaces {
        background: rgba(30, 30, 46, 0.8);
        padding: 4px;
        margin: 6px 2px;
        border-radius: 12px;
        border: 2px solid rgba(137, 180, 250, 0.3);
      }

      #workspaces button {
        padding: 6px 10px;
        margin: 0 2px;
        background: rgba(30, 30, 46, 0.8);
        color: #a6adc8;
        border-radius: 8px;
        font-weight: bold;
        border: 1px solid rgba(137, 180, 250, 0.2);
      }

      #workspaces button:hover {
        background: rgba(49, 50, 68, 0.9);
        color: #b4befe;
        border-color: #cba6f7;
      }

      #workspaces button.active {
        background: #cba6f7;
        color: #1e1e2e;
        font-weight: bold;
        border-color: #f5c2e7;
      }

      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
        border-color: #eba0ac;
      }

      #clock {
        background: #89b4fa;
        color: #1e1e2e;
        font-weight: bold;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
        font-size: 15px;
      }

      #memory {
        background: rgba(30, 30, 46, 0.8);
        color: #a6e3a1;
        border-left: 4px solid #a6e3a1;
        border-radius: 12px 0 0 12px;
        margin: 6px 0;
        padding: 8px 12px;
      }

      #cpu {
        background: rgba(30, 30, 46, 0.8);
        color: #89b4fa;
        border-left: 4px solid #89b4fa;
        margin: 6px 0;
        padding: 8px 12px;
      }

      #temperature {
        background: rgba(30, 30, 46, 0.8);
        color: #94e2d5;
        border-left: 4px solid #94e2d5;
        border-radius: 0 12px 12px 0;
        margin: 6px 2px 6px 0;
        padding: 8px 12px;
      }

      #temperature.critical {
        background: #f38ba8;
        color: #1e1e2e;
        border-left: 4px solid #eba0ac;
      }

      #battery {
        background: rgba(30, 30, 46, 0.8);
        color: #a6e3a1;
        border-left: 4px solid #a6e3a1;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #battery.charging {
        color: #f9e2af;
        border-left: 4px solid #f9e2af;
      }

      #battery.warning {
        background: #fab387;
        color: #1e1e2e;
        border-left: 4px solid #fab387;
      }

      #battery.critical:not(.charging) {
        background: #f38ba8;
        color: #1e1e2e;
        border-left: 4px solid #eba0ac;
      }

      #backlight {
        background: rgba(30, 30, 46, 0.8);
        color: #f9e2af;
        border-left: 4px solid #f9e2af;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #pulseaudio {
        background: rgba(30, 30, 46, 0.8);
        color: #f9e2af;
        border-left: 4px solid #f9e2af;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #pulseaudio.muted {
        color: #a6adc8;
        border-left: 4px solid #a6adc8;
      }

      #network {
        background: rgba(30, 30, 46, 0.8);
        color: #a6e3a1;
        border-left: 4px solid #a6e3a1;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #network.disconnected {
        color: #f38ba8;
        border-left: 4px solid #f38ba8;
      }

      #mpris {
        background: rgba(30, 30, 46, 0.8);
        color: #a6e3a1;
        border-left: 4px solid #a6e3a1;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #tray {
        background: rgba(49, 50, 68, 0.8);
        padding: 6px 10px;
        margin: 6px 2px;
        border-radius: 12px;
        border: 1px solid rgba(137, 180, 250, 0.2);
      }

      #idle_inhibitor {
        background: rgba(30, 30, 46, 0.8);
        color: #f9e2af;
        border-left: 4px solid #f9e2af;
        margin: 6px 2px;
        padding: 8px 12px;
        border-radius: 12px;
      }

      #idle_inhibitor.activated {
        background: #f9e2af;
        color: #1e1e2e;
      }
    '';
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "waybar"
    ];
  };
}
