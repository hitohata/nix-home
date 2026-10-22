{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "moov-admin" ''
      projectDir="/home/hoge/Projects/work/moov/moov-admin-ui"
      if [[ "$PWD" != "$projectDir" ]]; then
        echo "Run moov-admin from $projectDir" >&2
        exit 2
      fi
      if [[ $# -eq 0 ]]; then
        echo "Usage: moov-admin <command> [args...]" >&2
        exit 2
      fi
      if [[ "''${MOOV_ADMIN_DOCKER_GROUP:-}" != 1 ]]; then
        printf -v command '%q ' "$0" "$@"
        exec /run/wrappers/bin/sg docker -c "MOOV_ADMIN_DOCKER_GROUP=1 ''${command}"
      fi
      exec ${pkgs.docker}/bin/docker run --rm -it --network host \
        -v "$projectDir:/app" -w /app node:20-bookworm \
        bash -lc 'exec env "$@"' moov-admin "$@"
    '')
    (pkgs.writeShellScriptBin "moov-back" ''
      projectDir="/home/hoge/Projects/work/moov/moov-backend"
      if [[ "$PWD" != "$projectDir" ]]; then
        echo "Run moov-back from $projectDir" >&2
        exit 2
      fi
      if [[ $# -eq 0 ]]; then
        echo "Usage: moov-back <command> [args...]" >&2
        exit 2
      fi
      if [[ "''${MOOV_BACK_DOCKER_GROUP:-}" != 1 ]]; then
        printf -v command '%q ' "$0" "$@"
        exec /run/wrappers/bin/sg docker -c "MOOV_BACK_DOCKER_GROUP=1 ''${command}"
      fi
      exec ${pkgs.docker}/bin/docker run --rm -it --network host \
        -v "$projectDir:/app" -w /app node:20-bookworm \
        bash -lc 'exec env "$@"' moov-back "$@"
    '')
  ];
}
