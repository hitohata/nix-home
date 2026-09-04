# Dejima Network Client Module
#
# This module configures a NixOS host as a client connecting through the Dejima gateway.
# It sets up a static IPv4 address, disables DHCP, and directs default traffic and DNS
# queries to the Dejima gateway.
#
# Example Usage in configuration.nix:
#
#   imports = [ ./modules/dejima-client.nix ];
#
#   services.dejimaClient = {
#     enable = true;
#     interface = "end0";
#     ipAddress = "192.168.10.100";
#     gateway = "192.168.10.1"; # optional, defaults to 192.168.10.1
#   };

{ config, lib, ... }:

with lib;

let
  # Retrieve the user-defined options from the global config attribute set
  cfg = config.services.dejimaClient;
in
{
  # 1. Define custom options (API parameters for this module)
  options.services.dejimaClient = {
    enable = mkEnableOption "Dejima Gateway Client configuration";

    interface = mkOption {
      type = types.str;
      default = "eth0";
      description = "Network interface name (e.g., eth0, end0, enp3s0).";
    };

    ipAddress = mkOption {
      type = types.str;
      description = "Static IPv4 address assigned to this host.";
    };

    prefixLength = mkOption {
      type = types.addCheck types.int (n: n >= 0 && n <= 32);
      default = 24;
      description = "Subnet prefix length (e.g., 24 for /24).";
    };

    gateway = mkOption {
      type = types.str;
      default = "192.168.10.1";
      description = "IP address of the Dejima gateway.";
    };

    dnsServers = mkOption {
      type = types.listOf types.str;
      default = [ cfg.gateway ]; # Defaults to the Dejima gateway (Pi-hole DNS)
      description = "List of DNS servers to use.";
    };
  };

  # 2. Map defined options to standard NixOS networking configuration
  config = mkIf cfg.enable {
    networking = {
      # Disable DHCP to enforce static IP assignment
      useDHCP = false;

      # Configure the specified network interface with the given static IP
      interfaces.${cfg.interface} = {
        ipv4.addresses = [{
          address = cfg.ipAddress;
          prefixLength = cfg.prefixLength;
        }];
      };

      # Set the default route to the Dejima gateway
      defaultGateway = cfg.gateway;

      # Direct DNS queries to the designated DNS servers
      nameservers = cfg.dnsServers;
    };
  };
}
