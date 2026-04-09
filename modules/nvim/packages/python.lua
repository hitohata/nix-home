if vim.lsp.config then
  vim.lsp.config('pyright', {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForType = true,
          diagnosticMode = "workspace",
        },
      }
    }
  })
  vim.lsp.enable('pyright')

  vim.lsp.config('ruff', {
    on_attach = function(client, bufnr)
      vim.api.nvim_crate_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.bug.format({ async = false })
          vim.lsp.bug.code_action({
            context = { only = { "source.fixAll.ruff" } },
            apply = true,
          })
        end,
      })
    end,
  })
else
  local lspconfig = require('lspconfig')
  lspconfig.pyright.setup({})
  lspconfig.ruff.setup({})
end

require('dap-python').setup('python3')
