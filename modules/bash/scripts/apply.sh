# apply the nix setting
# NIX_HOME_TARGET can be set to override the default target
# e.g., export NIX_HOME_TARGET="root@aarch64"
apply() {
  local target="${1:-$NIX_HOME_TARGET}"

  if [[ -z "$target" ]]; then
    echo "Error: No target specified."
    echo "Either:"
    echo "  1. Set NIX_HOME_TARGET environment variable (e.g., export NIX_HOME_TARGET='root@aarch64')"
    echo "  2. Pass target as argument (e.g., apply root@aarch64)"
    echo ""
    echo "Available configurations are defined in flake.nix homeConfigurations."
    return 1
  fi

  echo "Applying Home Manager config for: $target"

  # stage all changes
  git add . 2>/dev/null

  # execute
  nix run github:nix-community/home-manager/release-25.11 -- \
   --impure switch --flake ".#$target" -b backup
}
