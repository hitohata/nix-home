{ pkgs, pkgs-unstable, configName, lib, isNixOS, ... }: {
  home.stateVersion = "25.11";

  # to avoid man-db conflict
  manual.manpages.enable = false;
  programs.man.enable = false;
  home.enableNixpkgsReleaseCheck = false;

  # Set NIX_HOME_TARGET so 'apply' command knows which config to use
  home.sessionVariables = {
    NIX_HOME_TARGET = configName;
    SHELL = "${pkgs.bash}/bin/bash";
  };

  # On NixOS, the system manages nix, so home-manager shouldn't set nix options
  nix = lib.mkIf (!isNixOS) {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  targets.genericLinux.enable = pkgs.stdenv.isx86_64 && (!isNixOS);

  # Module imports
  imports = [
    ./modules/nvim/default.nix
    ./modules/bash/default.nix
    ./modules/packages/default.nix
    ./modules/dev_modules/default.nix
    ./modules/ui/fonts.nix
    ./modules/terminal/default.nix
  ];
}
