{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = gruvbox-nvim;
    type = "lua";
    config = ''
      require("gruvbox").setup {}
      vim.cmd("colorscheme gruvbox")
    '';
  }
  {
    plugin = telescope-nvim;
    type = "lua";
    config = ''
      require("telescope").setup {}
    '';
  }
]

