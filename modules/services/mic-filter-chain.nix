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
          pkgs.deepfilternet
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
                      # Stage 1: RNNoise - fast lightweight neural noise suppressor.
                      # Runs first to clean up the signal before DeepFilterNet.
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "librnnoise_ladspa";
                      label = "noise_suppressor_mono";
                      control = {
                        # Voice Activity Detection threshold - signal below this
                        # is treated as silence and fully suppressed.
                        # Already handling two stages of noise suppression before Gate.
                        "VAD Threshold (%)" = 0; # enable-vad: false
                      };
                    }
                    {
                      # Stage 2: DeepFilterNet - neural noise suppressor that
                      # handles different artifacts than RNNoise (e.g. tonal noise,
                      # hum, complex backgrounds).
                      type = "ladspa";
                      name = "deepfilter";
                      plugin = "libdeep_filter_ladspa";
                      label = "deep_filter_mono";
                      control = {
                        # How much noise can be attenuated at most. 100 dB = uncapped,
                        # but can cause random speech dropouts via the LADSPA bridge.
                        # 20 dB = medium reduction, more transparent.
                        "Attenuation Limit (dB)" = 20.0;

                        # Signal below this level is not processed at all, the range is -15 to 35.
                        # -15 dB = process as much of the signal as possible.
                        "Min processing threshold (dB)" = -15.0;

                        # ERB (Equivalent Rectangular Bandwidth) bands processed up to this
                        # signal level. Controls the perceptual frequency analysis upper bound.
                        "Max ERB processing threshold (dB)" = 30.0;

                        # Deep Filtering applied up to this signal level. DF is the neural
                        # network part that handles complex noise patterns.
                        "Max DF processing threshold (dB)" = 20.0;

                        # Extra buffering frames before processing starts. 0 = minimum latency.
                        "Min Processing Buffer (frames)" = 0;

                        # Post-filter smoothing - reduces musical noise artifacts at the cost
                        # of slight smearing. 0.02 = light smoothing.
                        "Post Filter Beta" = 0.02;
                      };
                    }
                    {
                      # Stage 3: Gate - silences the mic when no speech is detected,
                      # eliminating residual noise that slips past the neural suppressors.
                      type = "ladspa";
                      name = "gate";
                      plugin = "lsp-plugins-ladspa";
                      # URI identification convention that points to the right plugin
                      label = "http://lsp-plug.in/plugins/ladspa/gate_mono";
                      control = {
                        # How fast the gate opens when signal crosses threshold.
                        "Attack (ms)" = 5.0;

                        # How fast the gate closes after signal drops below threshold.
                        "Release (ms)" = 250.0;

                        # Gate opens when signal exceeds this level.
                        # All (G) values are linear gain ratios: G = 10^(dB/20)
                        "Curve threshold (G)" = 0.00316; # -50 dB

                        # Width of the transition zone below the threshold where
                        # the gate is partially open (soft knee).
                        "Curve zone size (G)" = 0.794; # -2 dB

                        # Hysteresis prevents the gate from chattering (rapidly
                        # opening and closing) when the signal hovers near threshold.
                        # The gate only closes once the signal drops below a lower
                        # threshold than the one that opened it.
                        "Hysteresis" = 1.0; # enabled
                        "Hysteresis threshold (G)" = 0.708; # -3 dB below open threshold
                        "Hysteresis zone size (G)" = 0.891; # -1 dB transition zone

                        # Gain applied when gate is closed. -12 dB = not fully silent,
                        # avoids abrupt cut-offs while still suppressing background noise.
                        "Reduction (G)" = 0.251; # -12 dB

                        # Compensate for slight level drop caused by gating.
                        "Makeup gain (G)" = 1.122; # +1 dB
                      };
                    }
                    {
                      # Stage 4a: High-pass filter - rolls off low-frequency rumble
                      # (desk vibration, HVAC, proximity effect) below 80 Hz.
                      type = "builtin";
                      name = "hp";
                      label = "bq_highpass";
                      control = {
                        "Freq" = 80.0;
                        "Q" = 0.7; # Butterworth (maximally flat, no resonance peak)
                      };
                    }
                    {
                      # Stage 4b: Bell cut at 220 Hz - reduces boxy/nasal coloration
                      # common in small rooms and many microphones.
                      type = "builtin";
                      name = "eq1";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 220.0;
                        "Gain" = -2.0; # dB
                        "Q" = 0.7; # Wide cut
                      };
                    }
                    {
                      # Stage 4c: Bell cut at 350 Hz - reduces muddiness/warmth buildup.
                      type = "builtin";
                      name = "eq2";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 350.0;
                        "Gain" = -2.0; # dB
                        "Q" = 1.2; # Moderate width
                      };
                    }
                    {
                      # Stage 4d: Bell boost at 3500 Hz - adds presence and clarity,
                      # helping the voice cut through in calls and recordings.
                      type = "builtin";
                      name = "eq3";
                      label = "bq_peaking";
                      control = {
                        "Freq" = 3500.0;
                        "Gain" = 2.0; # dB
                        "Q" = 0.9; # Moderate width
                      };
                    }
                    {
                      # Stage 4e: High shelf boost at 10 kHz - adds air and brightness,
                      # giving the voice an open, professional quality.
                      type = "builtin";
                      name = "eq4";
                      label = "bq_highshelf";
                      control = {
                        "Freq" = 10000.0;
                        "Gain" = 2.0; # dB
                        "Q" = 0.7; # Gentle shelf slope
                      };
                    }
                    {
                      # Stage 5: Compressor - evens out volume differences between
                      # loud and quiet speech (e.g. when leaning closer/further from mic).
                      type = "ladspa";
                      name = "compressor";
                      plugin = "lsp-plugins-ladspa";
                      label = "http://lsp-plug.in/plugins/ladspa/compressor_mono";
                      control = {
                        # Reduce peaks.
                        "Compression mode" = 0; # 0 = Downward

                        # Compression kicks in above this level.
                        "Attack threshold (G)" = 0.126; # -18 dB

                        # How fast compression engages after threshold is crossed.
                        "Attack time (ms)" = 15.0;

                        # Compression starts releasing below this level.
                        "Release threshold (G)" = 0.01; # -40 dB

                        # How fast compression disengages after signal drops.
                        "Release time (ms)" = 200.0;

                        # Gain reduction ratio above threshold: 3:1 = moderate compression.
                        "Ratio" = 3.0;

                        # Softens the transition into compression around the threshold.
                        "Knee (G)" = 0.501; # -6 dB

                        # Compensate for gain reduction caused by compression.
                        "Makeup gain (G)" = 1.413; # +3 dB
                      };
                    }
                    {
                      # Stage 5b: De-esser - sidechain compressor that detects harshness in
                      # the 4–8 kHz sibilance range and compresses the full signal when
                      # it exceeds the threshold.
                      type = "ladspa";
                      name = "deesser";
                      plugin = "lsp-plugins-ladspa";
                      label = "http://lsp-plug.in/plugins/ladspa/sc_compressor_mono";
                      control = {
                        "Sidechain type" = 0; # 0 = External (uses sidechain audio port)
                        "Sidechain mode" = 2; # 1 = Peak, 2 = RMS detection
                        "High-pass filter mode" = 1; # 1 = 12 dB/oct - focus sidechain on highs
                        "High-pass filter frequency (Hz)" = 4000.0; # sibilance starts here
                        "Low-pass filter mode" = 1; # 1 = 12 dB/oct
                        "Low-pass filter frequency (Hz)" = 8000.0; # sibilance ends here
                        "Compression mode" = 0; # Downward
                        "Attack threshold (G)" = 0.178; # -15 dB
                        "Attack time (ms)" = 5.0;
                        "Release time (ms)" = 100.0;
                        "Ratio" = 2.0;
                        "Knee (G)" = 0.501; # -6 dB soft knee
                        "Makeup gain (G)" = 1.0; # no makeup, avoid boosting sibilance back
                      };
                    }
                    {
                      # Stage 6: Limiter - hard ceiling to prevent clipping on
                      # sudden loud sounds (shouts, plosives, desk knocks).
                      type = "ladspa";
                      name = "limiter";
                      plugin = "lsp-plugins-ladspa";
                      label = "http://lsp-plug.in/plugins/ladspa/limiter_mono";
                      control = {
                        # No signal passes above this level.
                        "Threshold (G)" = 0.841; # -1.5 dB

                        # How fast the limiter engages.
                        "Attack time (ms)" = 2.0;

                        # How fast the limiter releases.
                        "Release time (ms)" = 5.0;

                        # Looks ahead in the buffer to catch transients before they clip.
                        "Lookahead (ms)" = 2.0;

                        # Limiting algorithm: Herm Wide = smooth hermite interpolation,
                        # good balance of transparency and transient control.
                        # 0=Classic 1=Herm Thin 2=Herm Wide 3=Herm Tail 4=Herm Duck ...
                        "Operating mode" = 2; # Herm Wide

                        # ALR (Automatic Level Regulation) adjusts threshold dynamically
                        # - disabled to keep a fixed, predictable ceiling.
                        "Automatic level regulation" = 0; # off
                        "Oversampling" = 0; # None - minimize latency

                        # Dithering reduces quantization distortion when outputting
                        # to a fixed bit depth. Relevant for livestreaming.
                        # 0=None 6=16bit 7=23bit 8=24bit
                        "Dithering" = 6;

                        # Gain boost pre-amplifies input before limiting - off to
                        # avoid unintended level changes.
                        "Gain boost" = 0; # off
                      };
                    }
                  ];
                  links = [
                    {
                      output = "rnnoise:Output";
                      input = "deepfilter:Audio In";
                    }
                    {
                      output = "deepfilter:Audio Out";
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
                    {
                      output = "eq4:Out";
                      input = "compressor:Input";
                    }
                    {
                      output = "compressor:Output";
                      input = "deesser:Input";
                    }
                    {
                      output = "compressor:Output";
                      input = "deesser:Sidechain input";
                    }
                    {
                      output = "deesser:Output";
                      input = "limiter:Input";
                    }
                  ];
                  inputs = [ "rnnoise:Input" ];
                  outputs = [ "limiter:Output" ];
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
