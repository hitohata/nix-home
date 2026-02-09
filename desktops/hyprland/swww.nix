{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    swww
  ];

  # Copy wallpapers from repo to ~/Pictures/wallpapers (managed by Nix)
  # Add/remove wallpapers in the repo's wallpapers/ dir, then rebuild
  home.file."Pictures/wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };

  # Scripts for wallpaper management
  home.file.".local/bin/set-wallpaper" = {
    executable = true;
    source = ./swww/set-wallpaper.sh;
  };

  home.file.".local/bin/random-wallpaper" = {
    executable = true;
    source = ./swww/random-wallpaper.sh;
  };

  home.file.".local/bin/wallpaper-loop" = {
    executable = true;
    source = ./swww/wallpaper-loop.sh;
  };
}
