{
  description = "Portable Neovim and Home Manager Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      # Home manager configurations
      mkHomeConfig = system: username: homeDirectory: configName:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit pkgs-unstable configName; };
          modules = [
              ./home.nix
              {
                home.username = username;
                home.homeDirectory = homeDirectory;
              }
            ];
        };
      
      # NixOS configuration 
      mkNixosConfig = system: hostname: username:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager {
              home-mamager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import pkgs-unstable { inherit system; config.allowUnfree = true; }
              }
            }
          ]
        }
    in {
      # --- Home Manager ---
      homeConfigurations = {
        # Specific configurations
        "root@intel-pc" = mkHomeConfig "x86_64-linux" "root" "/root" "root@intel-pc";
        "root@aarch64" = mkHomeConfig "aarch64-linux" "root" "/root" "root@aarch64";

        "user@intel" = mkHomeConfig "x86_64-linux" "hoge" "/home/hoge" "user@intel";

        # For nixOS
        "user@n100" = mkHomeConfig "x86_64-linux" "n100" "hoge";
      };
    };
}
