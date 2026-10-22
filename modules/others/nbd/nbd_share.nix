{ pkgs, ... }:

let
  # Custom script to share a slice of RAM/Storage as an NBD swap server
  nbd-share = pkgs.writeShellScriptBin "nbd-share" ''
    set -euo pipefail

    # ==============================================================================
    # Script: nbd-share
    # Description: Allocates a temporary swap file and exports it over the network
    #              using Network Block Device (NBD) to assist low-memory nodes (e.g., RPi Zero).
    # Usage: 
    #   nbd-share on [size_gb]  - Starts the NBD server (Default: 4GB)
    #   nbd-share off           - Stops the server and cleans up temporary files
    # ==============================================================================

    ACTION=''${1:-""}
    SIZE_GB=''${2:-4} # Default to 4GB if size is not specified

    EXPORT_DIR="/tmp/nbd-export"
    SWAP_FILE="$EXPORT_DIR/swapspace"
    CONFIG_FILE="$EXPORT_DIR/nbd-server.conf"

    case "$ACTION" in
      on)
        echo "Starting NBD server with ''${SIZE_GB}GB space..."
        mkdir -p "$EXPORT_DIR"
        
        # 1. Create a zero-filled file and initialize it as a swap area using Nix-managed utilities
        ${pkgs.coreutils}/bin/dd if=/dev/zero of="$SWAP_FILE" bs=1M count=$((SIZE_GB * 1024)) status=progress
        ${pkgs.util-linux}/bin/mkswap "$SWAP_FILE" >/dev/null

        # 2. Generate a minimal runtime configuration for nbd-server
        cat <<EOF > "$CONFIG_FILE"
[generic]
    user = root
    group = root
[nix-swap]
    exportname = $SWAP_FILE
EOF

        # 3. Start the NBD server daemon in the background using the specified configuration
        sudo ${pkgs.nbd}/bin/nbd-server -C "$CONFIG_FILE"
        echo "NBD server is now running on port 10809."
        ;;

      off)
        echo "Stopping NBD server..."
        # Terminate the running nbd-server process and wipe out the temporary directory
        sudo killall nbd-server || true
        sudo rm -rf "$EXPORT_DIR"
        echo "NBD server stopped and swap file cleaned up."
        ;;

      *)
        echo "Usage: nbd-share [on|off] [size_gb]"
        echo "Example: nbd-share on 2  (Shares 2GB swap)"
        exit 1
        ;;
    esac
  '';
in
{
  home.packages = [ nbd-share ];
}
