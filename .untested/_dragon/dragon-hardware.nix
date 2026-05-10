{
  flake.nixosModules.dragon =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      # ------------------------------------------------------------------ #
      # Filesystems
      # ------------------------------------------------------------------ #

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/e597caed-fde3-4542-aca0-a888cdd05820";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C00D-9712";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      # ------------------------------------------------------------------ #
      # Swap device
      # ------------------------------------------------------------------ #

      # swapDevices = [
      #   {
      #     device = ""; # device UUID: sudo blkid
      #     options = [ "discard" ]; # equivalent to swapon --discard
      #   }
      # ];

      # boot.kernelParams = [
      #   "zswap.enabled=1" # enable zswap compressed swap cache
      #   "zswap.compressor=lz4" # compression algorithm
      #   "zswap.max_pool_percent=25" # cap zswap at 25% of RAM
      #   "zswap.shrinker_enabled=1" # proactively shrink pool under memory pressure
      # ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
