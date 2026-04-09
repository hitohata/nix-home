{ pkgs, pkgs-unstable, ... }:
let
  luaConfig = builtins.readFile ./lua/init.lua;

  # Plugins
  corePlugins = import ./plugins/core.nix { inherit pkgs; };
  uiPlugins = import ./plugins/ui.nix { inherit pkgs; };
  completionPlugins = import ./plugins/completion.nix { inherit pkgs; };
  languagePlugins = import ./plugins/languages.nix { inherit pkgs; };

  # Packages
  toolsPackages = import ./packages/tools.nix { inherit pkgs; };
in
{
  imports = [
    ./packages/rust.nix
    ./packages/python.nix
    ./packages/nix.nix
    ./packages/typescript.nix
    ./packages/lua.nix
  ];
  programs.neovim = {
    enable = true;    
    defaultEditor = true;
    
    plugins = corePlugins
      ++ uiPlugins
      ++ completionPlugins
      ++ languagePlugins;

    extraLuaConfig = luaConfig;

    extraPackages = toolsPackages;
  };
}
