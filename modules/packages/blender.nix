{
  flake.nixosModules.blender =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [
        (pkgs.blender.override {
          cudaSupport = config.hardware.nvidia.cuda; # NVIDIA hardware acceleration
        })
      ];
    };
}
