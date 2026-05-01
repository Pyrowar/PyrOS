{ ... }:

{
  # services.pipewire.systemWide = true; # Doesn't work with EasyEffects
  # systemd.services.wireplumber.serviceConfig.SupplementaryGroups = [ "pipewire" ];
  # users.users.${config.system.user}.extraGroups = [ "pipewire" ];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."98-steady-audio" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 1024;
      };
    };

    # ---------------------------------------------------------------- #
    # WirePlumber rules
    # ---------------------------------------------------------------- #
    # Disable the annoying bluetooth headset microphone autoswitch.
    # Forces headsets to stay on the A2DP (high-quality audio) profile
    # instead of dropping to HSP/HFP when a mic is detected.
    wireplumber.extraConfig."51-disable-bluetooth-autoswitch" = {
      "monitor.bluez.rules" = [
        {
          matches = [ { "device.name" = "~bluez_card.*"; } ];
          actions.update-props = {
            "bluez5.auto-connect" = [ "a2dp_sink" ];
          };
        }
      ];
    };
  };

}
