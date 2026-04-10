{ config, pkgs, ... }:
let
  hostName = "${config.networking.hostName}.local";
  port = 5544;
  proxyIP = "dejima.local";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostName;

    https = true;

    home = "/mnt/pi_nas/nextcloud/storage";

    database.createLocally = true;

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      extraTrustedDomains = [ hostName ];
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
