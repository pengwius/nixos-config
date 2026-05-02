{ pkgs, lib, ... }:

{
  services.earlyoom = {
    enable = true;
    enableNotifications = false;
    freeMemThreshold = 10;
    freeSwapThreshold = 10;
    extraArgs = [
      "--prefer" "(^|/)(rust-analyzer|cargo|rustc|firefox|electron|WebKitWebProcess|WebKitNetworkProcess|node|npm|vite|tauri|esbuild|zed|MainThread|\\.zed-editor-wrapped)$"
      "--avoid" "(^|/)(systemd|Xwayland|pipewire|dbus-daemon|NetworkManager|wakatime-ls|earlyoom|slice|session.slice|niri|niri-session)$"
    ];
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  systemd.oomd.enable = false;



  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 180;
  };

  boot.kernelParams = [
    "zfs.zfs_arc_max=2147483648" # 2GB
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;

    "vm.watermark_scale_factor" = 500;
    "vm.min_free_kbytes" = 409600;

    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    "vm.vfs_cache_pressure" = 150;
  };

  systemd.settings.Manager = {
    DefaultMemoryAccounting = "yes";
  };

  systemd.services.mglru = {
    description = "Configure MGLRU min TTL";
    enable = true;
    wantedBy = [ "basic.target" ];

    script = ''
      echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms
    '';

    serviceConfig = {
      Type = "oneshot";
    };

    unitConfig = {
      ConditionPathExists = "/sys/kernel/mm/lru_gen/enabled";
    };
  };
}
