{ ... }:
{
  flake.nixosModules.core =
    { config, lib, ... }:
    {
      options.system.user = lib.mkOption {
        type = lib.types.str;
        description = "Primary user account name.";
      };
      options.system.description = lib.mkOption {
        type = lib.types.str;
        description = "Displayed name and surname.";
      };
      options.system.maintenance = lib.mkOption {
        type = lib.types.enum [
          "automatic"
          "manual"
        ];
        default = "automatic";
        description = "Whether to automatically run nix gc and optimise or leave it to the user.";
      };

      config = {

        # ------------------------------------------------------------------ #
        # Nix
        # ------------------------------------------------------------------ #

        nixpkgs.config.allowUnfree = true;
        # since we are using flakes
        # sudo nix-channel --remove nixos nixos-hardware
        # we also remove ~/.nix-defexpr and /root/.nix-defexpr
        nix.channel.enable = false;
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        nix.gc = lib.mkIf (config.system.maintenance == "automatic") {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };

        nix.optimise = lib.mkIf (config.system.maintenance == "automatic") {
          automatic = true;
          dates = [ "weekly" ];
        };

        # ------------------------------------------------------------------ #
        # User
        # ------------------------------------------------------------------ #

        users.users.${config.system.user} = {
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
    };

}
