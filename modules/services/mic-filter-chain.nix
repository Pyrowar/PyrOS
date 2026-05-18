{
  flake.nixosModules.mic-filter-chain =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.services.micFilterChain;
    in
    {
      options.services.micFilterChain = {
        enable = lib.mkEnableOption "PipeWire mic filter chain";

        devices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            List of ALSA source node names to use as input, in priority order.
            The first device is used as the default target.
            Use pw-top or wpctl status to find node names.
          '';
          example = [
            "alsa_input.pci-0000_2b_00.4.analog-stereo"
            "alsa_input.usb-SomeUSBMic-00.mono-fallback"
          ];
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.devices != [ ];
            message = "services.micFilterChain.devices must not be empty";
          }
        ];

        environment.systemPackages = [ pkgs.rnnoise-plugin ];

        services.pipewire.extraLadspaPackages = [ pkgs.rnnoise-plugin ];

        services.pipewire.extraConfig.pipewire."99-mic-filter-chain" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Processed Microphone";
                "media.name" = "Processed Microphone";
                "filter.graph" = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "librnnoise_ladspa";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 50;
                      };
                    }
                    {
                      type = "builtin";
                      name = "hp";
                      label = "bq_highpass";
                      control = {
                        "Freq" = 80.0;
                        "Q" = 0.7;
                      };
                    }
                    {
                      type = "builtin";
                      name = "eq1";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 220.0;
                        "Gain" = -2.0;
                        "Q" = 0.7;
                      };
                    }
                    {
                      type = "builtin";
                      name = "eq2";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 350.0;
                        "Gain" = -2.0;
                        "Q" = 1.2;
                      };
                    }
                    {
                      type = "builtin";
                      name = "eq3";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 3500.0;
                        "Gain" = 2.0;
                        "Q" = 0.9;
                      };
                    }
                    {
                      type = "builtin";
                      name = "eq4";
                      label = "bq_highshelf";
                      control = {
                        "Freq" = 10000.0;
                        "Gain" = 2.0;
                        "Q" = 0.7;
                      };
                    }
                  ];
                  links = [
                    {
                      output = "rnnoise:Output";
                      input = "hp:In";
                    }
                    {
                      output = "hp:Out";
                      input = "eq1:In";
                    }
                    {
                      output = "eq1:Out";
                      input = "eq2:In";
                    }
                    {
                      output = "eq2:Out";
                      input = "eq3:In";
                    }
                    {
                      output = "eq3:Out";
                      input = "eq4:In";
                    }
                  ];
                  inputs = [ "rnnoise:Input" ];
                  outputs = [ "eq4:Out" ];
                };
                "capture.props" = {
                  "node.name" = "effect_input.mic_processed";
                  "node.target" = lib.head cfg.devices;
                  "audio.channels" = 1;
                  "audio.position" = [ "MONO" ];
                };
                "playback.props" = {
                  "node.name" = "effect_output.mic_processed";
                  "media.class" = "Audio/Source";
                  "audio.channels" = 1;
                  "audio.position" = [ "MONO" ];
                };
              };
            }
          ];
        };

        services.pipewire.wireplumber.extraConfig."99-default-mic" = {
          "wireplumber.node.rules" = [
            {
              matches = [ { "node.name" = "effect_output.mic_processed"; } ];
              actions = {
                update-props = {
                  "priority.session" = 1000;
                };
              };
            }
          ];
        };

      };

    };
}
