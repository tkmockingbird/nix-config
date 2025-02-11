{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    userSettings = {
      "workbench.colorTheme" = "One Dark Pro Darker";
      "workbench.iconTheme" = "material-icon-theme";
      editor = {
        "fontFamily" = "FiraCode Nerd Font Mono";
        "fontWeight" = "600";
        "wordWrap" = "on";
        "formatOnPaste" = true;
        "formatOnSave" = true;
        "fontLigatures" = true;
        "fontSize" = 15;
        "tabSize" = 2;
        "quickSuggestions" = {
          "other" = true;
          "comments" = false;
          "strings" = true;
        };
        "snippetSuggestions" = "top";
        "tokenColorCustomizations" = {
          "textMateRules" = [
            {
              "scope" = "comment";
              "settings" = {
                "foreground" = "#a0a0a0";
              };
            }
          ];
        };
        "cursorStyle" = "line";
        "overviewRulerBorder" = false;
        "renderWhitespace" = "all";
        "rulers" = [80 120];
        "minimap.enabled" = false;
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "extensions.autoCheckUpdates" = true;
      "extensions.autoUpdate" = false;
    };
  };
}
