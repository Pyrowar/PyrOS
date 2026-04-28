{ ... }:

{
  # ------------------------------------------------------------------ #
  # Barracuda — secondary HDD
  #
  # Automount and bind-mount XDG user dirs from the drive into ~/
  # ------------------------------------------------------------------ #
  fileSystems."/mnt/Barracuda" = {
    device = "/dev/disk/by-uuid/69d4fc22-af65-4100-a4d4-60e3afe8cd8e";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems = {
    "/home/pyro/Dokumenty" = {
      device = "/mnt/Barracuda/pyro/Dokumenty";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
    };
    "/home/pyro/Muzyka" = {
      device = "/mnt/Barracuda/pyro/Muzyka";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
    };
    "/home/pyro/Obrazy" = {
      device = "/mnt/Barracuda/pyro/Obrazy";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
    };
    "/home/pyro/Wideo" = {
      device = "/mnt/Barracuda/pyro/Wideo";
      fsType = "none";
      options = [
        "bind"
        "nofail"
      ];
    };
  };

}
