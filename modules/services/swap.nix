# BUG: zswapfile hangs entire boot?
{
  flake.nixosModules.swap =
    { config, lib, ... }:
    {
      # ------------------------------------------------------------------ #
      # Options
      # ------------------------------------------------------------------ #

      options.system.swap = {

        method = lib.mkOption {
          type = lib.types.enum [
            "zram"
            "zswapfile"
          ];
          description = "Swap method to use. Either zram or a zswapfile.";
        };

        hibernate = lib.mkEnableOption "hibernate support";

        size = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Swap size in GiB. Used for zswapfile only.";
        };

        device = lib.mkOption {
          type = lib.types.enum [
            "desktop"
            "laptop"
          ];
          default = "desktop";
          description = "Device type. Laptop enables additional power management behaviour.";
        };
      };

      # ------------------------------------------------------------------ #
      # Config
      # ------------------------------------------------------------------ #

      config = lib.mkMerge [

        (lib.mkIf (config.system.swap.method == "zram") {
          zramSwap.enable = true;
          zramSwap.algorithm = "zstd";
          systemd.oomd.enable = true;
          # Hibernate requires a real swap partition or file.
          # zram alone cannot hold the hibernation image.
          warnings = lib.optional config.system.swap.hibernate "system.swap: hibernate with zram is not supported. Use swapfile instead.";
        })

        (lib.mkIf (config.system.swap.method == "zswapfile") {
          swapDevices = [
            {
              device = "/var/lib/swapfile";
              size = config.system.swap.size * 1024; # mkSwap expects MiB
              options = [ "discard" ];
            }
          ];
          boot.kernelParams = [
            "zswap.enabled=1" # enable zswap compressed swap cache
            "zswap.compressor=lz4" # compression algorithm
            "zswap.max_pool_percent=25" # cap zswap at 25% of RAM
            "zswap.shrinker_enabled=1" # proactively shrink pool under memory pressure
          ];
        })

        # ---------------------------------------------------------------- #
        # Hibernate
        # ---------------------------------------------------------------- #

        (lib.mkIf (config.system.swap.hibernate && config.system.swap.method == "zswapfile") {
          boot.resumeDevice = "/var/lib/swapfile";
        })

        (lib.mkIf
          (
            config.system.swap.hibernate
            && config.system.swap.method == "zswapfile"
            && config.system.swap.device == "laptop"
          )
          {
            systemd.sleep.extraConfig = ''
              HibernateMode=platform shutdown
              HibernateDelaySec=30m
            '';
            services.logind.settings.Login.extraConfig = ''
              HandlePowerKey=hibernate
              HandleLidSwitch=hibernate
            '';
          }
        )
      ];

    };

}
