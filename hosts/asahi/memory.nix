{ pkgs, lib, ... }:

{
  # High-performance OOM daemon that uses Pressure Stall Information (PSI)
  # This is much more reliable than earlyoom for preventing system freezes.
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "20s";
    };
  };

  # Disable earlyoom as we are transitioning to systemd-oomd
  services.earlyoom.enable = false;

  # Performance auto-nice daemon
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  # ZRAM configuration (Compressed RAM)
  # This acts like macOS "Compressed Memory", providing more virtual RAM without disk latency.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150; # 12GB virtual swap for 8GB physical RAM
    priority = 1000;    # Ensure ZRAM is used before any other swap
  };

  boot.kernelParams = [
    "zfs.zfs_arc_max=1073741824" # 1GB (Reduced from 2GB to free up RAM for apps)
  ];

  # Kernel Samepage Merging (KSM)
  # Scans RAM for duplicate pages and merges them, saving significant memory 
  # when running multiple similar apps (e.g. Electron-based apps).
  hardware.ksm.enable = true;

  boot.kernel.sysctl = {
    # Aggressively swap inactive pages to ZRAM
    "vm.swappiness" = 180;
    
    # Minimize page-clustering for ZRAM
    "vm.page-cluster" = 0;

    # Proactive reclaim tuning
    "vm.watermark_scale_factor" = 200;
    "vm.min_free_kbytes" = 409600;

    # Faster writeback to prevent dirty page accumulation
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    # Prioritize application memory over file cache (macOS-like)
    # 100 is default, 200 makes the kernel much more willing to reclaim cache.
    "vm.vfs_cache_pressure" = 200;
  };

  systemd.settings.Manager = {
    DefaultMemoryAccounting = "yes";
  };

  # MGLRU (Multi-Gen LRU) tuning
  # We let the kernel manage min_ttl dynamically for better responsiveness.
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
