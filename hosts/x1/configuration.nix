{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/input.nix
      ../shared/avahi.nix
      ../../desktops/gnome
      ../../desktops/kde
      ../../desktops/hyprland/system.nix
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

  # GDM presents every installed desktop session at login. Keep this choice
  # local to x1; individual desktop modules only enable their own session.
  services.displayManager.gdm.enable = true;

  home-manager.users.hoge.imports = [
    ../../desktops/gnome/home.nix
    ../../desktops/kde/home.nix
    ../../desktops/hyprland/default.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hoge = {
    isNormalUser = true;
    description = "hoge";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "26.05"; # Did you read the comment?

  # dynamic binary
  programs.nix-ld.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
