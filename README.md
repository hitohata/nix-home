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

## K3s

`user@n100` runs a standalone K3s server through the NixOS `services.k3s`
module. After applying that configuration, the cluster kubeconfig is available
at `/etc/rancher/k3s/k3s.yaml`; it is readable by local users so `kubectl` can
use it directly:

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get nodes
```

All Home Manager targets install `kubectl`, including non-NixOS machines. K3s
itself is a system service and is not managed by Home Manager: install it on
non-NixOS hosts with that operating system's package manager, then configure
`KUBECONFIG` to point to the kubeconfig provided by that installation or copied
from the K3s server. Do not copy the server kubeconfig unchanged to another
machine; replace its `server:` address with the server's reachable IP or DNS
name first.

The shared K3s module enables NFS client support on both NixOS cluster nodes
(`n100` and `p41`) so kubelet can mount NFS-backed persistent volumes. This
does not add a host-level NAS mount or change application node placement.
After changing this module, rebuild each affected host with its matching
`user@n100` or `user@p41` target.

### p41 SSD local-path storage

[`hosts/p41/k3s-storage.nix`](hosts/p41/k3s-storage.nix) is imported only by
p41. It mounts the existing ext4 SSD with UUID
`a027e4b8-2f05-44b2-bdce-5c9528334a7c` at `/mnt/ssd`, creates
`/mnt/ssd/k3s-storage` as root with mode 0755, and bind mounts it at
`/var/lib/rancher/k3s/storage`. Only application local-path volumes use the
SSD: the K3s data directory, server database/etcd, container images and other
node data keep their existing locations. n100 and the shared modules are
unchanged. Application placement and data migration belong in k3services and
are not performed by this configuration.

Startup order is `mnt-ssd.mount` → `k3s-storage-prepare.service` →
`var-lib-rancher-k3s-storage.mount` → `k3s.service`. Directory creation requires
the mounted SSD's UUID to match. K3s also checks the bind mount's UUID and
filesystem root before starting. `nofail` lets the host boot for recovery
without its SSD; it does **not** allow K3s to start on SD-backed storage.
The device wait is limited to 10 seconds.

The SSD mount is bound to its block device; the preparation service and bind
mount are bound to the SSD mount, and K3s is bound to both mounts. With
`After=`, these [systemd dependencies](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html)
also propagate mount deactivation to K3s and order a managed stop as K3s →
bind mount → SSD. On p41, `KillMode=control-group` stops processes remaining
in the K3s service cgroup, including during ordinary K3s restarts. This may
interrupt p41 workloads; it does not guarantee that pods in separate
Kubernetes cgroups have stopped. Quiesce workloads separately for maintenance.
Existing pod bind mounts retain their filesystem references rather than
switching to the underlying SD path. Device removal can still cause I/O
errors and data loss; these
dependencies prevent fallback to SD storage, not hardware failures. Do not
use forced/lazy unmounts or unplug a live SSD.

#### Before applying (on p41)

The read-only inspection on 2026-11-14 found `/etc/fstab` linked through
`/etc/static/fstab` into the Nix store. Its existing SSD entry uses
`/dev/disk/by-id/ata-Patriot_Burst_Elite_120GB_PBEHHBB241015005541` with
`nofail,x-systemd.device-timeout=10s`. `mnt-ssd.mount` comes from the fstab
generator; no separate native mount unit was present. Neither the checked
`/etc/nixos` files nor this repository contained the old SSD definition.
The exact source of that older generation is therefore unconfirmed.

Recheck before switching, since the running generation may have changed:

```bash
ls -l /etc/fstab
readlink -f /etc/fstab
cat /etc/fstab
findmnt --mountpoint /mnt/ssd -o TARGET,SOURCE,FSTYPE,UUID,OPTIONS
lsblk -f
systemctl cat mnt-ssd.mount
sudo rg -n 'a027e4b8|Patriot_Burst|/mnt/ssd|k3s-storage' /etc/nixos
sudo ls -la /mnt/ssd /var/lib/rancher/k3s/storage
```

The last path was absent during inspection. If it now contains data, stop
and arrange a separate backed-up migration before covering it with a bind
mount. Also check for a symlink or unexpected contents at
`/mnt/ssd/k3s-storage`. Do not format, delete, or automatically copy data.
Resolve any additional SSD definition in the configuration actually being
built: keep this module as the single owner of `/mnt/ssd`. Do not append an
entry to the generated `/etc/fstab` or edit its Nix-store target. A rebuild
from this flake replaces the generated fstab, including the old by-id entry.
The bind is a native systemd unit and has no second fstab entry.

#### Build, apply and verify

Run from a checkout containing this module on **p41**. When using a Git flake,
ensure the new file is Git-tracked (for example,
`git add hosts/p41/k3s-storage.nix`) so Nix includes it.

```bash
sudo nixos-rebuild build --flake '.#user@p41'
cat result/etc/fstab
cat result/etc/systemd/system/var-lib-rancher-k3s-storage.mount
sudo nixos-rebuild dry-activate --flake '.#user@p41'
```

Check that the generated fstab has exactly one `/mnt/ssd` entry with the UUID
above, and review the activation plan. Schedule a maintenance window and stop
workloads writing to local storage before the first switch. The old
`KillMode=process` can leave containers running after `systemctl stop k3s`;
verify that old writers are quiesced before changing mounts.

```bash
sudo systemctl stop k3s
sudo nixos-rebuild switch --flake '.#user@p41'
sudo systemctl start k3s
findmnt --mountpoint /mnt/ssd -o TARGET,SOURCE,FSTYPE,UUID,OPTIONS
findmnt --mountpoint /var/lib/rancher/k3s/storage -o TARGET,SOURCE,FSTYPE,UUID,FSROOT,OPTIONS
systemctl status mnt-ssd.mount k3s-storage-prepare.service \
  var-lib-rancher-k3s-storage.mount k3s.service
