# TODO: hjem -> assets/themes/mangohud/MangoHud.conf
{
  flake.nixosModules.gaming =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.gaming = {
        steam = lib.mkEnableOption "Steam, ProtonPlus, Protontricks";
        gamescope = lib.mkEnableOption "Gamescope compositor";
        faugus = lib.mkEnableOption "Faugus Launcher";
        recorder = lib.mkEnableOption "GPU Screen Recorder";
        minecraft = lib.mkEnableOption "Prism Launcher for Minecraft";
        heroic = lib.mkEnableOption "Heroic Games Launcher (Epic/GOG)";
        mangohud = lib.mkEnableOption "MangoHud and related tools";
        lsfg = lib.mkEnableOption "Lossless Scaling and GUI";
      };

      config = {
        users.users.${config.system.user}.extraGroups = [ "gamemode" ];
        programs.gamemode.enable = true;

        programs.gpu-screen-recorder.enable = lib.mkIf config.gaming.recorder true;

        programs.steam = lib.mkIf config.gaming.steam {
          enable = true;
          protontricks.enable = true;
          remotePlay.openFirewall = true;
        };

        programs.gamescope = lib.mkIf config.gaming.gamescope {
          enable = true;
          capSysNice = true; # set to false if you hit FHS bubblewrap issues.
        };

        environment.systemPackages =
          with pkgs;
          lib.optionals config.gaming.recorder [ gpu-screen-recorder-gtk ]
          ++ lib.optionals config.gaming.steam [ protonplus ]
          ++ lib.optionals config.gaming.faugus [ faugus-launcher ]
          ++ lib.optionals config.gaming.heroic [ heroic ]
          ++ lib.optionals config.gaming.minecraft [ prismlauncher ]
          ++ lib.optionals config.gaming.mangohud [
            mangohud
            goverlay
            vulkan-tools
          ]
          ++ lib.optionals config.gaming.lsfg [
            lsfg-vk
            lsfg-vk-ui
          ];
      };
    };
}
