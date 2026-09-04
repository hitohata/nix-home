{ config, ... }:

{
  imports = [ ./k3s_common.nix ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      # host name
      "--tls-san ${config.networking.hostName}"
      "--tls-san ${config.networking.hostName}.lan"
      "--tls-san ${config.networking.hostName}.local"
      # IP
      "--tls-san ${config.services.dejimaClient.ipAddress}" # ← ip

      "--node-name ${config.networking.hostName}"
      "--node-ip ${config.services.dejimaClient.ipAddress}"

      "--write-kubeconfig-mode=0644"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
}
