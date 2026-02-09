{ pkgs, ... }: {
  home.packages = [ pkgs.wofi ];
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.alacritty}/bin/alacritty";
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
      height = 500;
      location = "center";
      show = "drun";
      prompt = "Apps";
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
    
    style = ./styles/wofi.css;
  };
}
