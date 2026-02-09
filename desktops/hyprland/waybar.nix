{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        margin-left = 10;
        margin-right = 10;
        margin-top = 7;
        margin-bottom = 0;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        reload_style_on_change = true;

        # Module positions
        modules-left = ["custom/smallspacer" "hyprland/workspaces" "custom/spacer" "mpris"];
        modules-center = ["custom/padd" "custom/l_end" "custom/r_end" "hyprland/window" "custom/padd"];
        modules-right = ["custom/padd" "custom/l_end" "tray" "network" "pulseaudio" "backlight" "battery" "memory" "cpu" "clock" "custom/padd"];

        # Custom modules
        "custom/smallspacer" = {
          format = " ";
        };

        "custom/spacer" = {
          format = "|";
        };

        "custom/padd" = {
          format = "  ";
          interval = "once";
          tooltip = false;
        };

        "custom/l_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/r_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        # Hyprland modules
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
          };
        };

        "hyprland/window" = {
          format = "<span weight='bold'>{class}</span>";
          max-length = 120;
          icon = false;
          icon-size = 13;
        };

        # System modules
        memory = {
          interval = 1;
          rotate = 270;
          format = "{icon}";
          format-icons = ["󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
          max-length = 10;
        };

        cpu = {
          interval = 1;
          format = "{icon}";
          rotate = 270;
          format-icons = ["󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
        };

        clock = {
          format = "{:%I:%M %p}";
          rotate = 0;
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        network = {
          tooltip = true;
          format-wifi = "{icon} ";
          format-icons = ["󰤟" "󰤢" "󰤥"];
          rotate = 0;
          format-ethernet = "󰈀 ";
          tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = " ";
          tooltip-format-disconnected = "Disconnected";
          interval = 2;
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon}";
          rotate = 0;
          format-charging = "<span color='#a6d189'>󱐋</span>";
          format-plugged = "󰂄";
          format-icons = ["󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
        };

        backlight = {
          device = "intel_backlight";
          rotate = 0;
          format = "{icon}";
          format-icons = ["󰃞" "󰃝" "󰃟" "󰃠"];
          scroll-step = 1;
          min-length = 2;
        };

        pulseaudio = {
          format = "{icon}";
          rotate = 0;
          format-muted = "婢";
          tooltip-format = "{icon} {desc} // {volume}%";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "<span color='grey'>{status_icon} {dynamic}</span>";
          max-length = 50;
          player-icons = {
            default = "⏸";
            mpv = "🎵";
          };
          status-icons = {
            paused = "▶";
          };
        };

        tray = {
          icon-size = 16;
          rotate = 0;
          spacing = 3;
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrains Mono Nerd Font";
          font-weight: bold; 
          font-size: 15px;
      }

      window#waybar {
          background: #0F0F17; 
          border: 3px solid rgba(255, 255, 255, 0.1);
          border-radius: 10px;
      }

      tooltip {
          background: #171717;
          color: #A1BDCE;
          font-size: 13px;
          border-radius: 7px;
          border: 2px solid #101a24;
      }

      #workspaces {
          background: rgba(23, 23, 23, 0.0);
          color: #888789;
          box-shadow: none;
          text-shadow: none;
          border-radius: 9px;
          transition: 0.2s ease;
          padding-left: 4px;
          padding-right: 4px;
          padding-top: 1px;
      }

      #workspaces button {
          background: rgba(23, 23, 23, 0.0);
          color: #A1BDCE;
          box-shadow: none;
          text-shadow: none;
          border-radius: 9px;
          transition: 0.2s ease;
          padding-left: 4px;
          padding-right: 4px;
      }

      #workspaces button.active {
          color: #A1BDCE;   
          transition: all 0.3s ease;
          padding-left: 4px;
          padding-right: 4px;
      }

      #workspaces button:hover {
          background: none;
          color: #72D792;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #custom-spacer {
          opacity: 0.0;
      }

      #custom-smallspacer {
          opacity: 0.0;
      }

      #backlight {
          color: #2096C0;
          background: rgba(23, 23, 23, 0.0);
          font-weight: normal;
          font-size: 19px;
          margin: 1px 0px 0px 0px;
          padding-left: 0px;
          padding-right: 2px;
      }

      #battery {
          font-weight: normal;
          font-size: 22px;
          color: #a6d189;
          background: rgba(23, 23, 23, 0.0);
          opacity: 1;
          margin: 0px 0px 0px 0px;
          padding-left: 0px;
          padding-right: 0px;
      }

      #battery.charging, #battery.plugged {
          color: #E8EDF0;
      }

      #battery.critical:not(.charging) {
          color: red;
      }

      #clock {
          color: #A1BDCE;
          font-size: 15px;
          font-weight: 900;
          font-family: "JetBrains Mono Nerd Font";
          background: rgba(23, 23, 23, 0.0);
          opacity: 1;
          margin: 3px 0px 0px 0px;
          padding-left: 10px;
          padding-right: 10px;
          border: none;
      }

      #pulseaudio {
          font-weight: normal;
          font-size: 18px;
          color: #6F8FDB;
          background: rgba(22, 19, 32, 0.0);
          opacity: 1;
          margin: 0px 0px 0px 0px;
          padding-left: 3px;
          padding-right: 3px;
      }

      #cpu {
          font-weight: normal;
          font-size: 22px;
          color: #915CAF;
      }

      #memory {
          font-weight: normal;
          font-size: 22px;
          color: #E4C9AF;
      }

      #mpris {
          color: white;
          font-size: 15px;
          font-weight: bold;
          animation: blink 3s linear infinite alternate;
      }

      @keyframes blink {
          to {
              color: #4a4a4a;
          }
      }

      #network {
          color: #A1BDCE;
          font-weight: normal;
          font-size: 19px;
          padding-right: 0px;
          padding-left: 4px;
      }

      #tray, #window {
          color: #A1BDCE;
          font-family: "Martian Mono";
      }

      #custom-l_end, #custom-r_end {
          color: #a6d189;
      }

      #custom-r_end {
          border-radius: 0px 7px 7px 0px;
          margin-right: 1px;
          padding-right: 3px;
      }

      #custom-l_end {
          border-radius: 7px 0px 0px 7px;
          margin-left: 1px;
          padding-left: 3px;
      }
    '';
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "waybar"
    ];
  };
}
