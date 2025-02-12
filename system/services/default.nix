{
  pkgs,
  config,
  ...
}: {
  imports = [
  ];
  # Enables fwupd - CLI-based Firmware Updater
  services.fwupd.enable = true;

  # Ai Service
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };
  # Open-WebUI - Web-based Interface - CURRENTLY BROKEN
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    openFirewall = true;
    stateDir = /var/lib/open-webui;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      WEBUI_URL = "http://0.0.0.0:8080";
      ENABLE_REALTIME_CHAT_SAVE = "True";
      OLLAMA_API_BASE_URL = "http://0.0.0.0:11434";
      WEBUI_AUTH = "False";
      ENABLE_RAG_WEB_SEARCH = "True";
      ENABLE_SEARCH_QUERY_GENERATION = "True";
      RAG_WEB_SEARCH_RESULT_COUNT = "3";
      RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";
      RAG_WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://0.0.0.0:8888/search?q=<query>";
    };
  };
  # Btrfs Services
  services.btrfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [
        "/"
        "/home"
        "/nix"
        "/var"
        "/var/log"
      ];
    };
  };
}
