{
  stdenv,
  lib,
  fetchurl,
  appimage-run,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  makeWrapper,
  fetchFromGitHub,
  zlib,
}: let
  version = "128.0.6613.189";
  pname = "thorium";
  appimage = fetchurl {
    url = "https://github.com/Alex313031/thorium/releases/download/M${version}/Thorium_Browser_${version}_AVX2.AppImage";
    sha256 = "sha256-RBPSGgwF6A4KXgLdn/YIrdFpZG2+KwMJ8MkTjSPpkhU=";
  };
  thorium-repo = fetchFromGitHub {
    owner = "Alex313031";
    repo = "thorium";
    rev = "M${version}";
    sha256 = "sha256-vJzjmDeKC7yB4vooDi8dM6qAiNi/QHGKBuhS5pbBdm8="; # Replace with actual sha256
  };
in
  stdenv.mkDerivation rec {
    inherit pname version;

    src = appimage;

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = [
      appimage-run
      zlib
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "Thorium";
        exec = "thorium";
        icon = "thorium-browser";
        desktopName = "Thorium";
        comment = "Chromium-based browser with performance optimizations";
        categories = ["Network" "WebBrowser"];
        startupWMClass = "thorium-browser";
      })
    ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/icons/hicolor/256x256/apps
      cp ${src} $out/share/thorium.AppImage
      chmod +x $out/share/thorium.AppImage

      makeWrapper ${appimage-run}/bin/appimage-run $out/bin/thorium \
        --add-flags "$out/share/thorium.AppImage"

      cp ${thorium-repo}/logos/chromium_logo.svg $out/share/icons/hicolor/256x256/apps/chromium_logo.svg

      runHook postInstall
    '';

    meta = with lib; {
      description = "Thorium Browser - Performance-optimized Chromium fork";
      homepage = "https://github.com/Alex313031/Thorium";
      license = licenses.bsd3;
      platforms = ["x86_64-linux"];
    };
  }
