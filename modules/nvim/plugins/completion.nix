{ pkgs, ... }: with pkgs.vimPlugins; [
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  luasnip
  cmp_luasnip

  # GitHub Copilot (inline suggestions)
  {
    plugin = copilot-lua;
    type = "lua";
    config = ''
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            open = "<M-CR>",
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            accept_word = "<M-k>",
            accept_line = "<M-j>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          gitcommit = true,
          gitrebase = true,
        },
      }
    '';
  }

  # Avante.nvim - Cursor-like AI IDE experience
  dressing-nvim
  plenary-nvim
  nui-nvim
  {
    plugin = avante-nvim;
    type = "lua";
    config = ''
      require("avante").setup {
        provider = "copilot",
        copilot = {
          model = "claude-3.7-sonnet",  -- or "gpt-4o"
        },
        behaviour = {
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          minimize_diff = true,
        },
        hints = { enabled = true },
        windows = {
          position = "right",
          width = 40,
          sidebar_header = {
            align = "center",
            rounded = true,
          },
        },
      }

      -- Keybindings
      local map = vim.keymap.set
      map("n", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante: Ask" })
      map("v", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante: Ask with selection" })
      map("n", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "Avante: Edit" })
      map("v", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "Avante: Edit selection" })
      map("n", "<leader>ar", "<cmd>AvanteRefresh<cr>", { desc = "Avante: Refresh" })
      map("n", "<leader>at", "<cmd>AvanteToggle<cr>", { desc = "Avante: Toggle" })
    '';
  }

  {
    plugin = nvim-cmp;
    type = "lua";
    config = ''
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    '';
  }
]

