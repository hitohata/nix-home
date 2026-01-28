{ pkgs, pkgs-unstable, ... }: {
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  # to avoid man-db conflict
  manual.manpages.enable = false;
  home.enableNixpkgsReleaseCheck = false;

  # Neovim setting
  imports = [ ./modules/nvim/default.nix ]; 
  
  programs.bash = {
    enable = true;
    shellAliases = {
      apply = "nix run github:nix-community/home-manager/release-25.11 -- --impure switch --flake .#root -b backup";
    };
  };
}
