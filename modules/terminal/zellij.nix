{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "${pkgs.bash}/bin/bash";
    };
  };
}
