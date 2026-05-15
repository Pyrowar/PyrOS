{
  flake.nixosModules.pyro =
    {
      config,
      inputs,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.msi-b350-tomahawk
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      # ------------------------------------------------------------------ #
      # Dual booting
      #
      # After committing changes to the bootloader, run:
      #   sudo nixos-rebuild boot --flake /etc/nixos --install-bootloader
      # To find the Windows EFI partition UUID:
      #   sudo blkid | grep -i efi
      # ------------------------------------------------------------------ #
      boot.loader.limine = {
        extraEntries = ''
          /Windows 10
            protocol: efi
            image_path: uuid(d4e98ad0-f84f-4e67-a722-7c19900b75de):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };

      # ------------------------------------------------------------------ #
      # Secure boot
      #
      # 1. Create keys:
      #      nix run nixpkgs#sbctl -- create-keys
      # 2. Disable factory keys in BIOS, then enroll:
      #      sudo sbctl enroll-keys --microsoft --firmware-builtin
      # 3. Set secureBoot.enable = true above and re-enable in BIOS.
      # 4. Verify:
      #      sudo bootctl status
      # ------------------------------------------------------------------ #
      boot.loader.limine = {
        secureBoot.enable = true;
      };

      # ------------------------------------------------------------------ #
      # Swap device
      # ------------------------------------------------------------------ #

      swapDevices = [
        {
          device = "/dev/disk/by-uuid/2bcd4beb-e129-4b9f-921a-8d8187f6c408"; # device UUID: sudo blkid
          options = [ "discard" ]; # equivalent to swapon --discard
        }
      ];

      boot.kernelParams = [
        "zswap.enabled=1" # enable zswap compressed swap cache
        "zswap.compressor=lz4" # compression algorithm
        "zswap.max_pool_percent=25" # cap zswap at 25% of RAM
        "zswap.shrinker_enabled=1" # proactively shrink pool under memory pressure
      ];

      # ------------------------------------------------------------------ #
      # NVMe
      # ------------------------------------------------------------------ #

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/0B0A-4B71";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
        ];
      };

      fileSystems."/home/.snapshots" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@home_snapshots"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/var" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@var"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@nix"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/home/pyro/Games" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@games"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Appimages" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@appimages"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/git" = {
        device = "/dev/disk/by-uuid/361bab6a-413b-47cf-a822-af4f74f438a1";
        fsType = "btrfs";
        options = [
          "subvol=@git"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      # ------------------------------------------------------------------ #
      # Barracuda
      # ------------------------------------------------------------------ #

      fileSystems."/mnt/Barracuda" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "defaults"
          "nofail"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
          "x-gvfs-show"
        ];
      };
      # mount barracuda @subvolumes to /home:
      fileSystems."/home/pyro/Dokumenty" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@dokumenty"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Muzyka" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@muzyka"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Obrazy" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@obrazy"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Wideo" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@wideo"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Projekty" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@projekty"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      fileSystems."/home/pyro/Gry" = {
        device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
        fsType = "btrfs";
        options = [
          "subvol=@gry"
          "compress=zstd"
          "noatime"
          "nofail"
          "x-gvfs-trash"
          "x-gvfs-hide"
        ];
      };

      # ------------------------------------------------------------------ #
      # Western Digital
      # ------------------------------------------------------------------ #

      fileSystems."/mnt/WDigital" = {
        device = "/dev/disk/by-uuid/08049f35-0831-4847-ba6e-3f0663161181";
        fsType = "btrfs";
        options = [
          "defaults"
          "nofail"
          "compress=zstd"
          "noatime"
          "x-gvfs-trash"
          "x-gvfs-show"
        ];
      };

      # ------------------------------------------------------------------ #
      # Btrfs
      # ------------------------------------------------------------------ #

      # Snapshots dir needs special permissions:
      # sudo chmod 700 /home/.snapshots
      services.snapper = {
        snapshotInterval = "hourly";
        cleanupInterval = "1d";
        configs.home = {
          SUBVOLUME = "/home";
          FSTYPE = "btrfs";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = "8";
          TIMELINE_LIMIT_DAILY = "6";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "2";
          TIMELINE_LIMIT_YEARLY = "1";
        };
      };

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [
          "/"
          "/mnt/Barracuda"
        ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    };

}
