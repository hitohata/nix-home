{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    curl

    # File tools
    tree
    file
    unzip
    zip

    # Search tools
    ripgrep
    fd
    fzf

    # Process tools
    htop
    btop

    # Git tools
    lazygit
    gh

    # Network tools
    jq
    yq

    # Development tools
    gnumake
    cmake
  ];
}

