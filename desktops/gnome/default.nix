{ ... }:

{
  # Enable the X11 windowing system.
  services.desktopManager.gnome.enable = true;

  # GNOME desktop services.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
