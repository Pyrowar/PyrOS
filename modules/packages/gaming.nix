# TODO: hjem -> assets/dotfiles/mangohud/MangoHud.conf
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
        enable = lib.mkEnableOption "gaming base (gamemode, user group)" // {
          default = true;
        };
        steam = {
          enable = lib.mkEnableOption "Steam, ProtonPlus" // {
            default = true;
          };
          protontricks = lib.mkEnableOption "Protontricks" // {
            default = config.gaming.steam.enable; # default: true
          };
        };
        faugus = lib.mkEnableOption "Faugus Launcher" // {
          default = true;
        };
        recorder = lib.mkEnableOption "GPU Screen Recorder" // {
          default = true;
        };
        heroic = lib.mkEnableOption "Heroic Games Launcher (Epic/GOG)" // {
          default = true;
        };
        mangohud = lib.mkEnableOption "MangoHud, GOverlay, vulkan-tools" // {
          default = true;
        };
        gamescope = {
          enable = lib.mkEnableOption "Gamescope compositor"; # default: false
          capSysNice = lib.mkEnableOption "CAP_SYS_NICE" // {
            default = config.gaming.gamescope.enable; # default: true
          };
        };
        minecraft = lib.mkEnableOption "Prism Launcher for Minecraft"; # default: false
        lsfg = lib.mkEnableOption "Lossless Scaling Frame Generation"; # default: false
      };

      config = lib.mkIf config.gaming.enable {

        users.users.${config.system.user}.extraGroups = [ "gamemode" ];
        programs.gamemode.enable = true;

        programs.steam = lib.mkIf config.gaming.steam.enable {
          enable = true;
          remotePlay.openFirewall = true;
          protontricks.enable = config.gaming.steam.protontricks;
        };

        programs.gamescope = lib.mkIf config.gaming.gamescope.enable {
          enable = true;
          capSysNice = config.gaming.gamescope.capSysNice;
        };

        programs.gpu-screen-recorder.enable = lib.mkIf config.gaming.recorder true;

        environment.systemPackages =
          with pkgs;
          lib.flatten [
            (lib.optionals config.gaming.steam.enable [ protonplus ])
            (lib.optionals config.gaming.faugus [ faugus-launcher ])
            (lib.optionals config.gaming.heroic [ heroic ])
            (lib.optionals config.gaming.minecraft [ prismlauncher ])
            (lib.optionals config.gaming.recorder [ gpu-screen-recorder-gtk ])
            (lib.optionals config.gaming.mangohud [
              mangohud
              goverlay
              vulkan-tools
            ])
            (lib.optionals config.gaming.lsfg [
              lsfg-vk
              lsfg-vk-ui
            ])
          ];
      };
    };
}
