{ config, lib, pkgs, ... }:

{
  # Opt in only from the two SSD hosts, not from the common K3s module.
  services.openiscsi = {
    enable = true;
    name = "iqn.2026-11.local.dejima:${config.networking.hostName}";
    enableAutoLoginOut = false;
  };

  assertions = [ {
    assertion = lib.versionOlder config.services.openiscsi.package.version "2.1.12"
      || lib.versionAtLeast config.services.openiscsi.package.version "2.1.13";
    message = "Longhorn V1 cannot use open-iscsi 2.1.12 (upstream issue #13733).";
  } ];

  # openiscsi also declares iscsi_tcp; require successful module loading before
  # starting iscsid rather than relying on package installation or socket use.
  systemd.services.iscsid = {
    requires = [ "systemd-modules-load.service" ];
    after = [ "systemd-modules-load.service" ];
  };

  # These are host tools. Dynamic Longhorn pods still need the PATH integration
  # described in README; the host service's PATH is not inherited by pods.
  environment.systemPackages = with pkgs; [
    bash curl coreutils util-linux gnugrep gawk nfs-utils
    e2fsprogs xfsprogs cryptsetup lvm2
  ];
  boot.supportedFilesystems = [ "nfs" ];
  # V1 uses iscsi_tcp; 1.13.0's environment monitor also checks dm_crypt.
  boot.kernelModules = [ "iscsi_tcp" "dm_crypt" ];

  services.k3s.extraFlags = [ "--node-label storage.dejima.men/longhorn=true" ];

  systemd.services.k3s = {
    requires = [ "iscsid.service" ];
    bindsTo = [ "longhorn-storage-prepare.service" ];
    after = [ "iscsid.service" "longhorn-storage-prepare.service" ];
  };
}
