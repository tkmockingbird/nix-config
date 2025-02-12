{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.fish.enable = true;
  users.users.sarah = {
    isNormalUser = true;
    description = "Sarah Nicole Smallwood";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "samba"
      "i2c"
      "audio"
      "video"
      "nix"
      "lp"
      "scanner"
      "podman"
    ];
  };

  services.xserver = {
    xkb = {
      layout = "us,us";
      variant = ",workman";
      options = "grp:win_space_toggle,caps:capslock";
    };
    autoRepeatDelay = 275;
    autoRepeatInterval = 32;
  };

  environment.systemPackages = with pkgs; [
  ];

  # GPG configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Flatpak Configuration
  services.flatpak = {
    enable = true;
    update.onActivation = true;
    packages = [
    ];
  };
}
