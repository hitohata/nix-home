{ pkgs, ... }: with pkgs.vimPlugins; [
  nvim-treesitter.withAllGrammars
  {
    plugin = nvim-lspconfig;
    type = "lua";
    config = ''
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
      end

      -- Make on_attach global for other plugins
      _G.lsp_on_attach = on_attach

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      _G.lsp_capabilities = capabilities

      local lspconfig = require("lspconfig")

      -- Nix
      lspconfig.nil_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      }

      -- TypeScript
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- Python
      lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    '';
  }
]

