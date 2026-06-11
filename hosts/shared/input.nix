{ pkgs, ... }: {
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };
  };

  # for Wayland
  environment.variables = {
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    GTK_IM_MODULE = "ibus";
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
