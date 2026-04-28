{ pkgs, ... }:

{
  # ------------------------------------------------------------------ #
  # Snapper — btrfs snapshots
  #
  # Snapshots dir needs special permissions before first use:
  #   sudo chmod 700 /home/.snapshots
  # ------------------------------------------------------------------ #
  environment.systemPackages = with pkgs; [ btrfs-assistant ];

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs.home = {
      SUBVOLUME = "/home";
      FSTYPE = "btrfs";
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = "12";
      TIMELINE_LIMIT_DAILY = "4";
      TIMELINE_LIMIT_WEEKLY = "3";
      TIMELINE_LIMIT_MONTHLY = "2";
      TIMELINE_LIMIT_YEARLY = "1";
    };
  };

  # ------------------------------------------------------------------ #
  # Btrfs autoscrub
  # ------------------------------------------------------------------ #
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/mnt/Barracuda"
    ];
  };

}
