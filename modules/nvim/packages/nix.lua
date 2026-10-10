local capabilities = _G.lsp_capabilities

vim.lsp.config.nil_ls = {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
  capabilities = capabilities,
}
vim.lsp.enable("nil_ls")
