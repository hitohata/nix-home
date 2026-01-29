{ pkgs, pkgs-unstable, ... }:
let
  luaConfig = builtins.readFile ./lua/init.lua;
in
{
  programs.neovim = {
    enable = true;    
    defaultEditor = true;
    
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      gruvbox-nvim
      telescope-nvim
    ];

    extraLuaConfig = luaConfig;

    extraPackages = with pkgs; [
      nil
      ripgrep
      fd
    ];
  };
}
