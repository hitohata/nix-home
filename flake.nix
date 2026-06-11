{
  description = "Portable Neovim and Home Manager Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ghostty, ... }@inputs:
    let

      # import nodes
      nodes = import ./nodes.nix;

      mkUnstable = system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Home manager configurations
      mkHomeConfig = system: username: homeDirectory: configName: isNixOS: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit self configName ghostty isNixOS;
            inherit (self) inputs;
            pkgs-unstable = mkUnstable system;
          };
          modules = [
            ./home.nix
            inputs.sops-nix.nixosModules.sops
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ] ++ extraModules;
        };
      
      # NixOS configuration 
      mkNixosConfig = system: hostname: username: configName: isNixOS: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = { 
                imports = [ ./home.nix ] ++ extraModules;
              };
              home-manager.extraSpecialArgs = {
                inherit self configName ghostty isNixOS;
                inherit (self) inputs;
                pkgs-unstable = mkUnstable system;
              };
            }
          ];
        };
    in {
      # --- Home Manager ---
      homeConfigurations = builtins.mapAttrs
        (name: node: mkHomeConfig node.system node.username node.homeDir name node.isNixos node.extraModules)
        (nixpkgs.lib.filterAttrs (_: n: !n.isNixos) nodes); 

      # For nixOS
      nixosConfigurations = builtins.mapAttrs
        (name: node: mkNixosConfig node.system node.hostname node.username name node.isNixos node.extraModules)
        (nixpkgs.lib.filterAttrs (_: n: n.isNixos) nodes); 
    };
}
