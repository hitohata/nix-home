{ config, pkgs, ... }:
{
  services.rpcbind.enable = true;
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/pi_nas" = {
    device = "pi-nas.local:/Pi-NAS";
    fsType = "nfs";
    options = [
      "nfsvers=4"
      "rw"
      "x-systemd.automount" # auto mount when it needs
      "noauto" # prevent stopping by an error when the network is broken
      "x-systemd.idle-timeout=300" # 5 min
    ];
  };
}
