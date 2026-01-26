{ pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 70;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 140;
    "vm.page-cluster" = 0;

    "vm.dirty_background_bytes" = 134217728; # 128 MB
    "vm.dirty_bytes" = 268435456;             # 256 MB

    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
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
