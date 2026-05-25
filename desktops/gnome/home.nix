{ pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [];
      switch-applications-backward = [];
    };
    "org/gnome/shell/keybindings" = {
      switch-applications = [];
      switch-applications-backward = [];
    };
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
      workspaces-only-on-primary = false;
    };
    "org/gnome/shell/overrides" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/interface" = {
      color-schema = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
