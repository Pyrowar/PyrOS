{ pkgs, config, ... }:

{
  # ------------------------------------------------------------------ #
  # User groups — handled by list merging
  # ------------------------------------------------------------------ #
  users.users.${config.system.user}.extraGroups = [
    "gamemode"
    "input"
    "uinput"
  ];

  programs.gamemode.enable = true;
  # Remember to use .mkv instead of .mp4 in GPU Screen recorder.
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
    # capSysNice = true; # disable if you hit FHS bubblewrap issues.
  };
  # ------------------------------------------------------------------ #
  # Gaming packages
  # ------------------------------------------------------------------ #
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk # GUI for GPU Screen recorder
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
}
