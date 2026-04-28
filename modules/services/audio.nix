{ ... }:

{
  # ------------------------------------------------------------------ #
  # PipeWire
  # ------------------------------------------------------------------ #
  services.pulseaudio.enable = false; # must be disabled when using PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # PulseAudio compatibility layer
    # If you want to use JACK applications, uncomment this:
    #jack.enable = true;

    # ---------------------------------------------------------------- #
    # Low-latency buffer
    # Use:
    #  pw-metadata -n settings
    # to check current config.
    # ---------------------------------------------------------------- #
    extraConfig.pipewire."92-low-latency" = {
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
