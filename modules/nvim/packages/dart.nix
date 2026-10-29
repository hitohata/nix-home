{ pkgs, lib, ... }: {
  # Configure after the core LSP plugin has initialized shared capabilities.
  programs.neovim.plugins = lib.mkAfter [
    {
      plugin = pkgs.vimPlugins.flutter-tools-nvim;
      type = "lua";
      config = builtins.readFile ./dart.lua;
    }
  ];
}
