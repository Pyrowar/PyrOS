{ inputs, ... }:
{
  # Optional - updates underlying without waiting for nix-citizen to update
  # flake-file.inputs.nix-gaming = {
  #   url = "github:fufexan/nix-gaming";
  # };

  flake-file.inputs.nix-citizen = {
    url = "github:LovingMelody/nix-citizen";
    # inputs.nix-gaming.follows = "nix-gaming";
  };

  flake.nixosModules.nix-citizen =
    { pkgs, ... }:
    {
      nix.settings = {
        substituters = [ "https://nix-citizen.cachix.org" ];
        trusted-public-keys = [ "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" ];
      };

      imports = [
        inputs.nix-citizen.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.lug-helper
      ];

      programs.rsi-launcher = {
        enable = true;
        # umu.enable = true;

        # preCommands = ''
        #   export DXVK_HUD=compiler;
        #   export MANGO_HUD=1;
        # '';

        # This option is enabled by default
        # Configures your system to meet some of the requirements to run star-citizen
        # Set `vm.max_map_count` default to `16777216` (sysctl(8))
        # Set `fs.file-max` default to `524288` (sysctl(8))
        # Also sets `security.pam.loginLimits` to increase hard (limits.conf(5))
        setLimits = true;
      };
    };
}
