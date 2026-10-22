{ lib, ... }:
let
  moduleDir = ./.;
  entries = builtins.attrNames (builtins.readDir moduleDir);
  moduleFiles = lib.filter (name: lib.hasSuffix ".nix" name && name != "default.nix") entries;
in
{
  imports = builtins.map (name: moduleDir + "/${name}") moduleFiles;
}
