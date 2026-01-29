{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = rust-tools-nvim;
    type = "lua";
    config = ''
      require("rust-tools").setup {
        server = {
          on_attach = _G.lsp_on_attach,
          capabilities = _G.lsp_capabilities,
        },
      }
    '';
  }
]

