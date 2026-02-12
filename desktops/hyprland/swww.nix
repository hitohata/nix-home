{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    swww
  ];

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
