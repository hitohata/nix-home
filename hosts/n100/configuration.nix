# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/nas.nix
      ../shared/avahi.nix
      ../../services/immich.nix
      ../../services/homepage.nix
      ../../services/k3s/k3s_server.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "n100"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh = {
    enable = true;
    settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
    };
    extraConfig = ''
      ClientAliveInterval 30
      ClientAliveCountMax 3
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hoge = {
    isNormalUser = true;
    description = "hoge";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPecawIGB5QnbVGj1g0My61YdryyuAVysqu2r87tND1J m3"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIrxRnkBpffDfzvAiNkkpRA3jIMfEiZQmAJW9WoCjwV node"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEzr66JjoWf5GhDxiaPWx7wz113IgZFQTIt9jtllRvW x1"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    nix
  ];

  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

  programs.hyprland.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
