{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
  };

  # Use config files directly from waybar directory
  xdg.configFile = {
    "waybar/config.jsonc".source = ./waybar/config.jsonc;
    "waybar/style.css".source = ./waybar/style.css;
  };
}
