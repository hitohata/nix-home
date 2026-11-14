{ lib, pkgs, ... }:

let
  uuid = "a027e4b8-2f05-44b2-bdce-5c9528334a7c";
  directory = "/mnt/ssd/longhorn";
  target = "/var/lib/longhorn";
  mountUnit = "var-lib-longhorn.mount";
  checkStorage = ''
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --mountpoint /mnt/ssd --output UUID)" = ${uuid}
    test ! -L ${directory}
  '';
in
{
  imports = [ ../../services/k3s/longhorn-v1.nix ];

  # Keep the existing local-path SSD and bind mount in k3s-storage.nix.
  # Do not create this directory with global tmpfiles or activation scripts.
  systemd.services.longhorn-storage-prepare = {
    description = "Prepare Longhorn directory on the p41 SSD";
    bindsTo = [ "mnt-ssd.mount" ];
    after = [ "mnt-ssd.mount" ];
    before = [ mountUnit "k3s.service" "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    # The bind mount is ordered before local-fs.target, so avoid a cycle via
    # the normal service defaults (After=basic.target).
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${checkStorage}
      ${pkgs.coreutils}/bin/install -d -m 0700 -o root -g root ${directory}
      test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --target ${directory} --output UUID)" = ${uuid}
    '';
  };

  systemd.mounts = [ {
    description = "Longhorn V1 storage on the p41 SSD";
    what = directory;
    where = target;
    type = "none";
    options = "bind";
    requires = [ "longhorn-storage-prepare.service" ];
    bindsTo = [ "mnt-ssd.mount" ];
    after = [ "mnt-ssd.mount" "longhorn-storage-prepare.service" ];
  } ];

  systemd.services.k3s.bindsTo = [ mountUnit ];
  systemd.services.k3s.after = [ mountUnit ];
  systemd.services.k3s.preStart = lib.mkBefore ''
    ${checkStorage}
    test -d ${directory}
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --target ${directory} --output UUID)" = ${uuid}
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --mountpoint ${target} --output UUID)" = ${uuid}
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --mountpoint ${target} --output FSROOT)" = /longhorn
  '';
}
