{ config, ... }:

let
  user = config.system.user;
in

{
  config = {

    services.flatpak.packages = [
      {
        appId = "uno.platform.uno-calculator";
        origin = "flathub";
      }
    ];

    hjem.users.${user} = {
      directory = "/home/${user}";

      files.".local/share/applications/uno.platform.uno-calculator.desktop" = {
        clobber = false;
        text = ''
          [Desktop Entry]
          Type=Application
          Version=1.0
          Name=Uno Calculator
          Comment=The Uno Calculator
          Exec=flatpak run --branch=stable --arch=x86_64 --command=start-uno-calculator.sh uno.platform.uno-calculator
          Icon=uno.platform.uno-calculator
          Terminal=false
          X-Flatpak=uno.platform.uno-calculator
          Categories=Utility;Calculator;
        '';
      };
    };
  };

}
