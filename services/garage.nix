{ config, pkgs, ... }:

let
  raidMount = "/srv/disk-by-uuid-7bb319ea-0641-4ce1-a820-fbd7d7219c36/Pi-NAS";
  garageRoot = "${raidMount}/garage";
in
{
  imports = [
    ./shared/sops.nix
  ];

  sops.secrets."garage/rpc_secret" = { };

  home.packages = [
    (pkgs.writeShellScriptBin "garage" ''
      set -e
      SECRET_PATH=$(ls /run/user/$(id -u)/secrets.d/*/garage/rpc_secret 2>/dev/null | head -n 1)
      
      if [ -n "$SECRET_PATH" ] && [ -f "$SECRET_PATH" ]; then
        export GARAGE_RPC_SECRET=$(cat "$SECRET_PATH")
      fi

      exec ${pkgs.garage}/bin/garage -c $HOME/.config/garage/garage.toml "$@"
    '')
  ];

  home.file.".config/garage/garage.toml".text = ''
    metadata_dir = "${garageRoot}/meta"
    data_dir = "${garageRoot}/data"
    replication_factor = 1

    rpc_bind_addr = "[::]:3901"

    [s3_api]
    address = "[::]:3900"
    s3_region = "garage"

    [admin]
    api_bind_addr = "[::]:3903"
  '';

  home.activation = {
    createGarageDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${garageRoot}/meta ${garageRoot}/data
    '';
  };

  systemd.user.services.garage = {
    Unit = {
      Description = "Garage Object Storage Service";
      After = [ "sops-nix.service" "network-online.target" ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "garage-launcher" ''
        set -e
        SECRET_PATH=$(ls /run/user/$(id -u)/secrets.d/*/garage/rpc_secret | head -n 1)
        
        echo "DEBUG: Found secret path at $SECRET_PATH"
        
        if [ -z "$SECRET_PATH" ] || [ ! -f "$SECRET_PATH" ]; then
          echo "ERROR: Could not resolve secret path in /run/user/$(id -u)/secrets.d/"
          exit 1
        fi
        
        export GARAGE_RPC_SECRET=$(cat "$SECRET_PATH")
        
        echo "DEBUG: Secret loaded successfully. Launching Garage..."
        exec ${pkgs.garage}/bin/garage -c $HOME/.config/garage/garage.toml server
      '';
      Restart = "always";
      RestartSec = "5s";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
