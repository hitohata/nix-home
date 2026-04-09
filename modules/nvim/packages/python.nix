{ pkgs, ... }: { 
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-dap
      nvim-dap-python
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./python.lua}
    '';
  };

  home.packages = with pkgs; [
    pyright
    ruff
    python3Packages.debugpy
  ];
}

