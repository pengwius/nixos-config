# ❄️ NixOS config

This config is based on [@SailorSnow's](https://github.com/SailorSnoW) config, who did an amazing job with it. Thank you!

I am maindriving this config on Macbook Air M1 8/256. I included (at this time) experimental Asahi Linux branch with external display through USB-C working.

This repository contains my personal NixOS configuration, primarily targeting Apple Silicon via Asahi Linux. Home Manager is integrated into NixOS builds.

—

## 🚀 Usage

### 💽 Deploy on the machine

1) Clone the repository

```bash
git clone https://github.com/pengwius/nixos-config.git
cd nixos-config
```

2) Change partition UUIDs in `hosts/asahi/hardware-configuration.nix` to match your system

```nix 
fileSystems."/" = {
  device = "/dev/disk/by-uuid/6ca13db7-eb93-4068-a533-1bcc0e258fe1";
  fsType = "ext4";
};

fileSystems."/boot" = {
  device = "/dev/disk/by-uuid/40B2-1A23";
  fsType = "vfat";
  options = [
    "fmask=0022"
    "dmask=0022"
  ];
};
```

You can find the UUIDs by running `lsblk -f` or `blkid`.

3) Change usernames in 
 - `/flake.nix`
 - `/home-manager/home.nix`
 - `/hosts/asahi/configuration.nix`
 - `/hosts/common/users.nix`
 - `/modules/home-manager/gui/firefox.nix`
 
 to match your desired username

4) Rebuild the system (Asahi host)

```bash
sudo nixos-rebuild switch --flake .#asahi
```

Optional: Home Manager only (ad‑hoc)

```bash
home-manager switch --flake .#<username>@asahi
```

—

## 🔧 Build, Test, Update

- Evaluate/check flake:
  ```bash
  nix flake check
  ```
- Build system closure (dry):
  ```bash
  nix build .#nixosConfigurations.asahi.config.system.build.toplevel
  ```
- Update inputs:
  ```bash
  nix flake update
  ```

—

## 🖥️ Host

- `asahi`: Asahi Linux on Apple Silicon (daily driver)

## 📦 Repository Structure

- `flake.nix`/`flake.lock`: Flake entry and locked inputs
- `hosts/`
  - `asahi/`: Host configuration (imports Apple Silicon support)
  - `common/`: Shared host glue (`boot.nix`, `locale.nix`, `desktop.nix`, `users.nix`)
- `home-manager/`: User config and assets; applied via system rebuilds
- `modules/`
  - `modules/nixos/`: Reusable NixOS modules (e.g., `netdata.nix`, `minecraft-server-*.nix`)
  - `modules/home-manager/`: Reusable HM modules (e.g., `zsh.nix`, `neovim/`, `gui/`)
- `overlays/`: Overlays including an `unstable` package set
- `pkgs/`: Custom packages (e.g., `tentrackule`)
- `dotfiles/`: Misc dotfiles not managed as HM modules

—

## 🧩 Notable Choices

- Wayland compositor: Niri (via `services.greetd` session)
- Stylix for theming and fonts
- Podman (Docker‑compat) enabled with DNS for compose
- Bluetooth via BlueZ + Blueman
- Home Manager modules for Zsh, Neovim (nixCats), GUI apps (Firefox, Ghostty, etc.)

—

## ❄️ Notes

This is a personal setup tuned for my hardware and workflow. Feel free to explore and adapt it.
