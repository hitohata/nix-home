{ pkgs, ... }: with pkgs; [
  ripgrep
  fd
  lazygit
  # Node.js (required for Copilot)
  nodejs

  # Spell checker
  cspell
]
# Linux only
++ lib.optionals stdenv.isLinux [
  # Clipboard support
  xclip
  xsel
  wl-clipboard  # For Wayland
]

