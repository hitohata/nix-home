{ pkgs, ... }: {
  home.packages = [ pkgs.libnotify ];

  services.mako = {
    enable = true;
    backgroundColor = "#1e1e2eaa";
    borderColor = "#89b4fa";
    borderRadius = 8;
    borderSize = 2;
    defaultTimeout = 5000;
    font = "sans-serif 10";
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "mako"
  ];
}
