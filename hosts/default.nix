{
  nixpkgs,
  self,
  home-manager,
  nix-flatpak,
  zen-browser,
  nixpkgsConfig,
  ...
}: let
  inherit (self) inputs;

  mkHost = name: system: user:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          networking.hostName = name;
          nixpkgs = nixpkgsConfig;
        })
        (./. + "/${name}")
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "0005";
          home-manager.users.${user} = import (../home-manager + "/${name}");
          home-manager.extraSpecialArgs = {
            inherit inputs;
            flake = self;
          };
        }
        nix-flatpak.nixosModules.nix-flatpak
      ];

      specialArgs = {
        inherit inputs;
        flake = self;
      };
    };
in {
  king = mkHost "king" "x86_64-linux" "zachary";
  queen = mkHost "queen" "x86_64-linux" "sarah";
}
