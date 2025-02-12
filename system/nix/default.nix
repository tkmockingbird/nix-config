{pkgs, ...}: {
  nix = {
    # Enable lix
    package = pkgs.lix;

    # Automated Garbage Collection
    gc.automatic = false;

    settings = {
      auto-optimise-store = true;
      # Uses binary Cache - Saves download time
      builders-use-substitutes = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      accept-flake-config = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
      max-jobs = "auto";
      # continue building derivations if one fails
      keep-going = true;
      log-lines = 20;
      # Enables Flakes and other experimental commands
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];
      # Sandboxes packages, isolating them from eachother unless they do not require root access.
      sandbox = "relaxed";
      # Automatic usage of --show-trace when a build error occurs
      show-trace = true;
      # Uses binary Cache - Saves download time
      substituters = [
        "https://cache.nixos.org"
        "https://rocm.cachix.org"
        "https://llama-cpp.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "rocm.cachix.org-1:6Iv6py1xxKkNR0U/OTW7EQN0fJr1AZHpEUvBpyXGecw="
        "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
      ];
    };
  };
}
