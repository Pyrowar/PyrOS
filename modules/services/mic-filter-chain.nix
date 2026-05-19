# TODO: Control default device volumes through ALSA with hotplugging, maybe systemd service?
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

        services.pipewire.extraLadspaPackages = [
          pkgs.rnnoise-plugin
          pkgs.lsp-plugins
        ];

        services.pipewire.extraConfig.pipewire."99-mic-filter-chain" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              # Don't take down entire pipewire on fail
              # To restart service do: systemctl --user restart pipewire
              flags = [ "nofail" ];
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
                      type = "ladspa";
                      name = "gate";
                      plugin = "lsp-plugins-ladspa";
                      # URI identification convention that points to the right plugin
                      label = "http://lsp-plug.in/plugins/ladspa/gate_mono";
                      control = {
                        "Attack (ms)" = 5.0;
                        "Release (ms)" = 250.0;
                        "Curve threshold (G)" = 0.01; # approx -40 dB
                        "Hold time (ms)" = 50.0;
                        "Reduction (G)" = 0.0; # full silence when gated
                        "Makeup gain (G)" = 1.0;
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
                      input = "gate:Input";
                    }
                    {
                      output = "gate:Output";
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
                  "node.passive" = true;
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

        # Assign descending priorities to listed devices
        services.pipewire.wireplumber.extraConfig."99-mic-priorities" = {
          "wireplumber.node.rules" = lib.imap0 (i: device: {
            matches = [ { "node.name" = device; } ];
            actions = {
              update-props = {
                "priority.session" = 1000 - (i * 10);
              };
            };
          }) cfg.devices;
        };

        # Suppress BT mics from ever becoming default
        services.pipewire.wireplumber.extraConfig."99-suppress-bt-mic" = {
          "wireplumber.node.rules" = [
            {
              matches = [ { "node.name" = "~bluez_input.*"; } ];
              actions = {
                update-props = {
                  "priority.session" = 0;
                };
              };
            }
          ];
        };

      };

    };
}
