{
  config,
  pkgs,
  ...
}: {
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_MF460_Series_UFR_II";
        location = "Kitchen";
        description = "Canon Laser Printer";
        deviceUri = "ipp://192.168.1.83/ipp/print";
        model = "CNRCUPSMF460ZK.ppd";
      }
    ];
    ensureDefaultPrinter = "Canon_MF460_Series_UFR_II";
  };
  # Enable Printing & Specify Drivers
  services.printing = {
    enable = true;
    drivers = [
      (pkgs.canon-cups-ufr2.overrideAttrs (oldAttrs: {
        dontCheckForBrokenSymlinks = true;
      }))
    ];
  };
  # SCANNER CONFIGURATION
  # Enable Network Device Discovery - NixOS Doesn't Natively Support Canon ImageClass
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  # Enable Sane and Open Firewall
  hardware.sane = {
    enable = true;
    openFirewall = true;
  };
  # Provides IP for Specific Scanner
  services.saned = {
    enable = true;
    extraConfig = "192.168.1.83";
  };
}
