{ pkgs, ... }: {
  home.packages = with pkgs; [
    swww
  ];

  # Symlink wallpapers directory from repo to ~/Pictures/wallpapers
  home.file."Pictures/wallpapers".source = ../../wallpapers;

  # Scripts for wallpaper management
  home.file.".local/bin/set-wallpaper" = {
    executable = true;
    source = ./swww/set-wallpaper.sh;
  };

  home.file.".local/bin/random-wallpaper" = {
    executable = true;
    source = ./swww/random-wallpaper.sh;
  };
}
