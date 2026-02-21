{ pkgs, config, lib, ... }: {
  programs.ghostty = {
    enable = true;

    package = if pkgs.stdenv.isDarwin
                then null
                else (builtins.getFlake "github:ghostty-org/ghostty").packages.${pkgs.system}.ghostty;

    settings = {
      background-opacity = 0.85;
      background-image = "${config.home.homeDirectory}/Pictures/wallpapers/.gitkeep";
      background-image-opacity = 0.1;
      background-image-fit = "cover";
    };
  };

  # Force overwrite existing config
  xdg.configFile."ghostty/config".force = true;
}
