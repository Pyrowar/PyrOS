# TEST: Try it on dragon
{
  # ---------------------------------------------------------------- #
  # NVIDIA PRIME — hybrid graphics (laptop)
  #
  # Sync mode keeps both GPUs active for best performance.
  # Offload mode lets the iGPU handle display and dGPU only activates
  # on demand — better battery life but slightly more setup.
  # 
  # Find your bus IDs with:
  #   nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
  # Then convert from hex to decimal:
  #   e.g. 00:02.0 -> 0:2:0, 01:00.0 -> 1:0:0
  # ---------------------------------------------------------------- #

  flake.nixosModules.nvidia-prime =
    { lib, config, ... }:
    {
      options.hardware.nvidia.prime = {
        mode = lib.mkOption {
          type = lib.types.enum [
            "sync"
            "offload"
          ];
          default = "offload";
          description = "PRIME mode. sync keeps both GPUs active, offload activates dGPU on demand.";
        };
        onTheGo = lib.mkEnableOption "on-the-go specialisation — dGPU disabled for maximum battery life";
        intelBusId = lib.mkOption {
          type = lib.types.str;
          description = "PCI bus ID of the Intel iGPU.";
          example = "PCI:0:2:0";
        };
        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          description = "PCI bus ID of the NVIDIA dGPU.";
          example = "PCI:1:0:0";
        };
      };
      config = {
        hardware.nvidia.prime = {
          sync.enable = config.hardware.nvidia.prime.mode == "sync";
          offload.enable = config.hardware.nvidia.prime.mode == "offload";
          offload.enableOffloadCmd = config.hardware.nvidia.prime.mode == "offload";
          intelBusId = config.hardware.nvidia.prime.intelBusId;
          nvidiaBusId = config.hardware.nvidia.prime.nvidiaBusId;
        };

        # -------------------------------------------------------------- #
        # On-the-go — dGPU disabled for maximum battery life.
        # Selectable from the bootloader on startup.
        # -------------------------------------------------------------- #
        
        specialisation = lib.mkIf config.hardware.nvidia.prime.onTheGo {
          onTheGo.configuration = {
            system.nixos.tags = [ "on-the-go" ];
            hardware.nvidia.prime.sync.enable = lib.mkForce false;
            hardware.nvidia.prime.offload.enable = lib.mkForce false;
            hardware.nvidia.prime.offload.enableOffloadCmd = lib.mkForce false;
            hardware.nvidia.powerManagement.enable = lib.mkForce false;
            services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
            boot.extraModprobeConfig = ''
              options nvidia NVreg_DynamicPowerManagement=0x02
            '';
          };
        };

      };

    };
}
