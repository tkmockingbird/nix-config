{pkgs, ...}: {
  home.packages = [
    pkgs.zsh-powerlevel10k
    pkgs.meslo-lgs-nf
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    shellAliases = {
      upgit = "/home/$(whoami)/nix-config/gitupdate.sh";
      update = "/home/$(whoami)/nix-config/update.sh";
      garbage = "sudo nix-collect-garbage -d";
      upflake = "cd /home/$(whoami)/nix-config && nix flake update && cd ~";
    };

    initExtra = ''
      if [[ -o interactive ]]; then
        fastfetch
      fi
    '';

    history = {
      save = 10000;
    };
  };
}
