{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    wlogout
  ];

  xdg.configFile = {
    "wlogout/layout".source = ./wlogout/layout;
    "wlogout/style.css".source = ./wlogout/style.css;
  };
}
