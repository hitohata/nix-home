{ pkgs, lib, ... }:

{
  imports = [ ./shortcuts.nix ];

  # Make the Plasma IBus Wayland session start in Mozc's Hiragana mode.
  # `mozc-on` is the Mozc engine whose composition mode is explicitly
  # Hiragana; retaining XKB as the other engine keeps English available.
  dconf.settings."desktop/ibus/general" = {
    engines-order = [ "mozc-on" "xkb:us::eng" ];
    preload-engines = [ "mozc-on" "xkb:us::eng" ];
  };

  gtk = {
    enable = true;
    theme = lib.mkDefault {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };
}
