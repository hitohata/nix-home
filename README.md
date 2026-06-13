## Command

```bash
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager/release-26.05 -- --impure switch --flake .#root -b backup --option sandbox false --extra-experimental-features 'nix-command flakes'
```
