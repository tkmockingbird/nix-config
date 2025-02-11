{
  config,
  pkgs,
  ...
}: {
  # Git configuration
  programs.git = {
    enable = true;

    # Credentials
    userName = "tkmockingbird";
    userEmail = "zbellpeppers@pm.me";

    package = pkgs.git;

    # SSH key configuration
    signing = {
      key = "FB2FE1FF9B798BCF0B658B9D7A06710E5DF66E07";
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
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
