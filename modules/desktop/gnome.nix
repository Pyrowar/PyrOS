# TODO: hjem -> assets/themes/gnome-text-editor
{
  flake.nixosModules.gnome =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.games.enable = false;
      services.gnome.core-developer-tools.enable = false;

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      gtk = {
        iconCache.enable = true;
      };

      environment.systemPackages = with pkgs; [
        gnome-tweaks
        gnome-extension-manager
        libsecret # for Vivaldi
        libjxl # for wallpapers
        resources
      ];

      # Packages to be excluded
      environment.gnome.excludePackages = with pkgs; [
        yelp # GNOME help
        epiphany # GNOME browser
        geary # GNOME email
        showtime # GNOME video player
        gnome-software
        gnome-tour
        gnome-user-docs
        gnome-music
        gnome-console
        gnome-contacts
        gnome-system-monitor
        gnome-connections
        gnome-maps

      ];

      # environment.sessionVariables = {
      #   XDG_DATA_DIRS = [ "$HOME/.local/share" ];
      # };

      hjem.users.${config.system.user} = {
        # Create file templates with hjem
        files."Templates/Empty Document.txt" = {
          clobber = false;
          text = "";
        };
        files."Templates/Markdown.md" = {
          clobber = false;
          text = "# Title\n";
        };
        files."Templates/Shell Script.sh" = {
          clobber = false;
          text = "#!/usr/bin/env bash\n\nset -eu\n";
        };
        files."Templates/Nix Expression.nix" = {
          clobber = false;
          text = "{ ... }:\n{\n\n}\n";
        };
      };

    };
}
