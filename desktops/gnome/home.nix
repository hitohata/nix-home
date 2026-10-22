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

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
