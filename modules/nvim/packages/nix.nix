{ pkgs, ... }: {
  programs.neovim = {
    extraLuaConfig = ''
      ${builtins.readFile ./nix.lua}
    '';
  };

  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
