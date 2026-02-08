{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.hyperland.setting = {
    exec-once = [
      "waybar"
    ];
  }
}
