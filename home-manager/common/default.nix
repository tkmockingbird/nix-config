{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./packages
    ./zshell
    #./gnome
  ];
}
