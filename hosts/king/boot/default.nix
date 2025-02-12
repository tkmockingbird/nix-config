{
  pkgs,
  config,
  inputs,
  ...
}: {
  boot = {
    # Specifices the Linux Kernel
    kernelPackages = pkgs.linuxPackages_cachyos;

    # Enables r8125 Realtek Ethernet Driver
    extraModulePackages = with config.boot.kernelPackages; [r8125];
    kernelModules = ["r8125"];

    # Bootloader Configuration
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      timeout = 8;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.minimal-grub-theme}";
        extraEntries = ''
          menuentry "Windows 11" {
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root CD08-B687
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
          menuentry "Reboot to BIOS" {
            fwsetup
          }
          menuentry "Shutdown" {
            halt
          }
        '';
      };
    };
  };
}
