{
  flake.nixosModules.gnome-backgrounds =
    { config, pkgs, ... }:
    let
      user = config.system.user;
      homeDir = "/home/${user}";

      patchXml =
        file:
        pkgs.writeText (baseNameOf file) (
          builtins.replaceStrings [ "/home/pyro" "~/" ] [ homeDir "${homeDir}/" ] (builtins.readFile file)
        );
    in
    {
      hjem.users.${user}.files = {
        # defaults to clobber = false;

        # bluefin 01
        ".local/share/backgrounds/bluefin/01-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/01-bluefin.xml;

        ".local/share/backgrounds/bluefin/01-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/01-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/01-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/01-bluefin-night.jxl;

        ".local/share/gnome-background-properties/01-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/01-bluefin.xml;

        # bluefin 02
        ".local/share/backgrounds/bluefin/02-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/02-bluefin.xml;

        ".local/share/backgrounds/bluefin/02-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/02-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/02-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/02-bluefin-night.jxl;

        ".local/share/gnome-background-properties/02-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/02-bluefin.xml;

        # bluefin 03
        ".local/share/backgrounds/bluefin/03-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/03-bluefin.xml;

        ".local/share/backgrounds/bluefin/03-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/03-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/03-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/03-bluefin-night.jxl;

        ".local/share/gnome-background-properties/03-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/03-bluefin.xml;

        # bluefin 04
        ".local/share/backgrounds/bluefin/04-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/04-bluefin.xml;

        ".local/share/backgrounds/bluefin/04-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/04-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/04-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/04-bluefin-night.jxl;

        ".local/share/gnome-background-properties/04-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/04-bluefin.xml;

        # bluefin 05
        ".local/share/backgrounds/bluefin/05-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/05-bluefin.xml;

        ".local/share/backgrounds/bluefin/05-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/05-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/05-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/05-bluefin-night.jxl;

        ".local/share/gnome-background-properties/05-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/05-bluefin.xml;

        # bluefin 06
        ".local/share/backgrounds/bluefin/06-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/06-bluefin.xml;

        ".local/share/backgrounds/bluefin/06-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/06-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/06-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/06-bluefin-night.jxl;

        ".local/share/gnome-background-properties/06-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/06-bluefin.xml;

        # bluefin 07
        ".local/share/backgrounds/bluefin/07-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/07-bluefin.xml;

        ".local/share/backgrounds/bluefin/07-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/07-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/07-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/07-bluefin-night.jxl;

        ".local/share/gnome-background-properties/07-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/07-bluefin.xml;

        # bluefin 08
        ".local/share/backgrounds/bluefin/08-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/08-bluefin.xml;

        ".local/share/backgrounds/bluefin/08-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/08-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/08-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/08-bluefin-night.jxl;

        ".local/share/gnome-background-properties/08-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/08-bluefin.xml;

        # bluefin 09
        ".local/share/backgrounds/bluefin/09-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/09-bluefin.xml;

        ".local/share/backgrounds/bluefin/09-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/09-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/09-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/09-bluefin-night.jxl;

        ".local/share/gnome-background-properties/09-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/09-bluefin.xml;

        # bluefin 10
        ".local/share/backgrounds/bluefin/10-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/10-bluefin.xml;

        ".local/share/backgrounds/bluefin/10-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/10-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/10-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/10-bluefin-night.jxl;

        ".local/share/gnome-background-properties/10-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/10-bluefin.xml;

        # bluefin 12
        ".local/share/backgrounds/bluefin/12-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/backgrounds/bluefin/12-bluefin.xml;

        ".local/share/backgrounds/bluefin/12-bluefin-day.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/12-bluefin-day.jxl;

        ".local/share/backgrounds/bluefin/12-bluefin-night.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/12-bluefin-night.jxl;

        ".local/share/gnome-background-properties/12-bluefin.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/12-bluefin.xml;

        # bluefin - lazy
        ".local/share/backgrounds/bluefin/lazy.jxl".source =
          ../../assets/dotfiles/gnome/backgrounds/bluefin/lazy.jxl;

        ".local/share/gnome-background-properties/lazy.xml".source =
          patchXml ../../assets/dotfiles/gnome/gnome-background-properties/lazy.xml;

      };
    };

}
