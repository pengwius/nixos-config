{ pkgs, ... }:

{
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    supportedFilesystems = [ "zfs" ];
    zfs.package = pkgs.zfs_2_4;
    #zfs.enable = true;
    extraModulePackages = [
      pkgs.zfs_2_4
    ];
    #zfs.forceImportRoot = true;
  };

  nixpkgs.config.allowBroken = true;

  networking.hostId = "abcdef12";
}
