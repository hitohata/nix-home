# Longhorn V1 host preparation

Status: host configuration prepared for review, 2026-11-15. Longhorn is not
installed. No activation, service restart, Kubernetes mutation, preflight,
formatting, PVC migration, or data deletion is performed by this change.

## Scope and requirements

The candidate is **Longhorn 1.13.0, V1 only**. Its [installation requirements](https://longhorn.io/docs/1.13.0/deploy/install/)
require Kubernetes >= 1.34, a running host iSCSI initiator, ext4/XFS storage,
host utilities, privileged workloads and mount propagation. The observed
cluster uses K3s 1.35.8 on n100/p41 and 1.35.7 on p51. Do not enable V2,
configure SPDK, reserve huge pages, or use raw block disks for this pilot.

The fixed nixpkgs revision `9bb52223f4f6a0cc606fd0852d8784f896c137d5`
provides open-iscsi **2.1.13**, util-linux **2.42.4** and nfs-utils **2.9.1**
on both architectures. Upstream warns against open-iscsi 2.1.12; the module
asserts that the configured package is older than 2.1.12 or at least 2.1.13.
This checks the published version restriction, not end-to-end interoperability.
The native NixOS openiscsi module installs the package and initiator file,
enables iscsid and its socket, and loads iscsi_tcp. Our module explicitly
orders iscsid after successful systemd module loading and K3s after iscsid.
It also loads dm_crypt, checked by the V1 environment monitor, and installs
the required host tools plus filesystem, cryptsetup and device-mapper tools.
There is no automatic iSCSI discovery/login/logout configuration.

Only n100 and p41 import `services/k3s/longhorn-v1.nix`. Their stable initiator
names are `iqn.2026-11.local.dejima:n100` and
`iqn.2026-11.local.dejima:p41`. Preserve these identities once volumes are in
use; changing them requires a separate iSCSI maintenance plan.

| Host | Prepared replica directory | Backing filesystem UUID | Observed capacity |
| --- | --- | --- | --- |
| n100 | `/var/lib/longhorn` | `a9fc730f-0d1b-443b-b14e-f601fea91f5b` | 476.9 GiB non-rotating EAGET SSD; about 317 GiB available on root |
| p41 | `/mnt/ssd/longhorn`, bind mounted at `/var/lib/longhorn` | `a027e4b8-2f05-44b2-bdce-5c9528334a7c` | about 104 GiB available on the SSD |
| p51 | None | SD card; not inspected or changed here | Reported DiskPressure; separate remediation required |

Both directories were absent during read-only inspection. They are created
root-owned, mode 0700 by a oneshot `longhorn-storage-prepare.service` pulled
in by K3s. Before creation, n100 verifies the UUID backing `/var/lib`, and
p41 verifies an **exact mount** at `/mnt/ssd` with its expected UUID. Symlink
destinations are rejected. After creation, each directory's backing UUID is
checked again. K3s repeats these checks on every start. No global tmpfiles
rule creates either directory.

On p41, preparation and `var-lib-longhorn.mount` are bound to `mnt-ssd.mount`,
and K3s is bound to preparation, the Longhorn bind and the existing
SSD/local-path mounts. K3s checks that `/var/lib/longhorn` is an exact mount
with the SSD UUID and filesystem root `/longhorn`. The existing
`/mnt/ssd/k3s-storage` → `/var/lib/rancher/k3s/storage` bind is unchanged.
SSD absent or wrong UUID means preparation and K3s fail instead of creating
the Longhorn directory on SD. Managed stopping follows K3s → Longhorn bind →
preparation → SSD. Unexpected SSD or bind mount deactivation also stops K3s.
Device reinsertion does not by itself restart the dependent services.

These systemd relationships govern the host service, not every Kubernetes
pod cgroup. A stopped K3s process is not proof that all Longhorn engines or
other writers have stopped. While open file/mount references still refer to
the old filesystem, processes with access to host paths must not be allowed
to recreate a missing disk directory after an unmount. Before any deliberate
unmount, independently quiesce Longhorn and application writers and verify
their termination; never force/lazy-unmount the SSD. Live mount-loss and
power-loss behavior remains a required pilot test, not a verified HA claim.

## Host tools and nsenter: deployment gate

[NixOS issue #2166](https://github.com/longhorn/longhorn/issues/2166) is still
open. Its original examples target Longhorn 1.1; do not treat the old image,
Kyverno policy API, or private iscsid `/bin` bind as a supported 1.13 solution.
The following was checked directly in the tagged **v1.13.0** sources:

- [Namespace executor](https://github.com/longhorn/longhorn-manager/blob/v1.13.0/vendor/github.com/longhorn/go-common-libs/ns/executor.go)
  constructs `nsenter --mount=... --net=... <binary> ...`, with command names
  resolved after entering the target namespace. The underlying executor
  inherits the calling Pod's environment; it does not import the host
  systemd unit's PATH.
- [Engine iSCSI helper](https://github.com/longhorn/longhorn-engine/blob/v1.13.0/vendor/github.com/longhorn/go-iscsi-helper/iscsidev/iscsi.go)
  selects the host iscsid mount/network namespace, and invokes `iscsiadm`
  by name. Manager/CSI operations can select other host process namespaces.
- [CSI generation](https://github.com/longhorn/longhorn-manager/blob/v1.13.0/csi/deployment.go)
  and [instance-manager generation](https://github.com/longhorn/longhorn-manager/blob/v1.13.0/controller/instance_manager_controller.go)
  construct their own Pod environments. Neither forwards an arbitrary PATH
  from a patched manager/driver-deployer Deployment. A Helm template-only
  patch therefore misses dynamically generated workloads.
- The current CSI [nsmounter](https://github.com/longhorn/longhorn-manager/blob/v1.13.0/package/nsmounter)
  enters host PID 1's namespaces for ordinary non-Talos RWX mounts. Binding
  host tools into **only iscsid's private namespace** cannot fix this path.
- The [environment monitor](https://github.com/longhorn/longhorn-manager/blob/v1.13.0/controller/monitor/environment_check_monitor.go)
  skips package checks for unrecognized OS images, including NixOS. A green
  node condition alone is not proof that host tools can execute.

The selected integration contract for k3services is to **preserve the pinned
images' normal PATH and append `/run/current-system/sw/bin` to the actual
Longhorn Pod containers and init containers**. A typical complete value is:

```text
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/current-system/sw/bin
```

Verify each pinned image's original PATH rather than blindly replacing it
with this example. Normal container paths must remain first so CSI's local
tools and `/usr/local/sbin/nsmounter` remain available. After nsenter, the
extra path reaches the host profile and its Nix-store executables/libraries.
The host profile must include `iscsiadm`, `mount`, `umount`, `mount.nfs`,
`findmnt`, `blkid`, `lsblk`, `bash`, `curl`, `grep`, `awk`, `cryptsetup` and
`dmsetup`; installing them inside a container alone is insufficient.

k3services must implement this with a version-supported Pod admission
mutation (or equivalently verified images/controller integration), covering
manager, driver-deployer, dynamic CSI plugin, instance-manager/engine,
relevant jobs and future components using host namespaces. Preserve existing
env/init containers. Ensure the mutation is ready before allowing Longhorn
Pod creation and also applies to replacements and upgrades. Do not copy the
old issue's policy unchanged. No admission engine or policy is installed here.

This contract follows the 1.13 execution paths; **it has not been tested from
real Longhorn Pods**. Deployment must remain blocked until a separately
approved namespace/CSI/engine test succeeds on both architectures. Required
checks include read-only version/lookups through host PID 1, iscsid, and the
selected containerd namespace, then a disposable two-replica attachment and
reattachment test. Preserve required privileged permissions, host `/proc`,
host namespace access, host `/dev`, host filesystem access and bidirectional
CSI mount propagation. Never bind the host profile over a container's `/bin`.

## p41 NFS investigation

The historical errors were confirmed in p41's journal and Kubernetes events:
Mealie and Linkwarden backup Pods failed at `mount -t nfs -o nfsvers=4` against
the numeric NAS address `192.168.10.100`. They reported
`fsconfig() failed: NFS: mount program didn't pass remote address` through
07:19 UTC on 2026-11-14. This was not a DNS-name-only failure.

Read-only inspection established:

- K3s' binary wrapper prefixes util-linux-minimal 2.42.4 ahead of its service
  PATH. Its libmount contains the helper search path
  `/run/wrappers/bin:/run/current-system/sw/bin:/sbin`. Adding nfs-utils only
  to an interactive user's PATH would not suffice.
- Previous system generation 9 had **no** `sw/bin/mount.nfs`. Current
  generation 10, activated at 07:21 UTC, includes nfs-utils 2.9.1's helper in
  that searched host profile. NFS/nfsv4 modules are now loaded, and `/` uses
  shared mount propagation.
- Both previously stuck Pods now have phase Succeeded/Completed; newer
  backups on p41 also completed. No matching error appears in the K3s journal
  after 07:20 UTC. No services or Pods were restarted by this investigation.

Missing helper availability in the old generation is confirmed. Attribution
of the old kernel error to that missing helper is strongly supported by the
generation comparison and recovery, but the failing process was not traced
before it exited, so its exact exec/syscall sequence is not proven. There is
no evidence requiring a util-linux downgrade or mount wrapper now. The
existing shared `boot.supportedFilesystems = [ "nfs" ];` is retained; the
Longhorn opt-in module also explicitly includes nfs-utils in the host profile.

If it recurs, collect the affected Pod/PV's mount arguments, event timestamp,
live K3s process PATH and mount namespace, current generation's helper links,
and the wrapper-selected libmount helper paths. Trace the actual failed
helper execution only with approval. Do not infer kernel/NAS compatibility
from interactive command availability, and do not use `--prefer-bundled-bin`:
the Nixpkgs K3s build does not contain the upstream bundled utilities.

## k3services handoff and HA limits

1. Keep chart **1.13.0** and all component images pinned and verify both
   AMD64/ARM64 image support. Apply only after host approval and namespace
   checks. The official `longhornctl check preflight` creates Kubernetes
   resources; it was **not run** and requires separate cluster-write approval.
2. K3s configuration on n100 and p41 declares the persistent node label
   `storage.dejima.men/longhorn=true`. No label is configured for p51.
   Labels were absent on all three during read-only inspection. Check the
   live result after the approved K3s activation; this change does not run
   `kubectl label`. The pinned [K3s 1.35.8 implementation](https://github.com/k3s-io/k3s/blob/v1.35.8%2Bk3s1/pkg/agent/run.go)
   reapplies these labels during startup, including on existing nodes.
   Removing the flag does not remove the live label: any removal needs a
   separately approved cluster change. The label is a placement hint, not authorization to create
   a replica disk or proof that host readiness checks passed.
   Disable automatic default-disk creation on undesired nodes. One supported
   policy is `createDefaultDiskLabeledNodes=true` with no create-default-disk
   labels and explicit Longhorn Node disk configuration. Register **only**
   `/var/lib/longhorn` on n100 and p41 as filesystem disks; on p41 this must
   resolve to the verified `/mnt/ssd/longhorn` bind. Do not register both the
   bind and its source as separate disks. Do not change K3s/etcd paths.
3. Exclude p51 from replica scheduling and repair its DiskPressure separately.
   If p51 will consume V1 volumes, its Debian host also needs iSCSI/NFS and
   namespace checks even with no replica disk. Decide whether Longhorn
   components may run there before choosing component selectors/tolerations.
4. Use only V1; explicitly disable V2. Start with a separate non-default
   StorageClass with Retain, two replicas on different nodes, hard node
   separation and creation with degraded availability disabled. Do not
   change existing PVCs/default StorageClass. Confirm the observed kubelet
   root `/var/lib/kubelet` in CSI settings (do not assume an old K3s path).
5. Budget disk space, snapshots/rebuild reserve and CPU/RAM. p41 has about
   4 GiB RAM; two SSD nodes fall short of the [recommended V1 baseline](https://longhorn.io/docs/1.13.0/best-practices/)
   of three nodes with four vCPUs and 4 GiB each. A 112 GiB SSD cannot carry
   all existing claim requests; select a small pilot and measure overhead.
6. Validate node-down Pod deletion, safe fencing/reattachment, workload
   scheduling, DNS/ingress survival and independent backup restore. Storage
   replication alone does not make an application automatically recover.
   **AMD64/ARM64 database disk compatibility remains a separate gate**;
   multi-architecture images alone do not prove physical PostgreSQL or other
   database state can fail over across architectures. Retain the detailed
   plan in k3services `docs/storage-ha-plan.md` as the application-side plan.

## Maintenance and rollback

Follow the approval-gated sequence and checks in the repository README.
Before Longhorn has any volumes, an approved rollback may switch each host
to its recorded pre-change generation. Keep the SSD/local-path configuration
from PR #170, and do not delete either Longhorn directory. If instead
reverting source, remove only the two `longhorn-storage.nix` imports and their
Longhorn-only settings; preserve `hosts/p41/k3s-storage.nix` and NFS support.

Once any Longhorn volume/session exists, **do not remove iscsid, modules,
tools, PATH integration or directories as a routine host rollback**. First
arrange a separately approved workload/storage rollback, quiesce writers,
detach volumes, verify no active sessions and maintain independent backups.
Do not force logout sessions, uninstall Longhorn/CRDs, prune disks, format,
or remove data as part of this host change. For a p41 SSD failure, keep K3s
stopped until the correct SSD and directories pass the checks; do not disable
the guard to get workloads running on the SD card.

## Local validation (2026-11-15)

- Both complete NixOS system derivations evaluated with no failed assertions.
  Their initiator names differ, iscsi_tcp/dm_crypt are declared and the
  requested node label appears exactly once per host. The shared K3s module,
  existing p41 SSD/local-path module, flake lock and p51 are unchanged.
- Generated fstab retains the single p41 UUID mount. The two native bind
  units refer to separate SSD directories. Generated unit dependencies pass
  `systemd-analyze verify`, including the packaged iSCSI dependency graph,
  with no ordering cycle. Only executable paths were replaced by no-ops for
  graph verification; this is not a service startup test.
- Evaluated startup scripts pass `bash -n`. Isolated fixtures execute their
  actual guard logic with mocked findmnt/install operations: both hosts
  reject missing mounts, wrong UUIDs and symlinks before directory creation.
  p41 K3s additionally rejects a missing bind or incorrect bind filesystem
  root. Successful fixtures create only temporary test directories.
- A metadata-only evaluation with open-iscsi version 2.1.12 produces the
  intended incompatibility assertion. The actual 2.1.13 package was fetched
  from the binary cache for AMD64 and ARM64; the AMD64 binary reports
  `iscsiadm version 2.1.13`. No iscsid daemon was started. The initial offline
  package realization could not use absent dependencies; an online
  substitution-only realization then succeeded without source compilation.
- `git diff --check` passes. No complete system build, host activation,
  real Longhorn Pod namespace test, preflight or outage test was performed.
