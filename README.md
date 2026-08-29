# dot-nix

Personal Nix flake for NixOS hosts and portable Home Manager environments.

## Apply a configuration

Run all commands from the repository root. `TARGET` is a key from
[`nodes.nix`](nodes.nix), such as `user@x1` or `user@aarch64`.

The `apply` shell function uses the configured `NIX_HOME_TARGET`; passing a
target overrides it:

```bash
apply
apply user@x1
```

To apply a standalone Home Manager configuration directly, use:

```bash
nix run --extra-experimental-features 'nix-command flakes' \
  github:nix-community/home-manager/release-26.05 -- \
  --impure switch --flake ".#TARGET" -b backup \
  --option sandbox false \
  --extra-experimental-features 'nix-command flakes'
```

For a NixOS configuration, rebuild the matching target instead:

```bash
sudo nixos-rebuild switch --flake '.#TARGET'
```

## Update packages

Update every flake input and write the new revisions to `flake.lock`:

```bash
nix flake update
```

Update only one input when a full update is not wanted:

```bash
nix flake update nixpkgs
nix flake update home-manager
```

Review the lockfile changes, then apply the target again. For example:

```bash
git diff -- flake.lock
apply user@x1
```

## Add a node and adopt modules

`nodes.nix` is the source of truth for flake targets. Each entry becomes a
`homeConfiguration` when `isNixos = false`, or a `nixosConfiguration` when
`isNixos = true`.

To add a portable Home Manager target, add an entry like this:

```nix
"user@new-host" = {
  system = "x86_64-linux";
  hostname = "new-host";
  username = "hoge";
  homeDir = "/home/hoge";
  isNixos = false;
  extraModules = [
    ./modules/specific/ai_tool/codex.nix
  ];
};
```

Then activate it with `apply user@new-host` or the direct Home Manager command
above with `TARGET` set to `user@new-host`.

To adopt optional packages or features for one node, add their Nix modules to
that node's `extraModules`. Shared packages and shell configuration already come
from `home.nix`; host-specific NixOS settings belong in
`hosts/<hostname>/configuration.nix`. For a new NixOS machine, create its
`hosts/<hostname>/configuration.nix` and hardware configuration first, then add
the node with `isNixos = true`.

## Secrets

Secrets are encrypted with [SOPS](https://github.com/getsops/sops) and age, then
made available to Nix modules by `sops-nix`. The encrypted file
`secrets/secrets.yaml` is safe to commit; private age keys are not.

### Set up an age key

Create a local key once on each machine that needs to decrypt secrets:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt
```

Add the public key printed by the second command to the `age` recipients in
`.sops.yaml`, then re-encrypt the secret file for all recipients:

```bash
sops updatekeys secrets/secrets.yaml
```

Keep `~/.config/sops/age/keys.txt` private. It is the key that grants access to
the encrypted values. Home Manager modules use this location through
`services/shared/sops.nix`; the Nextcloud module currently sets the same path
explicitly.

### Edit secrets

SOPS decrypts the file only in the editor and encrypts it again when it is
saved:

```bash
sops secrets/secrets.yaml
```

For a non-interactive check that the current machine can decrypt the file:

```bash
sops --decrypt secrets/secrets.yaml >/dev/null
```

### Use a secret in a module

Import `services/shared/sops.nix` for Home Manager targets, declare the value,
and pass the generated file path to the consuming service:

```nix
sops.secrets."my-service/api-token" = {
  owner = "my-service";
  group = "my-service";
};

services.my-service.tokenFile = config.sops.secrets."my-service/api-token".path;
```

Do not interpolate a secret into a Nix string or store it in the Nix store.
Use `config.sops.secrets.<name>.path` so the service reads the decrypted,
runtime-only file instead. After adding or changing declarations, activate the
affected node with `apply TARGET`.
