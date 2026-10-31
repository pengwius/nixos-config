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

        # Własny, minimalny userChrome — żaden framework (ani Textfox,
        # ani gnome-theme). Czarne tła, outlined tab, font TUI,
        # ikonki i toggle w accencie (Rosé Pine Moon iris).
        userChrome = ''
          /* 1. Poziome taby precz — karty tylko po lewej. */
          #TabsToolbar {
            display: none !important;
          }

          /* 2. Tła bardziej czarne. Tabom tła zeruje sekcja 3. */
          #sidebar-box, #sidebar-container, #navigator-toolbox,
          #tabbrowser-tabbox, #browser {
            background-color: #0a0a10 !important;
          }

          /* 3. Zaznaczony tab: sam obrys w accencie, zero backlightu.
             FF156 trzyma wygląd taba w zmiennych (tabs.css):
             --tab-background-color-selected robi szare wypełnienie,
             --tab-selected-outline-color maluje fabryczny obrys
             na .tab-background (ten ładny wewnętrzny),
             a [selected]/[visuallyselected] nie mają wartości ="true",
             więc matchujemy bez wartości. */
          #tabbrowser-tabs {
            --tab-background-color-selected: transparent !important;
            --tab-selected-outline-color: #c4a7e7 !important;
            --tab-box-shadow-selected: none !important;
          }
          .tabbrowser-tab .tab-stack,
          .tabbrowser-tab .tab-background {
            background: transparent !important;
            background-color: transparent !important;
            background-image: none !important;
            border-color: transparent !important;
            box-shadow: none !important;
          }

          /* 4. Font UI: ten co na początku (FiraCode), ciut mniejszy. */
          #navigator-toolbox {
            font-family: "FiraCode Nerd Font Ret", monospace !important;
            font-size: 13px !important;
          }

          /* 5. Ikonki w accent color (iris z Rosé Pine Moon). */
          :root {
            --toolbarbutton-icon-fill: #c4a7e7 !important;
            --toolbarbutton-icon-fill-attention: #eb6f92 !important;
          }

          /* 6. Toggle sidebara w górnym pasku: accent z przeźroczystością
             zamiast szarego podświetlenia (hover jaśniejszy niż aktywny). */
          #sidebar-button:not([disabled="true"]):hover > .toolbarbutton-icon {
            background-color: rgba(196, 167, 231, 0.18) !important;
            color: #c4a7e7 !important;
          }
          #sidebar-button[checked="true"] > .toolbarbutton-icon,
          #sidebar-button[open="true"] > .toolbarbutton-icon {
            background-color: rgba(196, 167, 231, 0.25) !important;
            color: #c4a7e7 !important;
          }

          /* 7. Hover w menu: accent z opacity zamiast niebieskiego.
             FF używa tu atrybutu _moz-menuactive, nie :hover. */
          menu[_moz-menuactive="true"],
          menuitem[_moz-menuactive="true"] {
            background-color: rgba(196, 167, 231, 0.25) !important;
            color: #e0def4 !important;
          }

          /* 8. Adres wycentrowany zamiast do lewej. */
          #urlbar-input,
          #urlbar-input::placeholder {
            text-align: center !important;
          }

          /* 9. Podpowiedzi w pasku adresu: accent z opacity zamiast
             niebieskiego — tak jak w menu kontekstowych.
             Fabryka (view-nova/proton.css) maluje wiersze zmiennymi
             --urlbarview-background-color-selected/hover, więc gasimy
             zmienne i dopinamy jawne reguły. */
          #urlbar-view {
            --urlbarview-background-color-selected: rgba(196, 167, 231, 0.25) !important;
            --urlbarview-text-color-selected: #e0def4 !important;
            --urlbarview-background-color-hover: rgba(196, 167, 231, 0.18) !important;
          }
          .urlbarView-row:is([selected], :hover) {
            background-color: rgba(196, 167, 231, 0.25) !important;
            color: #e0def4 !important;
          }

          /* 10. Autouzupełnianie w inpucie adresu: dopisana końcówka
             jest natywnym zaznaczeniem tekstu (selection), defaultowo
             niebieskim — przemalowujemy na accent. */
          #urlbar-input::selection {
            background-color: rgba(196, 167, 231, 0.35) !important;
            color: #e0def4 !important;
          }

          /* 7. Zwarty pasek — prosto i bez śmieci. */
          #nav-bar {
            padding: 4px 6px !important;
          }
          #urlbar-container {
            margin: 0 4px !important;
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

  # Żaden zewnętrzny theme chrome: ani Textfox, ani Stylixowy
  # firefox-gnome-theme (ten wyglądał okropnie). Kolory bazowe
  # (Rosé Pine Moon) nakładasz motywem przez Firefox Color —
  # tam też znajdziesz motywy z Miku na górny pasek.
  stylix.targets.firefox.enable = false;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
