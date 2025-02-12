{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./services
  ];
  users.users.zachary = {
    isNormalUser = true;
    description = "Zachary Bell Peppers";
    shell = pkgs.zsh;
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
      variant = "workman,";
      options = "grp:win_space_toggle,caps:capslock";
    };
    autoRepeatDelay = 275;
    autoRepeatInterval = 32;
  };

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    fish
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
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/New_York";
  };

  # Select Internationalisation Properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  system.stateVersion = "25.05";
}
