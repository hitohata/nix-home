{ config, ... }:

{
  imports = [ ./k3s_common.nix ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--tls-san ${config.networking.hostName}.local"
      "--node-name ${config.networking.hostName}"
      "--write-kubeconfig-mode=0644"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
}
