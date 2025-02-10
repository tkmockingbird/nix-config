{
  pkgs,
  config,
  inputs,
  ...
}: {
  boot = {
    # Specifices the Linux Kernel
    kernelPackages = pkgs.linuxPackages_cachyos;

    # Bootloader Configuration
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      timeout = 10;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.minimal-grub-theme}";
        extraEntriesBeforeNixOS = true;
        extraEntries = ''
          menuentry "Windows 11" {
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root C253-6E85
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
