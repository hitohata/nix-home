{ config, pkgs, ... }:

let
  raidMount = "/srv/disk-by-uuid-7bb319ea-0641-4ce1-a820-fbd7d7219c36/Pi-NAS"; # mound point of OMV
  garageRoot = "${raidMount}/garage";
in
{
  imports = [
    ./shared/sops.nix
  ];

  sops.secrets."garage/rpc_secret" = {
    restartUnits = [ "garage.service" ];
  };


  # setting file https://garagehq.deuxfleurs.fr/reference_manual/configuration.html
  home.file.".config/garage/garage.toml".text = ''
    metadata_dir = "${garageRoot}/meta"
    data_dir = "${garageRoot}/data"
    replication_factor = 1

    [rpc_bind]
    address = "[::]:3901"
    # secret is injected as an environment value

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
      EnvironmentFile = config.sops.secrets."garage/rpc_secret".path;
      ExecStart = "${pkgs.garage}/bin/garage server -c %h/.config/garage/garage.toml";
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
