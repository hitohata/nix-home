{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.codex-cli.packages.${pkgs.system}.default
  ];
}
