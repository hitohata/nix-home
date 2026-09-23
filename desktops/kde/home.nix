{ pkgs, lib, ... }:

{
  imports = [ ./shortcuts.nix ];

  gtk = {
    enable = true;
    theme = lib.mkDefault {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };
}
