{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rustacenvim
      crates-vim
      nvim-dap
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./rust.lua}
    '';
  };
}
