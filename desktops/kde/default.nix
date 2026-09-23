{ lib, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
}
