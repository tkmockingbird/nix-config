{
  config,
  pkgs,
  ...
}: {
  # Git configuration
  programs.git = {
    enable = true;

    # Credentials
    userName = "lqmbies";
    userEmail = "sarahnsmallwood@proton.me";

    package = pkgs.git;

    # Signature Configuration
    signing = {
      key = "7D042DF9C46E6F93B1217BD117D1F697E18F85AE";
      signByDefault = true;
    };

    # Useful aliases
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };

    # Additional config
    extraConfig = {
      core = {
        editor = "codium";
        autocrlf = "input";
      };
      color = {
        ui = "auto";
      };
      pull = {
        rebase = false;
      };
      push = {
        default = "simple";
      };
      init = {
        defaultBranch = "main";
      };
      url = {
        "git@gitlab.com:" = {
          insteadOf = "https://gitlab.com/";
        };
      };
    };
  };
}
