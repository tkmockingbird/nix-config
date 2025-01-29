{pkgs, ...}: let
  monochrome-sddm-theme = pkgs.stdenv.mkDerivation {
    name = "monochrome-sddm-theme";
    src = pkgs.fetchFromGitLab {
      owner = "pwyde";
      repo = "monochrome-kde";
      rev = "master"; # Or a specific commit hash
      hash = "sha256-mnEQQ2PHzARv65PSwGDyS2bcYlRUydD5HUmVD251Tts=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r "$src/sddm/themes/monochrome" "$out/share/sddm/themes"
    '';
  };
in {
  qt.platformTheme = "kde";
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.oxygen
    pkgs.kdePackages.elisa
  ];
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
        theme = "monochrome";
      };
    };

    xserver = {
      xkb = {
        layout = "us,us";
        variant = "workman,";
        options = "grp:win_space_toggle,caps:capslock";
      };
      autoRepeatDelay = 275;
      autoRepeatInterval = 32;
    };

    desktopManager.plasma6.enable = true;
    desktopManager.plasma6.enableQt5Integration = true;
  };

  environment.systemPackages = with pkgs; [
    monochrome-sddm-theme
    kdePackages.filelight
  ];
}
