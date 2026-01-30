{ pkgs, pkgs-unstable, ... }: {
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  # to avoid man-db conflict
  manual.manpages.enable = false;
  home.enableNixpkgsReleaseCheck = false;

  # Module imports
  imports = [
    ./modules/nvim/default.nix
    ./modules/bash/default.nix
    ./modules/packages/default.nix
  ];
}
