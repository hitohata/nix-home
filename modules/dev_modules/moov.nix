{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "moov-admin" ''
      case "$PWD" in
        /home/hoge/Projects/work/moov/moov-admin-ui|/home/hoge/Projects/work/moov/moov-admin-ui-alt)
          projectDir="$PWD"
          ;;
        *)
          echo "Run moov-admin from /home/hoge/Projects/work/moov/moov-admin-ui or /home/hoge/Projects/work/moov/moov-admin-ui-alt" >&2
          exit 2
          ;;
      esac
      if [[ $# -eq 0 ]]; then
        echo "Usage: moov-admin <command> [args...]" >&2
        exit 2
      fi
      if [[ "''${MOOV_ADMIN_DOCKER_GROUP:-}" != 1 ]]; then
        printf -v command '%q ' "$0" "$@"
        exec /run/wrappers/bin/sg docker -c "MOOV_ADMIN_DOCKER_GROUP=1 ''${command}"
      fi
      exec ${pkgs.docker}/bin/docker run --rm -it --network host \
        -v "$projectDir:/app" -w /app node:22-bookworm \
        bash -lc 'exec env "$@"' moov-admin "$@"
    '')
    (pkgs.writeShellScriptBin "moov-back" ''
      case "$PWD" in
        /home/hoge/Projects/work/moov/moov-backend|/home/hoge/Projects/work/moov/moov-backend-alt)
          projectDir="$PWD"
          ;;
        *)
          echo "Run moov-back from /home/hoge/Projects/work/moov/moov-backend or /home/hoge/Projects/work/moov/moov-backend-alt" >&2
          exit 2
          ;;
      esac
      if [[ $# -eq 0 ]]; then
        echo "Usage: moov-back <command> [args...]" >&2
        exit 2
      fi
      if [[ "''${MOOV_BACK_DOCKER_GROUP:-}" != 1 ]]; then
        printf -v command '%q ' "$0" "$@"
        exec /run/wrappers/bin/sg docker -c "MOOV_BACK_DOCKER_GROUP=1 ''${command}"
      fi
      exec ${pkgs.docker}/bin/docker run --rm -it --network host \
        -v "$projectDir:/app" -w /app node:22-bookworm \
        bash -lc 'exec env "$@"' moov-back "$@"
    '')
  ];
}
