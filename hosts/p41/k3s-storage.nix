{ lib, pkgs, ... }:

let
  uuid = "a027e4b8-2f05-44b2-bdce-5c9528334a7c";
  ssd = "/mnt/ssd";
  source = "${ssd}/k3s-storage";
  target = "/var/lib/rancher/k3s/storage";
  ssdUnit = "mnt-ssd.mount";
  storageUnit = "var-lib-rancher-k3s-storage.mount";
in
{
  fileSystems.${ssd} = {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ext4";
    # Allow host recovery without the SSD, but never start K3s without it.
    options = [ "nofail" "x-systemd.device-timeout=10s" "x-systemd.device-bound" ];
  };

  # Do not use global tmpfiles: that could create the source on the SD card.
  systemd.services.k3s-storage-prepare = {
    description = "Prepare K3s local-path directory on the p41 SSD";
    bindsTo = [ ssdUnit ];
    after = [ ssdUnit ];
    before = [ storageUnit "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    # This service is pulled in by a local mount, before local-fs.target.
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ pkgs.coreutils pkgs.util-linux ];
    script = ''
      test "$(findmnt --noheadings --raw --mountpoint ${ssd} --output UUID)" = ${uuid}
      test ! -L ${source}
      install -d -m 0755 -o root -g root ${source}
    '';
  };

  # A native mount unit keeps the bind's service dependencies explicit.
  systemd.mounts = [ {
    description = "K3s local-path storage on the p41 SSD";
    what = source;
    where = target;
    type = "none";
    options = "bind";
    requires = [ "k3s-storage-prepare.service" ];
    bindsTo = [ ssdUnit ];
    after = [ ssdUnit "k3s-storage-prepare.service" ];
  } ];

  systemd.services.k3s = {
    bindsTo = [ ssdUnit storageUnit ];
    after = [ ssdUnit storageUnit ];
    # BindsTo also pulls in the mounts and propagates unexpected deactivation.
    # Check the actual mount before any K3s startup scripts can write data.
    preStart = lib.mkBefore ''
      test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --mountpoint ${target} --output UUID)" = ${uuid}
      test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --mountpoint ${target} --output FSROOT)" = /k3s-storage
    '';
    # Stop all processes remaining in this service's cgroup, not just K3s.
    # Kubernetes pod cgroups still need workload-level quiescing for maintenance.
    serviceConfig.KillMode = lib.mkForce "control-group";
  };
}
