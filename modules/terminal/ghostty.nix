{ pkgs, config, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.9;
      background-image = "${config.home.homeDirectory}/Pictures/wallpapers/.gitkeep";
      background-image-opacity = 0.2;
      background-image-fit = "cover";
    };
  };

  # Force overwrite existing config
  xdg.configFile."ghostty/config".force = true;
}
