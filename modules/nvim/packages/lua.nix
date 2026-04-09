{ pkgs, ... }: {
  programs.neovim = {
    extraLuaConfig = ''
      ${builtins.readFile ./lua.lua}
    '';
  };

  home.packages = with pkgs; [
    lua-language-server
    stylua
  ];
}
