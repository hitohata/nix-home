-- flutter-tools owns the Dart LSP; do not also enable dartls via lspconfig.
-- Discover Flutter/Dart from PATH so project-specific SDK environments work.
require("flutter-tools").setup {
  lsp = {
    capabilities = _G.lsp_capabilities,
    settings = {
      completeFunctionCalls = true,
      enableSnippets = true,
      updateImportsOnRename = true,
    },
  },
  widget_guides = { enabled = true },
  dev_log = {
    enabled = true,
    open_cmd = "botright 15split",
    focus_on_open = false,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("DartFlutterKeymaps", { clear = true }),
  pattern = "dart",
  callback = function(args)
    local function map(lhs, command, desc)
      vim.keymap.set("n", lhs, "<cmd>" .. command .. "<cr>", {
        buffer = args.buf,
        silent = true,
        desc = desc,
      })
    end

    map("<leader>dr", "FlutterRun", "Flutter: run")
    map("<leader>dh", "FlutterReload", "Flutter: hot reload")
    map("<leader>dR", "FlutterRestart", "Flutter: hot restart")
    map("<leader>dq", "FlutterQuit", "Flutter: quit")
    map("<leader>dd", "FlutterDevices", "Flutter: devices")
    map("<leader>de", "FlutterEmulators", "Flutter: emulators")
    map("<leader>dl", "FlutterLogToggle", "Flutter: toggle logs")
    map("<leader>do", "FlutterOutlineToggle", "Flutter: widget outline")
  end,
})
