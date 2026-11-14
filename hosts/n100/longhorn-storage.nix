{ config, lib, pkgs, ... }:

let
  uuid = "a9fc730f-0d1b-443b-b14e-f601fea91f5b";
  directory = "/var/lib/longhorn";
  checkStorage = ''
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --target /var/lib --output UUID)" = ${uuid}
    test ! -L ${directory}
  '';
in
{
  imports = [ ../../services/k3s/longhorn-v1.nix ];

  assertions = [ {
    assertion = config.fileSystems."/".device == "/dev/disk/by-uuid/${uuid}";
    message = "Recheck the n100 Longhorn storage guard after changing its root disk.";
  } ];

  systemd.services.longhorn-storage-prepare = {
    description = "Prepare Longhorn directory on the n100 root SSD";
    unitConfig.RequiresMountsFor = [ "/var/lib" ];
    before = [ "k3s.service" ];
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

  systemd.services.k3s.preStart = lib.mkBefore ''
    ${checkStorage}
    test -d ${directory}
    test "$(${pkgs.util-linux}/bin/findmnt --noheadings --raw --target ${directory} --output UUID)" = ${uuid}
  '';
}
