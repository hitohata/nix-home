{ pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    theme = lib.mkDefault {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };
}
