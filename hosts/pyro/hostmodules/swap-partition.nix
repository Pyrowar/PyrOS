# TODO: move to hardware-configuration.nix
{ ... }:

{
  # ------------------------------------------------------------------ #
  # Swap device
  #
  # Check device UUID with
  #   sudo blkid
  # ------------------------------------------------------------------ #
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/2bcd4beb-e129-4b9f-921a-8d8187f6c408";
      options = [ "discard" ]; # equivalent to swapon --discard
    }
  ];

  boot.kernelParams = [
    "zswap.enabled=1" # enable zswap compressed swap cache
    "zswap.compressor=lz4" # compression algorithm
    "zswap.max_pool_percent=25" # cap zswap at 25% of RAM
    "zswap.shrinker_enabled=1" # proactively shrink pool under memory pressure
  ];

}
