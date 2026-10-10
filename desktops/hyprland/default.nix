{ pkgs, ... }: {
  home.packages = with pkgs; [
    grim
    slurp
    swaylock
    wl-clipboard
  ];

  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./wofi.nix
    ./moko.nix
    ./wlogout.nix
    ./swww.nix
  ];
}
