# TODO: dendritic pattern
{ lib, ... }:

{
  # ---------------------------------------------------------------- #
  # NVIDIA PRIME — hybrid graphics (laptop)
  #
  # Sync mode keeps both GPUs active for best performance.
  # Offload mode lets the iGPU handle display and dGPU only activates
  # on demand — better battery life but slightly more setup.
  # Uncomment the mode you want and set the correct bus IDs.
  #
  # Find your bus IDs with:
  #   nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
  # Then convert from hex to decimal:
  #   e.g. 00:02.0 -> 0:2:0, 01:00.0 -> 1:0:0
  # ---------------------------------------------------------------- #
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # -------------------------------------------------------------- #
  # On-the-go — dGPU disabled for maximum battery life.
  # Selectable from the bootloader on startup.
  # -------------------------------------------------------------- #
  specialisation = {

    onTheGo.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
      # Completely power off the dGPU via PCI power management
      boot.extraModprobeConfig = ''
        options nvidia NVreg_DynamicPowerManagement=0x02
      '';
    };
  };
}
