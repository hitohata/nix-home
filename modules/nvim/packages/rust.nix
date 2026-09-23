{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rustaceanvim
      crates-nvim
      nvim-dap
    ];
  };

  home.packages = with pkgs; [
    rust-analyzer
    cargo
    rustc
    clippy
    vscode-extensions.vadimcn.vscode-lldb
  ];
}
