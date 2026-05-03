# manage all nodes
let
  envHome = builtins.getEnv "HOME";
  extractedUser = baseNameOf envHome;
in
{
  # for debugging
  "root@intel-pc" = {
    system = "x86_64-linux";
    hostname = "intel-pc";
    username = "root";
    homeDir =  "/root";
    isNixos = false;
    extraModules = [];
  };
  # for debugging
  "root@aarch64" = {
    system = "aarch64-linux";
    hostname = "aarch64";
    username = "root";
    homeDir =  "/root";
    isNixos = false;
    extraModules = [];
  };

  # general user
  "user@intel" = {
    system = "x86_64-linux";
    hostname = "intel-pc";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = false;
    extraModules = [];
  };

  "user@aarch64" = {
    system = "aarch64-linux";
    hostname = "aarch64";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = false;
    extraModules = [];
  };

  "user@darwin" = {
    system = "aarch64-darwin";
    hostname = "aarch64-darwin";
    username = extractedUser;
    homeDir =  envHome;
    isNixos = false;
    extraModules = [];
  };

  "user@n100" = {
    system = "x86_64-linux";
    hostname = "n100";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = true;
    extraModules = [
      ./desktops/hyprland/default.nix
      ./modules/browsers/default.nix
    ];
  };

  "user@x1" = {
    system = "x86_64-linux";
    hostname = "x1";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = true;
    extraModules = [
      ./desktops/hyprland/default.nix
      ./modules/browsers/default.nix
    ];
  };

  "user@centre" = {
    system = "x86_64-linux";
    hostname = "centre";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = true;
    extraModules = [
      ./desktops/hyprland/default.nix
      ./services/shared/sops.nix
    ];
  };

  "user@pi-nas" = {
    system = "aarch64-linux";
    hostname = "aarch64";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = false;
    extraModules = [
      ./services/garage.nix
    ];
  };
}
