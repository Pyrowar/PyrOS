{ ... }:

{
  services.input-remapper = {
    enable = true;
    enableUdevRules = false;
    # auto-loads mappings when a device connects, but can cause hangs
    # disable if you run into issues.
  };
}
