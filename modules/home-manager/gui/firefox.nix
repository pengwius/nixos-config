{ pkgs, pkgs-unstable, ... }:
{
  programs.firefox = {
    enable = true;
    # Świeży Firefox z kanału unstable — reszta systemu zostaje na 26.05.
    package = pkgs-unstable.firefox;

    profiles = {
      pengwius = {
        isDefault = true;

        settings = {
          # --- Wydajność (Twoje stare, zostawione) ---
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

          "intl.regional_prefs.use_os_locale" = true;

          # --- Własny userChrome (poniżej) wymaga tych dwóch ---
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "browser.theme.dark-private-windows" = false;
          "ui.systemUsesDarkTheme" = 1;

          # --- Karty po lewej: natywne vertical tabs.
          # Dół sidebara sam dostaje ikonki historii i ustawień. ---
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;

          # Dół szyny: tylko historia (wylatują hasła, zakładki,
          # synchronizowane karty i AI). HM zapisuje to do user.js,
          # więc resetuje się przy każdym starcie — tak ma być.
          "sidebar.main.tools" = "history";

          # 1 = przyciski okna widoczne (potrzebne na Niri).
          "browser.tabs.inTitlebar" = 1;

          # --- Czysty newtab ---
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # --- Mniejszy interfejs: tryb compact + zejście z HiDPI 2x.
          # devPixelsPerPx MUSI być stringiem, inaczej FF to zignoruje. ---
          "browser.uidensity" = 1;
          "layout.css.devPixelsPerPx" = "-1";
        };

        userChrome = builtins.readFile ./firefox/material-expressive.css;
        userContent = ''
          @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
            :root {
              color-scheme: dark;
              --newtab-background-color: #30283e !important;
              --newtab-text-primary-color: #eee5f5 !important;
              --newtab-primary-action-background: #ac8bf9 !important;
            }
            body { background-color: #30283e !important; }
          }
        '';

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

  # The local Material theme shares Noctalia's palette and keeps native vertical tabs.
  stylix.targets.firefox.enable = false;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
