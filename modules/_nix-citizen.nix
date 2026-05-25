{ inputs, ... }:
{
  # Optional - updates underlying without waiting for nix-citizen to update
  flake-file.inputs.nix-gaming = {
    url = "github:fufexan/nix-gaming";
  };

  flake-file.inputs.nix-citizen = {
    url = "github:LovingMelody/nix-citizen";
    inputs.nix-gaming.follows = "nix-gaming";
  };

  flake.nixosModules.nix-citizen =
    { pkgs, ... }:
    {
      nix.settings = {
        substituters = [
          "https://nix-citizen.cachix.org"
          "https://nix-gaming.cachix.org"
        ];
        trusted-public-keys = [
          "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };

      imports = [
        inputs.nix-citizen.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.lug-helper
        # inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.star-citizen
      ];

      # Manual setLimits for star-citizen package
      # boot.kernel.sysctl = {
      #   "vm.max_map_count" = 16777216;
      #   "fs.file-max" = 524288;
      # };

      programs.rsi-launcher = {
        enable = true;
        setLimits = true;
        # This option is enabled by default
        # Configures your system to meet some of the requirements to run star-citizen
        # Set `vm.max_map_count` default to `16777216` (sysctl(8))
        # Set `fs.file-max` default to `524288` (sysctl(8))
        # Also sets `security.pam.loginLimits` to increase hard (limits.conf(5))
      };
    };
}
