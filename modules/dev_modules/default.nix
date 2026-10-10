{ pkgs, lib, ... }: {
  home.packages = with pkgs;
    [
      awscli2
    ]
    ++ lib.optionals stdenv.isLinux [
      ssm-session-manager-plugin
      docker
    ];
}
