{ lib, enableTerminal, ... }: {
  imports = [
    ./zellij.nix
    ./ghostty.nix
  ];

  # Enable the whole graphical terminal group. Add other emulators here.
  config = lib.mkIf enableTerminal {
    programs.ghostty.enable = true;
  };
}
