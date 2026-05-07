{
  flake.nixosModules.core =
    { config, lib, ... }:
    {

      # ------------------------------------------------------------------ #
      # Nix
      # ------------------------------------------------------------------ #

      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      nix.optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      # ------------------------------------------------------------------ #
      # User
      # ------------------------------------------------------------------ #

      options.system.user = lib.mkOption {
        type = lib.types.str;
        description = "Primary user account name.";
      };
      options.system.description = lib.mkOption {
        type = lib.types.str;
        description = "Displayed name and surname.";
      };

      config.users.users.${config.system.user} = {
        isNormalUser = true;
        description = config.system.description;
        extraGroups = [
          "wheel"
          "input"
          "uinput"
        ];
      };

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
      # System stuff
      # ------------------------------------------------------------------ #

      powerManagement.enable = true;
      security.rtkit.enable = true;

      boot.initrd.systemd.enable = true;
      boot.initrd.kernelModules = [ "lz4" ];

      # ------------------------------------------------------------------ #
      # DO NOT CHANGE!
      # ------------------------------------------------------------------ #

      system.stateVersion = "25.11"; # Did you read the comment?
    };
}
