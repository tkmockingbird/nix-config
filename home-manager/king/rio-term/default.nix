{...}: {
  programs.rio = {
    enable = true;
    settings = {
      hide-cursor-when-typing = true;
      padding-x = 8;
      padding-y = ["10" "5"];

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
          family = "MesloLGS Nerd Font Mono";
          style = "Normal";
          weight = 400;
        };
      };

      shell = {
        program = "/etc/profiles/per-user/zachary/bin/nu";
        args = ["--login"];
      };
    };
  };
}
