{ pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--ozone-platform=x11"
    ];
  };
}
