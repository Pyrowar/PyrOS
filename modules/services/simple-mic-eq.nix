{
  flake.nixosModules.simple-mic-eq =
    { pkgs, ... }:
    {
      # TODO: Virtual source should automatically follow whatever the default input device is
      environment.systemPackages = with pkgs; [
        ladspaPlugins # for the limiter
        deepfilternet # DeepFilterNet noise suppression
      ];

    };
}
