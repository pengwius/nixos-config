{ pkgs, lib, ... }:

{
  services.earlyoom = {
    enable = true;
    enableNotifications = false;
    freeMemThreshold = 15;
    freeSwapThreshold = 15;
    extraArgs = [
      "--prefer" "(^|/)(rust-analyzer|cargo|rustc|firefox|electron)$"
      "--avoid" "(^|/)(systemd|Xwayland|pipewire|dbus-daemon|NetworkManager|zed|MainThread|.zed-editor-wrapped|wakatime-ls|earlyoom|slice|session.slice|niri|niri-session)$"
    ];
  };

  systemd.oomd.enable = false;

  systemd.services.niri = {
    serviceConfig.OOMScoreAdjust = -1000;
  };

  systemd.services.MainThread = {
    serviceConfig.OOMScoreAdjust = -1000;
  };

  systemd.services.zed = {
    serviceConfig.OOMScoreAdjust = -1000;
  };

  systemd.services.niri-session = {
    serviceConfig.OOMScoreAdjust = -1000;
  };

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
    "vm.swappiness" = 10;
    "vm.page-cluster" = 0;

    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 100;

    "vm.vfs_cache_pressure" = 100;
    "vm.overcommit_memory" = 0;
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
