{ ... }:

{
  imports = [
    ./hostmodules/btrfs.nix
    ./hostmodules/secureboot.nix
    ./hostmodules/storage.nix
    ./hostmodules/swap-partition.nix
    ./hostmodules/systemd.nix
  ];

}
