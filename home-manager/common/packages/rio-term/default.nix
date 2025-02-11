{...}: {
  programs.rio = {
    enable = true;
    settings = {
      cursor = {
        shape = "beam";
        blinking = true;
        blinking-interval = 800;
      };
    };
  };
}
