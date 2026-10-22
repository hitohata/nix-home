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
        vim.keymap.set("n", "<C-i>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
      end

      -- Make on_attach global for other plugins
      _G.lsp_on_attach = on_attach

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      _G.lsp_capabilities = capabilities

      -- LSP on_attach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
        end,
      })

      -- Python
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        capabilities = capabilities,
      }
      vim.lsp.enable("pyright")

      -- CSpell
      vim.lsp.config.cspell = {
        cmd = { "cspell-lsp", "--stdio" },
        filetypes = { "markdown", "text", "gitcommit", "nix", "lua", "typescript", "javascript", "python" },
        root_markers = { ".git", "cspell.json", ".cspell.json" },
        capabilities = capabilities,
      }
      vim.lsp.enable("cspell")
    '';
  }
]
