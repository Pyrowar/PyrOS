{
  description = "Snowdrift";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      nixos-hardware,
      nix-flatpak,
      hjem,
      nix-index-database,
      sops-nix,
    }:
    let
      sharedModules = [
        nix-flatpak.nixosModules.nix-flatpak
        hjem.nixosModules.default
        nix-index-database.nixosModules.default
        { programs.nix-index-database.comma.enable = true; }
        sops-nix.nixosModules.sops

        # ------------------------------------------------------------------ #
        # Specify your hardware. DO NOT SKIP THIS STEP.
        # ------------------------------------------------------------------ #
        # Check github.com/nixos/nixos-hardware for your hardware.
        nixos-hardware.nixosModules.msi-b350-tomahawk

        # ------------------------------------------------------------------ #
        # System core. DO NOT REMOVE ANY OF THOSE.
        # ------------------------------------------------------------------ #
        ./base/core.nix
        ./base/user.nix
        ./base/locale.nix

        # ------------------------------------------------------------------ #
        # User configuration. DO NOT SKIP THIS STEP.
        # ------------------------------------------------------------------ #
        # Set the system username.
        { system.user = "pyro"; }

        # Set the user's full name or just stick to "Default User".
        { system.description = "Default User"; }

        # Set the locale/keyboard preset and timezone
        {
          locale.preset = "pl";
          locale.timeZone = "Europe/Warsaw";
        }

        # ------------------------------------------------------------------ #
        # Home configuration. User specific.
        # ------------------------------------------------------------------ #
        ./hosts/pyro/hjem.nix
        ./hosts/pyro/pyro.nix
        # Set of custom bash aliases for easier system maintenance
        ./modules/shell/bash.nix
        ./modules/packages/nixutils.nix

        # ------------------------------------------------------------------ #
        # Swap
        # ------------------------------------------------------------------ #
        # Set swap method, either:
        # zram without hibernate
        # { system.swap.method = "zram"; }

        # or:

        # zswapfile with hibernate, 16GB
        # {
        #    system.swap.method    = "zswapfile";
        #    system.swap.hibernate = true;
        #    system.swap.size      = 16;
        #    system.swap.device    = "laptop";
        # }

        # ------------------------------------------------------------------ #
        # Desktop Environment
        # ------------------------------------------------------------------ #
        # Enable KDE Plasma
        ./modules/desktop/plasma.nix
        ./modules/desktop/plasma-theme.nix
        # or:
        # Enable GNOME
        # ./modules/desktop/gnome.nix
        
        # Set Wayland screensharing portal (choose for your DE):
        { desktop.portal = "kde"; }

        # ------------------------------------------------------------------ #
        # Nvidia
        # ------------------------------------------------------------------ #
        # Enable Nvidia's GPU proprietary drivers
        ./modules/hardware/nvidia.nix
        # Additional support for hybrid systems (laptops)
        # /.modules/hardware/nvidia-prime.nix

        # Choose driver version: stable, production or beta
        # For 10 series GPUs and below use stable.
        { hardware.nvidia.driver = "beta"; }
        # Enable Nvidia's CUDA support in applications.
        { hardware.nvidia.cuda = true; }

        # ------------------------------------------------------------------ #
        # Packages
        # ------------------------------------------------------------------ #
        ./modules/packages/appimages.nix
        ./modules/packages/cli-apps.nix
        ./modules/packages/blender.nix
        ./modules/packages/devtools.nix
        ./modules/packages/firefox.nix
        ./modules/packages/flatpaks.nix
        ./modules/packages/fonts.nix
        ./modules/packages/gaming.nix
        ./modules/packages/krita.nix
        ./modules/packages/obs.nix
        ./modules/packages/office.nix
        ./modules/packages/signal.nix
        ./modules/packages/uno-calc.nix
        ./modules/packages/utils.nix
        ./modules/packages/wine.nix

        # ------------------------------------------------------------------ #
        # Services
        # ------------------------------------------------------------------ #
        ./modules/services/appimage.nix
        ./modules/services/audio.nix
        ./modules/services/bluetooth.nix
        ./modules/services/flatpak.nix
        ./modules/services/network.nix
        # ./modules/services/printer.nix
        ./modules/services/razer.nix
        # ./modules/services/remapkeys.nix
        # ./modules/services/swap.nix
        # ./modules/services/virtualisation.nix
        # ./modules/services/waydroid.nix

      ];

    in
    {

      # ------------------------------------------------------------------ #
      # NixOS unstable — primary channel
      # ------------------------------------------------------------------ #
      # To change the channel just:
      #   sudo nixos-rebuild switch --flake /etc/nixos#snowdrift
      # Each consecutive rebuild will automatically resolve to nixosConfigurations.snowdrift
      # until you change the channel again.
      nixosConfigurations.snowdrift = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          { networking.hostName = "snowdrift"; }
        ];
      };

      # ------------------------------------------------------------------ #
      # NixOS stable — fallback channel
      # ------------------------------------------------------------------ #
      # To change the channel just:
      #   sudo nixos-rebuild switch --flake /etc/nixos#permafrost
      # Each consecutive rebuild will automatically resolve to nixosConfigurations.permafrost
      # until you change the channel again.
      nixosConfigurations.permafrost = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          { networking.hostName = "permafrost"; }
        ];
      };

    };

}
