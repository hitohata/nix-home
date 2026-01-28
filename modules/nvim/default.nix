{ pkgs, pkgs-unstable, ... }: {
  programs.neovim = {
    enable = true;    
    defaultEditor = true;
    
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      gruvbox-nvim
      telescope-nvim
    ];

    extraLuaConfig = ''
      vim.opt.number = te
      vim.cmd("colorscheme gruvbox")
    '';

    extraPackages = with pkgs; [
      nil
      ripgrep
      fd
    ];
  };
}
