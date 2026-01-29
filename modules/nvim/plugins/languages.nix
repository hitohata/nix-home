{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = rustaceanvim;
    type = "lua";
    config = ''
      vim.g.rustaceanvim = {
        server = {
          on_attach = _G.lsp_on_attach,
          capabilities = _G.lsp_capabilities,
        },
      }
    '';
  }
]

