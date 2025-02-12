{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ./git
    ./desktop-entries
    ./rio-term
    ./fish
  ];

  home.packages = with pkgs; [
  ];

  home.username = "zachary";
  home.homeDirectory = "/home/zachary";
  home.stateVersion = "24.11";
}
