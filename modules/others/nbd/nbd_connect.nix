{ pkgs, ... }:

let
  # Custom script to connect to the remote NBD server and enable network swap
  nbd-connect = pkgs.writeShellScriptBin "nbd-connect" ''
    set -euo pipefail

    # ==============================================================================
    # Script: nbd-connect
    # Description: Connects to a remote NBD server and activates it as a local high-priority 
    #              swap device to prevent OOM errors during heavy workloads (e.g., Nix builds).
    # Usage:
    #   nbd-connect on [server_ip]  - Connects and enables the network swap
    #   nbd-connect off             - Deactivates the swap and disconnects from the server
    # ==============================================================================

    ACTION=''${1:-""}
    SERVER_IP=''${2:-"192.168.x.x"} # Replace with your default RPi5 IP address if needed

    case "$ACTION" in
      on)
        echo "Connecting to NBD server at ''${SERVER_IP}..."
        # 1. Load the Network Block Device kernel module
        sudo modprobe nbd
        
        # 2. Connect to the remote NBD export named 'nix-swap' and map it to /dev/nbd0
        sudo ${pkgs.nbd}/bin/nbd-client "$SERVER_IP" -N nix-swap /dev/nbd0
        
        # 3. Activate the device as swap with the highest possible priority (32767)
        sudo ${pkgs.util-linux}/bin/swapon -p 32767 /dev/nbd0
        echo "Network swap from RPi5 is now ACTIVE!"
        ;;

      off)
        echo "Disconnecting from NBD server..."
        # Turn off the swap device and safely detach the network block client
        sudo ${pkgs.util-linux}/bin/swapoff /dev/nbd0 || true
        sudo ${pkgs.nbd}/bin/nbd-client -d /dev/nbd0 || true
        echo "Network swap DISABLED."
        ;;

      *)
        echo "Usage: nbd-connect [on|off] [server_ip]"
        echo "Example: nbd-connect on 192.168.1.50"
        exit 1
        ;;
    esac
  '';
in
{
  home.packages = [ nbd-connect ];
}
