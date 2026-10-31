{ pkgs, config, ... }:

let
  customKernelZfs = config.boot.kernelPackages.zfs_2_4.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace config/kernel.m4 --replace-fail \
        "kern_max_version_ok=no" \
        "kern_max_version_ok=yes"
      substituteInPlace META --replace-fail \
        "Linux-Maximum: 7.0" \
        "Linux-Maximum: 7.1.5"
    '';
  });
in
{
  boot = {
    supportedFilesystems = [ "zfs" ];

    zfs.package = pkgs.zfs_2_4;
    zfs.modulePackage = customKernelZfs;

    extraModulePackages = [ customKernelZfs ];
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

  # Cap ARC na 1GiB — na maszynach z małym RAM niekontrolowany ARC
  # zjada pamięć podręczną ZFS. (Przeniesione z asahi/memory.nix.)
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  nixpkgs.config.allowBroken = true;

  # UWAGA: networking.hostId MUSI być unikalny na host — ustaw go
  # w configuration.nix konkretnego hosta, nie tutaj.
}
