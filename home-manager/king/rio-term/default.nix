{...}: {
  programs.rio = {
    enable = true;
    settings = {
      theme = "/home/zachary/.config/themes/Breeze.toml";
      hide-cursor-when-typing = true;
      padding-x = 8;
      padding-y = [
        10
        5
      ];

      confirm-before-quit = false;

      cursor = {
        shape = "beam";
        blinking = true;
        blinking-interval = 800;
      };

      editor = {
        program = "codium";
      };

      window = {
        width = 1110;
        height = 590;
        mode = "windowed";
        opacity = 1.0;
        blur = false;
        decorations = "enabled";
      };

      renderer = {
        performance = "High";
        backend = "Vulkan";
        disable-unfocused-render = false;
        level = 1;
      };

      fonts = {
        size = 16;

        regular = {
          family = "FiraCode Nerd Font Mono";
          style = "Normal";
          weight = 400;
        };
      };

      shell = {
        program = "/run/current-system/sw/bin/fish";
        args = ["--login"];
      };
    };
  };
}
