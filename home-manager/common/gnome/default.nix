{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    orchis-theme
    papirus-icon-theme
    papirus-folders
    dconf2nix
    gnome-tweaks
    gnome-shell-extensions
    gnome-builder
  ];

  programs.gnome-shell = {
    enable = true;
    theme = {
      name = "Orchis-Dark-Compact";
      package = pkgs.orchis-theme;
    };
    extensions = with pkgs.gnomeExtensions; [
      {package = dash-to-panel;}
      {package = brightness-control-using-ddcutil;}
      {package = extension-list;}
      {package = desktop-icons-ng-ding;}
      {package = just-perfection;}
    ];
  };

  xdg.desktopEntries = {
    "smartcode-stremio" = {
      name = "Stremio";
      exec = "stremio";
      icon = "stremio";
    };
    "equibop" = {
      name = "Discord";
      exec = "equibop";
      icon = "discord";
    };
    "org.speedcrunch.SpeedCrunch" = {
      name = "Calculator";
      exec = "speedcrunch";
      icon = "org.gnome.Calculator";
    };
    "kitty" = {
      name = "Terminal";
      exec = "kitty";
      icon = "terminal";
    };
  };

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/control-center" = {
      last-panel = "system";
      window-state = mkTuple [980 640 false];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = ["X-Pardus-Apps"];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["org.freedesktop.GnomeAbrt.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.freedesktop.MalcontentControl.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop"];
      categories = ["X-GNOME-Utilities"];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = ["X-SuSE-YaST"];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "us+workman"]) (mkTuple ["xkb" "us"])];
      xkb-options = ["grp:win_space_toggle" "caps:capslock"];
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      document-font-name = "Roboto 11";
      font-antialiasing = "rgba";
      font-name = "Roboto 11";
      gtk-theme = "Orchis-Dark-Compact";
      icon-theme = "Papirus-Dark";
      monospace-font-name = "Roboto Mono 10";
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["zen" "org-kde-kdeconnect-daemon"];
    };

    "org/gnome/desktop/notifications/application/org-kde-kdeconnect-daemon" = {
      application-id = "org.kde.kdeconnect.daemon.desktop";
    };

    "org/gnome/desktop/notifications/application/zen" = {
      application-id = "zen.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 5;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = mkUint32 30;
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = ["org.gnome.Settings.desktop" "org.gnome.Contacts.desktop" "org.gnome.Nautilus.desktop"];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 3;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small-plus";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [890 550];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;
      night-light-schedule-to = 0.0;
      night-light-temperature = mkUint32 2143;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["dash-to-panel@jderose9.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "display-brightness-ddcutil@themightydeity.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "status-icons@gnome-shell-extensions.gcampax.github.com"];
      welcome-dialog-last-shown-version = "47.3";
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      available-monitors = [1 0];
      primary-monitor = 1;
    };

    "org/gnome/shell/extensions/display-brightness-ddcutil" = {
      button-location = 0;
      ddcutil-binary-path = "/nix/store/0fpq60h4dpydgjppsrwr7mgs0g5k0bcy-ddcutil-2.1.4/bin/ddcutil";
      ddcutil-queue-ms = 130.0;
      ddcutil-sleep-multiplier = 40.0;
      decrease-brightness-shortcut = ["<Control>XF86MonBrightnessDown"];
      increase-brightness-shortcut = ["<Alt>pgup"];
      only-all-slider = true;
      position-system-menu = 3.0;
      show-all-slider = true;
      show-osd = true;
      show-value-label = true;
      step-change-keyboard = 1.0;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Orchis-Dark-Compact";
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 159;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [2265 74];
      window-size = mkTuple [1231 902];
    };
  };
}
