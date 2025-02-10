# THESE OVERLAYS SHOULD BE TEMPORARY
{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      python313Packages = super.python313Packages.overrideAttrs (oldAttrs: {
        primp = super.python313Packages.buildPythonPackage rec {
          pname = "primp";
          version = "0.12.0"; # Update to the desired version

          src = self.fetchFromGitHub {
            # Use self.fetchFromGitHub
            owner = "deedy5";
            repo = "primp";
            tag = "v${version}";
            hash = "sha256-I8+ZoVQkzhdLA1/6ZA2ExG7YUryXVYqM3URjgjXoINU="; # Update the hash!
          };

          pyproject = true;

          # Important: Inherit or specify build dependencies if needed.
          # If the original primp package had dependencies, you might need to add them here.
          # For example:
          # buildInputs = with super.python313Packages; [ someDependency anotherDependency ];
        };
      });
    })
  ];
}
