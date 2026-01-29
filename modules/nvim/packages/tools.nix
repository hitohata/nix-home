{ pkgs, ... }: with pkgs; [
  ripgrep
  fd
]
{ pkgs, ... }: with pkgs.vimPlugins; [
  nvim-lspconfig
  nvim-treesitter.withAllGrammars
]

