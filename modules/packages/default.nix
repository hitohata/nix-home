{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    curl
    xclip
    fastfetch

    # File tools
    tree
    file
    unzip
    zip

    # Search tools
    ripgrep
    fd
    fzf

    # File managers
    yazi
    bat

    # Process tools
    htop
    btop

    # Git tools
    git
    lazygit
    gh

    # Network tools
    jq
    yq

    # Development tools
    gnumake
    cmake

    # dot dir
    direnv
    nix-direnv
    
    # secrets
    sops
    age

    # nix tools
    comma # https://github.com/nix-community/comma
  ];
}

