{ pkgs, pkgs-unstable, inputs, ... }: {
  home.packages = [
    inputs.codex-cli.packages.${pkgs.system}.default
    # The official desktop app includes Codex alongside ChatGPT.
    pkgs-unstable.chatgpt
  ];
}
