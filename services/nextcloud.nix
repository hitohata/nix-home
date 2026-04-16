{ config, pkgs, ... }:
let
  hostName = "${config.networking.hostName}.local";
  port = 5544;
  proxyIP = "dejima.local";
in {

  imports = [
    ./shared/sops.nix
  ];

  sops.secrets."next-cloud/s3-credentials" = { owner = "nextcloud"; };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostName;

    https = true;

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      extraTrustedDomains = [ hostName ];

      objectstore.s3 = {
        enable = true;
        bucket = "nextcloud";
        hostname = "pi-nas.local";
        port = 3900;
        usePathStyle = true;
        region = "garage";
        secretFile = config.sops.secrets."next-cloud/s3-credentials".path;
      };
    };

    settings = {
      trusted_domains = [ hostName ];
      trusted_proxies = [ proxyIP ];
      overwriteprotocol = "https";
    };

    configureRedis = true;
  };

  services.nginx.virtualHosts."${hostName}" = {
    listen = [ { addr = "0.0.0.0"; port = port; } ];
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
