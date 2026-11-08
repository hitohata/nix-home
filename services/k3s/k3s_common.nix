{ ... }:

{
  # Kubelet needs the NFS client and mount helper for NFS-backed volumes.
  boot.supportedFilesystems = [ "nfs" ];

  # Open ports for k3s
  networking.firewall.allowedTCPPorts = [ 10250 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
}
