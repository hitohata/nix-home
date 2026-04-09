vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = { command = "clippy" },
      },
    },
  },
}
require('crates').setup()
