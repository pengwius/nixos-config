{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;

    profiles = {
      pengwius = {
        settings = {
          "browser.tabs.unloadOnLowMemory" = true;
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;
          "browser.sessionstore.interval" = 6000;
          "browser.cache.memory.enable" = true;
          "browser.cache.memory.capacity" = 262144;

          "dom.ipc.processCount" = 2;
          "dom.ipc.processCount.webIsolated" = 2;
          "browser.sessionhistory.max_entries" = 10;
          "browser.sessionhistory.max_total_viewers" = 1;
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          bitwarden
          startpage-private-search
          firefox-color
          darkreader
          react-devtools
        ];
      };
    };
  };

  stylix.targets.firefox.profileNames = [ "pengwius" ];

  textfox = {
    enable = true;
    profile = "pengwius";
    config = {
      border = {
        color = "#393552";
        width = "2px";
        transition = "0.3s ease";
        radius = "12px";
      };
      displayWindowControls = true;
      displayNavButtons = true;
      displayUrlbarIcons = true;
      displaySidebarTools = false;
      displayTitles = false;
      font = {
        family = "FiraCode Nerd Font Ret";
        size = "15px";
      };
    };

  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
