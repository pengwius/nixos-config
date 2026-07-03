{
  lib,
  callPackage,
  linuxPackagesFor,
  _kernelPatches ? [ ],
}:

let
  linux-asahi-pkg =
    {
      stdenv,
      lib,
      fetchFromGitHub,
      buildLinux,
      rustfmt,
      ...
    }:
    buildLinux rec {
      inherit stdenv lib;

      nativeBuildInputs = [ rustfmt ];

      pname = "linux-asahi";

      # External displays through USB-C DP ALT MODE works on this branch
      version = "7.0.11-fairydust";
      modDirVersion = "7.0.11";
      extraMeta.branch = "7.0.11";

      src = fetchFromGitHub {
        owner = "AsahiLinux";
        repo = "linux";
        rev = "77e0fe0c47e847221988f6397167bc23fec2a042";
        hash = "sha256-wnNrbpa3dYceQU7ZeJ7eJH6k9QMqswctK/4xxGI9SZE=";
      };

      ignoreConfigErrors = true;

      kernelPatches = [
        {
          name = "Asahi config";
          patch = null;
          structuredExtraConfig = with lib.kernel; {
            # Needed for GPU
            ARM64_16K_PAGES = yes;

            ARM64_MEMORY_MODEL_CONTROL = yes;
            ARM64_ACTLR_STATE = yes;

            # Might lead to the machine rebooting if not loaded soon enough
            APPLE_WATCHDOG = yes;

            # Can not be built as a module, defaults to no
            APPLE_M1_CPU_PMU = yes;

            # Defaults to 'y', but we want to allow the user to set options in modprobe.d
            HID_APPLE = module;

            APPLE_PMGR_MISC = yes;
            APPLE_PMGR_PWRSTATE = yes;
            APPLE_MAILBOX = yes;
            APPLE_RTKIT = yes;
            APPLE_RTKIT_HELPER = yes;

            # Needed for Rust firmware abstractions
            RUST_FW_LOADER_ABSTRACTIONS = yes;
          };
          features.rust = true;
        }
      ]
      ++ _kernelPatches;
    };

  linux-asahi = callPackage linux-asahi-pkg { };
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
