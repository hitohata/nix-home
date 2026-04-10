{ pkgs, ... }: {
  programs.neovim = {
    extraLuaConfig = ''
      ${builtins.readFile ./typescript.lua}
    '';
  };

  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.typescript
  ];
}
