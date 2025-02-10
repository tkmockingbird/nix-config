{
  description = "Zach's Modular NixOS + Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-flatpak,
    zen-browser,
    ...
  } @ inputs: let
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
      overlays = [
        (final: prev: {
          pythonPackagesExtensions =
            prev.pythonPackagesExtensions
            ++ [
              (python-final: python-prev: {
                primp = python-final.callPackage ./modules/primp {
                  inherit (final.darwin.apple_sdk.frameworks) SystemConfiguration;
                };
              })
            ];
        })
      ];
    };
  in {
    nixosConfigurations = import ./hosts {
      inherit (inputs) nixpkgs self home-manager nix-flatpak zen-browser;
      inherit nixpkgsConfig;
    };
  };
}
