{ config, pkgs, ... }:
let
  hostName = "${config.networking.hostName}.local";
  port = 5544;
  proxyIP = "dejima.local";
in {

  sops.age.keyFile = "/home/hoge/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.secrets."next-cloud/s3-credentials/key" = {
    owner = "nextcloud";
    group = "nextcloud";
  };
  sops.secrets."next-cloud/s3-credentials/secret" = { 
    owner = "nextcloud";
    group = "nextcloud";
   };
  sops.secrets."next-cloud/s3-credentials/admin-pass" = { 
    owner = "nextcloud";
    group = "nextcloud";
   };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostName;

    https = true;

    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbhost = "";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."next-cloud/s3-credentials/admin-pass".path;
      extraTrustedDomains = [ hostName ];
    };

    settings = {
      objectstore = {
        "class" = "\\OC\\Files\\ObjectStore\\S3";
        "arguments" = {
          "bucket" = "nextcloud";
          "autocreate" = true;
          "region" = "garage";
          "hostname" = "pi-nas.local";
          "port" = 3900;
          "use_path_style" = true;
          "key" = config.sops.secrets."next-cloud/s3-credentials/key".path;
          "secret" = config.sops.secrets."next-cloud/s3-credentials/secret".path;
        };
      };
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