systemctl show k3s.service -p BindsTo -p After -p KillMode
cat /etc/fstab
sudo journalctl -b -u k3s-storage-prepare -u k3s --no-pager
```

Both mounts must report the SSD UUID; the bind must have `FSROOT` equal to
`/k3s-storage`, and K3s must use `KillMode=control-group`. Confirm the old
by-id entry is absent from fstab. No write probe is needed.

For an optional maintenance-window stop test, first quiesce workloads, then
run `sudo systemctl stop mnt-ssd.mount`. K3s and the bind mount must also stop;
check their status and the journal. To recover, reconnect/fix the SSD if
needed, run `sudo systemctl reset-failed`, then `sudo systemctl start k3s`.
Its dependencies mount the SSD and bind again. Do not expect device
reinsertion alone to restart K3s. A disconnected-device boot test must be
performed only while powered off and with recovery access: the host should
boot, K3s should stay inactive/failed, and no source directory should appear
on the underlying SD filesystem. Do not roll back to an older generation
without first stopping workloads: it lacks these storage guards.

Local validation on 2026-11-14 passed: p41's complete system derivation and
NixOS assertions evaluated successfully; generated fstab contains one SSD
entry; n100 retains its existing storage and `KillMode=process`. Startup
scripts pass `bash -n`. The generated fstab mount plus the three new/updated
units pass `systemd-analyze verify` without an ordering cycle, using no-op
executables in place of unavailable ARM executable paths. No full system
build, activation, or physical disconnect/stop test was performed.

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

Set `enableTerminal = true;` in a node's entry in `nodes.nix` to enable all
configured graphical terminal emulators together. Omit the setting to leave
them disabled; no explicit `enableTerminal = false;` is needed.
The group currently contains Ghostty; add other emulators to the same group in
`modules/terminal/default.nix` so they share the flag. `user@x1` and
`user@centre` enable the group; `user@n100` and `user@p41` leave it disabled.
Hyprland's `Super+Enter` shortcut opens Ghostty when the group is enabled.
Zellij remains available independently.

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
