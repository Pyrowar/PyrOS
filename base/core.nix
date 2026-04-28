{ ... }:

{
  # ------------------------------------------------------------------ #
  # Core system function
  # ------------------------------------------------------------------ #
  imports = [ ./hardware-configuration.nix ];

  # Enable power management framework and ensure suspend/hibernate scripts run properly via systemd.
  powerManagement.enable = true;

  # rtkit is a D-Bus service that safely grants real-time scheduling
  # priority to user processes that request it (required by PipeWire).
  security.rtkit.enable = true;

  # Enable flakes and new-style nix CLI
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # ------------------------------------------------------------------ #
  # Bootloader
  #
  # After committing changes to the bootloader, run:
  #   sudo nixos-rebuild boot --flake /etc/nixos --install-bootloader
  # ------------------------------------------------------------------ #
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    maxGenerations = 10;
  };

  # ------------------------------------------------------------------ #
  # initrd / kernel
  # ------------------------------------------------------------------ #
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [
    "lz4"
    "ntsync"
  ]; # lz4 for zswap, ntsync for Wine/games

  # ------------------------------------------------------------------ #
  # Garbage collection
  # ------------------------------------------------------------------ #
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Replace identical files in the store with hardlinks to save space
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # ------------------------------------------------------------------ #
  # DO NOT CHANGE!
  # ------------------------------------------------------------------ #
  system.stateVersion = "25.11";

}
