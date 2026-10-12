{ config, lib, ... }:

let
  cfg = config.hosts.shared.keyboard;
  xkbOptions = cfg.xkbOptions ++ lib.optionals cfg.capsLockAsCtrl [ "caps:ctrl_modifier" ];
in
{
  options.hosts.shared.keyboard = {
    xkbOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional XKB options for this host.";
    };

    capsLockAsCtrl = lib.mkEnableOption "mapping Caps Lock to Ctrl";
  };

  config.services.xserver.xkb.options = lib.concatStringsSep ","
    xkbOptions;
}
