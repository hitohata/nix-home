{ pkgs, ... }: {
  home.packages = [ pkgs.wofi ];
  
  programs.wofi = {
    enable = true;
    settings = {
      width = 400;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search Apps...";
      filter_rate = 100;
      allow_images = true;
    };
  };
}
