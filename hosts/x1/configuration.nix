{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/input.nix
      ../shared/avahi.nix
      ../../desktops/gnome
      ../../desktops/kde
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "x1"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,jp";
    options = "grp:win_ctrl_toggle";
  };

  services.tailscale = {
    enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hoge = {
    isNormalUser = true;
    description = "hoge";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # for screen share
  xdg.portal = {
    enable = true;
    # GNOME's portal implements the ScreenCast API used by browser and
    # Electron meeting clients. Keep GTK as the fallback for other portals.
    config.gnome.default = [ "gnome" "gtk" ];
  };

  # The Home Manager Hyprland module otherwise exports a portal directory that
  # contains only the Hyprland backend, hiding GNOME's ScreenCast portal.
  home-manager.users.hoge.xdg.portal.enable = lib.mkForce false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "26.05"; # Did you read the comment?

  # dynamic binary
  programs.nix-ld.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
