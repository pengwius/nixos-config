{ pkgs, ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.package = pkgs.zfs_2_4;
    #zfs.enable = true;
    extraModulePackages = [
      pkgs.zfs_2_4
    ];
    #zfs.forceImportRoot = true;
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    monthly = 1;
    weekly = 4;
    daily = 7;
    hourly = 24;
  };

  services.zfs.trim.enable = true;

  nixpkgs.config.allowBroken = true;

  networking.hostId = "abcdef12";
}
