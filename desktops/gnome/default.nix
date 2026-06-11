{ ... }:

{
  # Enable the X11 windowing system.
  services.desktopManager.gnome.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.displayManager.gdm.enable = true;
  services.desktopManager.gnome.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
