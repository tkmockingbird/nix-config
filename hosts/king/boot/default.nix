{
  pkgs,
  config,
  inputs,
  ...
}: {
  boot = {
    # Specifices the Linux Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # Enables r8125 Realtek Ethernet Driver
    extraModulePackages = with config.boot.kernelPackages; [r8125];
    kernelModules = ["r8125"];
    # Bootloader Configuration
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 8;
      systemd-boot.enable = true;
    };
  };
}
