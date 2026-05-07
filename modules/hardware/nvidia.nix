{ ... }:
{
  flake.nixosModules.nvidia =
    { config, lib, ... }:
    {
      options.hardware.nvidia = {
        cuda = lib.mkEnableOption "CUDA support";
        driver = lib.mkOption {
          type = lib.types.enum [
            "stable"
            "production"
            "beta"
          ];
          default = "stable";
          description = "Driver version. For 10 series GPUs and below use stable.";
        };
      };

      config = {
        users.users.${config.system.user}.extraGroups = [
          "video"
          "render"
        ];

        # ---------------------------------------------------------------- #
        # Graphics / OpenGL
        # ---------------------------------------------------------------- #

        hardware.graphics.enable = true;
        hardware.graphics.enable32Bit = true;

        # ---------------------------------------------------------------- #
        # NVIDIA driver
        # ---------------------------------------------------------------- #

        services.xserver.videoDrivers = [ "nvidia" ];
        services.lact.enable = true; # Linux GPU Control Application
        hardware.nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true; # fixes sleep/suspend issues
          nvidiaSettings = true; # installs nvidia-settings GUI tool
          open = true;
          package = config.boot.kernelPackages.nvidiaPackages.${config.hardware.nvidia.driver};
        };

        # ---------------------------------------------------------------- #
        # CUDA
        # ---------------------------------------------------------------- #

        # Binary cache so CUDA packages don't have to be compiled locally
        nix.settings = lib.mkIf config.hardware.nvidia.cuda {
          substituters = [ "https://cache.nixos-cuda.org" ];
          trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          ];
        };

        # Disable shader cache cleanup — lets the cache grow unbounded rather
        # than hitting the default size cap and evicting entries.
        # To clear manually: rm -rf ~/.cache/nvidia/GLCache
        environment.sessionVariables = lib.mkIf config.hardware.nvidia.cuda {
          # __GL_SHADER_DISK_CACHE_SIZE = "10737418240"; # alternative: 10 GB cap in bytes
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
        };

      };

    };

}
