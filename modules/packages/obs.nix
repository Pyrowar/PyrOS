{
  flake.nixosModules.obs =
    { config, pkgs, ... }:
    {
      # For virtual camera support, v4l2loopback kernel module is required.
      # Add it to boot.initrd.kernelModules or boot.kernelModules.
      programs.obs-studio = {
        enable = true;
        package = pkgs.obs-studio.override {
          cudaSupport = config.hardware.nvidia.cuda; # NVIDIA hardware acceleration
        };
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs # Wayland screen capture
          obs-pipewire-audio-capture # PipeWire audio source
          obs-vkcapture # Vulkan game capture — run games with: obs-gamecapture %command%
        ];
      };
      environment.systemPackages = with pkgs; [ ffmpeg ];

      # Import OBS config
      hjem.users.${config.system.user} = {
        files.".config/obs-studio/basic" = {
          clobber = false;
          source = ../../assets/dotfiles/obs-studio/basic;
        };
      };

    };
}
