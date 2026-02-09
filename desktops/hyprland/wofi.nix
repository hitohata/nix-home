{ pkgs, ... }: {
  home.packages = [ pkgs.wofi pkgs.rofi-wayland ];
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "~/.config/rofi/theme.rasi";
    extraConfig = {
      modi = "run,drun,window";
      font = "JetBrains Mono Nerd Font 14";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = false;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Window";
      sidebar-mode = true;
    };
  };

  # Fallback wofi config
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search Apps...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
    
    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font";
        font-size: 14px;
      }

      window {
        background-color: rgba(30, 30, 46, 0.95);
        border: 2px solid rgba(137, 180, 250, 0.5);
        border-radius: 12px;
      }

      #input {
        margin: 10px;
        padding: 10px;
        background-color: rgba(49, 50, 68, 0.8);
        color: #cdd6f4;
        border: 2px solid rgba(137, 180, 250, 0.3);
        border-radius: 8px;
      }

      #inner-box {
        margin: 5px;
        padding: 5px;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        padding: 5px;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        padding: 5px;
      }

      #text {
        margin: 5px;
        padding: 5px;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: rgba(203, 166, 247, 0.3);
        border-radius: 8px;
      }

      #entry:selected #text {
        color: #cba6f7;
        font-weight: bold;
      }
    '';
  };
}
