final: prev: {
  python3Packages = prev.python3Packages.override {
    overrides = pfinal: pprev: {
      primp = pfinal.callPackage ../modules/primp/default.nix {};
    };
  };
}
