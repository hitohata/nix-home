{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        spacing = 10;
        
        modules-left = [
          "custom/power"
          "custom/menu"
          "tray"
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        
        modules-right = [
          "custom/weather"
          "pulseaudio"
          "network"
          "temperature"
          "keyboard-state"
          "battery"
          "bluetooth"
          "custom/notification"
          "clock"
        ];

        # Keyboard state
        keyboard-state = {
          numlock = true;
          capslock = false;
          format = "{icon}{name}";
          format-icons = {
            locked = " ";
            unlocked = " ";
          };
        };

        # Hyprland modules
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };

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

        # Tray
        tray = {
          icon-size = 21;
          spacing = 5;
          show-passive-items = true;
        };

        # Clock
        clock = {
          format = "{:%a %d %b %Y | %H:%M}";
          tooltip-format = "<big><tt><small>{calendar}</small></tt></big>";
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

        # Temperature
        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°C {icon}";
          format-icons = ["" "" ""];
          tooltip-format = "Temperature: {temperatureC}°C";
        };

        # Battery
        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "Battery: {capacity}%\n{timeTo}";
        };

        # Network
        network = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "Connected ";
          tooltip-format = "{ifname} via {gwaddr}\nIP: {ipaddr}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "notify-send 'Network Info' \"Interface: {ifname}\nIP Address: {ipaddr}\nGateway: {gwaddr}\" -t 5000";
          on-click-right = "nm-connection-editor";
        };

        # Pulseaudio
        pulseaudio = {
          on-click = "pavucontrol";
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          tooltip-format = "Volume: {volume}%";
        };

        # Bluetooth
        bluetooth = {
          format = "";
          format-off = "";
          format-on = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip = true;
          tooltip-format = "Controller: {controller_alias}\nAddress: {controller_address}\nStatus: {status}";
          tooltip-format-connected = "Controller: {controller_alias}\nAddress: {controller_address}\nConnected: {device_alias} ({device_address})\nBattery: {device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        # Custom weather (simple version without scripts)
        "custom/weather" = {
          format = "{}°";
          tooltip = true;
          interval = 3600;
          exec = "curl -s 'https://wttr.in/?format=1' | sed 's/[+°]//g'";
          return-type = "";
        };

        # Custom notification (SwayNC)
        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "sleep 0.1 && swaync-client -d -sw";
          escape = true;
        };

        # Custom power menu
        "custom/power" = {
          format = " ⏻ ";
          tooltip = "Power Menu";
          on-click = "wlogout --protocol layer-shell";
        };

        # Custom menu
        "custom/menu" = {
          format = "{icon} Menu";
          format-icons = [""];
          tooltip = "Open Menu";
          on-click = "rofi -show drun";
        };
      };
    };

    style = ./styles/waybar.css;
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "waybar"
    ];
  };
}
