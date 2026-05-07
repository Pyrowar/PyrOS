{ ... }:

{
  flake.nixosModules.core =
    { config, lib, ... }:
    let
      presets = {
        pl = {
          defaultLocale = "pl_PL.UTF-8";
          consoleKeyMap = "pl2";
          xkbLayout = "pl";
        };
        en = {
          defaultLocale = "en_GB.UTF-8";
          consoleKeyMap = "us";
          xkbLayout = "us";
        };
      };
      p = presets.${config.locale.preset};
    in
    {
      options.locale = {
        preset = lib.mkOption {
          type = lib.types.enum [
            "pl"
            "en"
          ];
          description = "Locale and keyboard preset to apply.";
        };
        timeZone = lib.mkOption {
          type = lib.types.str;
          description = "System timezone, e.g. \"Europe/Warsaw\".";
        };
      };

      config = {
        time.timeZone = config.locale.timeZone;
        console.keyMap = p.consoleKeyMap;
        i18n.defaultLocale = p.defaultLocale;
        i18n.extraLocaleSettings = {
          LC_ADDRESS = p.defaultLocale;
          LC_IDENTIFICATION = p.defaultLocale;
          LC_MEASUREMENT = p.defaultLocale;
          LC_MONETARY = p.defaultLocale;
          LC_NAME = p.defaultLocale;
          LC_NUMERIC = p.defaultLocale;
          LC_PAPER = p.defaultLocale;
          LC_TELEPHONE = p.defaultLocale;
          LC_TIME = p.defaultLocale;
        };
        services.xserver.xkb = {
          layout = p.xkbLayout;
          variant = "";
        };
      };
    };
}
