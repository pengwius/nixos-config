# Low-memory survival kit — przenośne, bez założeń o ZFS i SoC.
# Wydzielone z hosts/asahi/memory.nix (linia zfs_arc_max trafiła do ../features/zfs.nix).
# Importuj na hostach z małą ilością RAM (asahi 8GB, gruchot).
{ pkgs, lib, ... }:

{
  # === EARLYOOM: LATA SIATKA BEZPIECZEŃSTWA ===
  # Gdy wolnego RAM/spraw zupełnie brakuje — zabija proces, zamiast pozwolić
  # systemowi zawisnąć. --prefer to PIERWSZE ofiary (buildy — restartowalne),
  # --avoid = nigdy nie zabijaj (desktop, shell, edytor).
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeSwapThreshold = 10;
    extraArgs = [
      "--prefer" "^(cargo|rustc|cc|gcc|clang|g++|ld|lld|ninja|make|meson|cmake|python|nix-build|nix-daemon)$"
      "--avoid" "^(bash|zsh|fish|tmux|ssh|sudo|sudoedit|niri|noctalia|Xwayland|firefox|zed|ghostty|pipewire|WirePlumber)$"
    ];
  };

  # === SYSTEMD-OOMD: PRESSURE-BASED REACTOR ===
  # Działa wcześniej niż earlyoom - reaguje na PSI zanim RAM się zapcha.
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    settings.OOM = {
      DefaultMemoryPressureLimit = "80%";
      DefaultMemoryPressureDurationSec = "20s";
    };
  };

  # === ZRAM: KOMPRESJA W RAMIE (JEDYNY SWAP) ===
  # Strony nieużywane → kompresja (zstd) → zwolnienie RAMU.
  # UWAGA: na hoście z ZFS nie dokładaj swapa na zvolu — swap na zvolu
  # to udokumentowany wektor deadlocka w OpenZFS (AB-BA przy presji pamięci).
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150;
    priority = 1000;
  };

  # KSM off: ksmd skanuje i scala strony, na małym RAM jedząc CPU i dodając
  # opóźnienia — był włączony w każdym z dotychczasowych zawieszeń.
  hardware.ksm.enable = false;

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  boot.kernel.sysctl = {
    # Zbalansowane swapowanie — jedyny swap to zram, nie trzeba agresywnie
    # wypychać (wcześniej 150 na potrzeby "aktywnego" zvola).
    "vm.swappiness" = 100;

    # Zero klasteryzacji stron (ważne dla ZRAM)
    "vm.page-cluster" = 0;

    # Default (10) — kernel zaczyna reclaim dopiero przy realnym ciśnieniu.
    # Wcześniej 500 hpowało pozorny brak pamięci i non-stop evictowało strony,
    # przez co system freeze'ował mimo wolnego swapa.
    "vm.watermark_scale_factor" = 10;

    # Modesta rezerwa dla jądra (128MB zamiast 1GB — te 1GB ciasno na 8GB RAM).
    "vm.min_free_kbytes" = 131072;

    # Brudne strony zrzucane natychmiast
    "vm.dirty_ratio" = 5;
    "vm.dirty_background_ratio" = 2;

    # Łagodne zrzucanie cache'ów (default 100; wcześniej 500 = za agresywne)
    "vm.vfs_cache_pressure" = 100;

    # Pozwala na kompakcję stron, których nie da się wyrzucić
    "vm.compact_unevictable_allowed" = 1;

    # === SIATKA NA LOCKUP (warstwa B) ===
    # Zamiast 1,5h zawisu — auto-reboot przy soft/hard lockup albo oopsie.
    "kernel.panic" = 10;
    "kernel.softlockup_panic" = 1;
    "kernel.nmi_watchdog" = 1;
    "kernel.hung_task_panic" = 1;
    "kernel.panic_on_oops" = 1;
    # Stosy w logu po ~4 min D-state (gdyby nie było pełnego zawisu).
    "kernel.hung_task_timeout_secs" = 240;
  };

  systemd.settings.Manager = {
    DefaultMemoryAccounting = "yes";
    # Karmienie sprzętowego watchdoga (np. /dev/watchdog0 na Apple SoC):
    # jeśli system zawiesi się tak mocno, że karmienie ustanie,
    # sprzęt zresetuje po ~30s.
    RuntimeWatchdogSec = "30";
  };

  # MGLRU (Multi-Gen LRU)
  # Nowoczesny algorytm reclaimu stron, lepszy niż klasyczny LRU.
  systemd.services.mglru = {
    description = "Configure MGLRU";
    enable = true;
    wantedBy = [ "basic.target" ];
    script = ''
      if [ -f /sys/kernel/mm/lru_gen/enabled ]; then
        echo y > /sys/kernel/mm/lru_gen/enabled
        echo 0 > /sys/kernel/mm/lru_gen/min_ttl_ms
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
