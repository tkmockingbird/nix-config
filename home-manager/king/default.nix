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
    ./nushell
    ./rio-term
  ];

  home.packages = with pkgs; [
  ];

  home.username = "zachary";
  home.homeDirectory = "/home/zachary";
  home.stateVersion = "24.11";
}
