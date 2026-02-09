{ pkgs, config, lib, ... }: 
let
  nixHomeDir = "${config.home.homeDirectory}/nix-home";
in
{
  home.packages = with pkgs; [
    swww
  ];

  # Symlink wallpapers directory - use mkOutOfStoreSymlink for live updates
  home.file."Pictures/wallpapers".source = 
    config.lib.file.mkOutOfStoreSymlink "${nixHomeDir}/wallpapers";

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
