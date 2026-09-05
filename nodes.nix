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
      ./desktops/gnome/home.nix
      ./modules/browsers/default.nix
      ./services/k3s/k3s_home.nix
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
      ./desktops/gnome/home.nix
      ./desktop_modules/default.nix
      ./modules/browsers/default.nix
      ./modules/dev_modules/default.nix
      ./modules/others/gui/camera.nix
      ./modules/specific/ai_tool/claude.nix
      ./modules/specific/ai_tool/codex.nix
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
    enableGhostty = false;
    extraModules = [
      ./services/garage.nix
    ];
  };
  "user@p51" = {
    system = "aarch64-linux";
    hostname = "aarch64";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = false;
    extraModules = [
      ./modules/others/nbd/default.nix
    ];
  };
}
