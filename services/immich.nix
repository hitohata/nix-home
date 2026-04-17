{ pkgs, ... }:
let
  port = 2283;
in {

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = port;
    mediaLocation = "/mnt/pi_nas/immich/storage";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    extensions = ps: [ ps.pgvector ps.vectorchord ];
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/mnt/pi_nas/immich/db_backup";
    startAt = "03:00";
    databases = [ "immich" ];
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
