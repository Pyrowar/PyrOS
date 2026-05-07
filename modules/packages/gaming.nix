{
  flake.nixosModules.gaming =
    { pkgs, config, ... }:
    {
      users.users.${config.system.user}.extraGroups = [
        "gamemode"
      ];

      programs.gamemode.enable = true;
      programs.gpu-screen-recorder.enable = true;
      # ------------------------------------------------------------------ #
      # Steam
      # ------------------------------------------------------------------ #
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
      };

      programs.gamescope = {
        enable = true;
        capSysNice = false; # set to false if you hit FHS bubblewrap issues.
      };
      # ------------------------------------------------------------------ #
      # Gaming packages
      # ------------------------------------------------------------------ #
      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
        protonplus
        heroic
        faugus-launcher
        prismlauncher
        mangohud
        goverlay
        vulkan-tools
        # vkbasalt
        # lsfg-vk # Lossless Scaling frame generation (requires owning it on Steam)
        # lsfg-vk-ui # Optional GUI configurator for lsfg-vk
      ];
    };
}
