# ❄️ NixOS config

This config is based on [@SailorSnow's](https://github.com/SailorSnoW) config, who did an amazing job with it. Thank you!

I am maindriving this config on Macbook Air M1 8/256. I included (at this time) experimental Asahi Linux branch with external display through USB-C working.

This repository contains my personal NixOS configuration, primarily targeting Apple Silicon via Asahi Linux. Home Manager is integrated into NixOS builds.

—

## 🔐 Encryption (LUKS)

This configuration is designed to work with **Full Disk Encryption (LUKS)**. 

### 🆕 Fresh Install
If you are installing from scratch using the Asahi Linux installer:
1.  Boot into the NixOS installer (USB).
2.  Manually partition and encrypt the disk before installing.
    ```bash
    # Example partitioning (adjust for your drive, e.g., nvme0n1p5)
    cryptsetup luksFormat /dev/nvme0n1pX
    cryptsetup luksOpen /dev/nvme0n1pX cryptroot
    mkfs.ext4 /dev/mapper/cryptroot
    mount /dev/mapper/cryptroot /mnt
    # Don't forget to mount your existing ESP/Boot partition to /mnt/boot!
    ```
3.  Generate the hardware config to capture LUKS settings:
    ```bash
    nixos-generate-config --root /mnt
    ```
4.  Copy the `boot.initrd.luks.devices` section and file system UUIDs from the generated file into `hosts/asahi/hardware-configuration.nix` in this repo before installing.

### 🔄 Migration (Existing System)
If you already have a running system and want to enable encryption, you must **reinstall**, as you cannot encrypt a running partition in-place safely.

—

## 🚀 Usage

### 💽 Deploy on the machine

1) Clone the repository

```bash
git clone https://github.com/pengwius/nixos-config.git
cd nixos-config
```

2) Update Hardware Configuration

You **must** update `hosts/asahi/hardware-configuration.nix` to match your disk's UUIDs.

**If using LUKS (Recommended):**
You need to add the LUKS device mapping so the system can ask for the password at boot.

```nix
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/YOUR-PHYSICAL-PARTITION-UUID";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/YOUR-LUKS-MAPPER-UUID"; # UUID of the decrypted filesystem
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/YOUR-ESP-UUID";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
```

*Tip: Run `lsblk -f` or `blkid` to find these UUIDs.*

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
