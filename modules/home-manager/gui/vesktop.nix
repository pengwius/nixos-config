{ pkgs-unstable, ... }:
{
  # Zero Stylixa w Discordzie: bez tego Stylix wstrzykuje
  # programs.vesktop.vencord.themes.stylix + settings.enabledThemes,
  # przez co settings/settings.json staje się symlinkiem do /nix/store
  # i Vesktop sypie EROFS przy każdym zapisie (klik w plugin = błąd).
  # Wzorzec jak w waybar.nix / vscode.nix / rofi.nix.
  stylix.targets.vesktop.enable = false;
  stylix.targets.vencord.enable = false;

  programs.vesktop = {
    enable = true;

    # Kluczowy fix na brak sekcji Vencord w ustawieniach (nixpkgs#310227, Vesktop#516):
    # systemowy Vencord z nixpkgs jest zwykle przestarzały względem Discorda.
    # Pozwalamy Vesktopowi pobierać Vencorda samodzielnie
    # do ~/.config/vesktop/sessionData/vencordFiles.
    package = pkgs-unstable.vesktop.override {
      withSystemVencord = false;
    };
    vencord.useSystem = false;

    # Ustawienia Vesktopa -> ~/.config/vesktop/settings.json
    # (plik staje się immutable w /nix/store, zmiany tylko przez ten moduł).
    # Opcje: https://github.com/Vencord/Vesktop/blob/main/src/shared/settings.d.ts
    settings = {
      discordBranch = "stable";
      minimizeToTray = false;
      arRPC = true;
      hardwareAcceleration = false;
      checkUpdates = false; # samego Vesktopa aktualizuje nix, nie in-app updater
      splashTheming = true;
      customTitleBar = false;
      staticTitle = false;
      tray = true;
    };

    # Ustawienia Vencorda -> ~/.config/vesktop/settings/settings.json
    # Zostawiamy puste = plik mutable, pluginy klikasz w UI (sekcja Vencord
    # wraca po fiksie z withSystemVencord = false).
    # Gdy zechcesz pełnej deklaratywności, odkomentuj i edytuj tutaj —
    # uwaga: wtedy plik stanie się immutable i UI przestanie zapisywać.
    # Opcje: https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
    vencord.settings = { };
    # vencord.settings = {
    #   autoUpdate = true;
    #   autoUpdateNotification = true;
    #   notifyAboutUpdates = true;
    #   useQuickCss = true;
    #   plugins = {
    #     MessageLogger.enabled = true;
    #   };
    # };

    # Przykładowe custom CSS:
    # vencord.themes = {
    #   mocha = builtins.fetchurl {
    #     url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    #     sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #   };
    # };
  };
}
