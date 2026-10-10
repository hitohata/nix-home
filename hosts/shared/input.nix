{ pkgs, ... }: {
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus = {
        engines = with pkgs.ibus-engines; [ mozc ];
        # Plasma Wayland starts IBus through KWin's virtual-keyboard bridge.
        # Do not load the legacy Qt/GTK IBus modules in that session: they
        # bypass the bridge and leave Mozc in direct (Latin) input mode.
        waylandFrontend = true;
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
