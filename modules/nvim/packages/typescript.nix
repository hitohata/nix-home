{ pkgs, ... }: {
  programs.neovim = {
    extraLuaConfig = ''
      ${builtins.readFile ./typescript.lua}
    '';
  };

  home.packages = with pkgs; [
    typescript-language-server
    typescript
  ];
}
