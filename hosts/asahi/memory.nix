{ pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 60;
    priority = 200;
  };

  boot.kernelParams = [
    "zfs.zfs_arc_max=2147483648" # 2 GB
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 50;
    "vm.page-cluster" = 0;
    "vm.vfs_cache_pressure" = 200;

    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  systemd.settings.Manager = {
    DefaultMemoryAccounting = "yes";
    DefaultMemoryLow = "10%";
    DefaultMemoryHigh = "50%";
    DefaultCPUAccounting = "yes";
  };

  systemd.oomd = {
    enable = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "20s";
    };
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
