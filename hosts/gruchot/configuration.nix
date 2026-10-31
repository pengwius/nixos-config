# gruchot — stary MacBook (x86_64 Intel, ext4, bez ZFS i bez Asahi).
# Przepis na hosta: common + wybrane features + to co stricte sprzętowe.
{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../features/desktop.nix
    ../features/lowmem.nix
  ];

  # Główny user tego hosta — konsumuje hosts/common (users.nix, ścieżki).
  _module.args.mainUser = "pengwius";

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "gruchot";

  # Intel: mikrokod + firmware (m.in. Broadcom WiFi w MacBookach).
  # Jak WiFi nie wstanie, testuj z kabelkiem i daj znać — dołożymy broadcom_sta.
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  users.users.pengwius = {
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "render"
      "input"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite
    iw
  ];

  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true;
    fstrim.enable = true;
    udisks2.enable = true;
  };

  programs.niri.enable = true;
  programs.xwayland.enable = true;
  services.xserver.enable = true;

  services.openssh.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
  };

  # Ustawić raz przy instalacji, potem NIE ruszać.
  system.stateVersion = "25.11";
}
