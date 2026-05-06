{
  flake.nixosModules.keyremap =
    { ... }:
    {
      services.input-remapper = {
        enable = true;
        enableUdevRules = false; # auto-loads mappings when a device connects, but can cause hangs
      };
    };
}
