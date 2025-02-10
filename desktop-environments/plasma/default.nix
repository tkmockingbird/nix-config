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
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
    elisa
    discover
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

    desktopManager.plasma6.enable = true;
    desktopManager.plasma6.enableQt5Integration = true;
  };

  environment.systemPackages = with pkgs; [
    monochrome-sddm-theme
    kdePackages.filelight
    kdePackages.yakuake
  ];
}
