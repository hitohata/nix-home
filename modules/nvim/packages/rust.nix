{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rustaceanvim
      crates-nvim
      nvim-dap
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./rust.lua}
    '';
  };

  home.packages = with pkgs; [
    rust-analyzer
    cargo
    rustc
    clippy
    vscode-extensions.vadimcn.vscode-lldb
  ];
}
