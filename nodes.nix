# manage all nodes
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

  "user@n100" = {
    system = "x86_64-linux";
    hostname = "n100";
    username = "hoge";
    homeDir =  "/home/hoge";
    isNixos = true;
    extraModules = [];
  };
}
