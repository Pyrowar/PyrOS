{
  flake.nixosModules.gnome-dotfiles =
    { config, ... }:
    let
      user = config.system.user;

      # Gnome Text Editor
      gteStylesDir = ../../assets/dotfiles/gnome/gnome-text-editor;
      gteStyles = [
        "ghostty-default.xml"
        "kanagawa-dragon.xml"
        "kanagawa-lotus.xml"
        "kanagawa-wave.xml"
      ];

      # Cursors and icons
      iconsDir = ../../assets/dotfiles/gnome/icons;
      cursorsDir = ../../assets/dotfiles/gnome/cursors;
      icons = [
        "Adwaita-Blue-Default"
        "Adwaita-Brown"
        "Adwaita-Green"
        "Adwaita-Orange"
        "Adwaita-Pink"
        "Adwaita-Purple"
        "Adwaita-Red"
        "Adwaita-Slate"
        "Adwaita-Teal"
        "Adwaita-Yellow"
      ];
      cursors = [
        "Remus-Black"
        "Remus-Dark"
        "Remus-White"
        "Win11OS"
      ];
      mkEntries =
        dir: names:
        builtins.listToAttrs (
          map (name: {
            name = ".local/share/icons/${name}";
            value = {
              clobber = false;
              source = dir + "/${name}";
            };
          }) names
        );

    in
    {
      hjem.users.${user} = {
        files =
          # Gnome Text Editor themes
          builtins.listToAttrs (
            map (name: {
              name = ".local/share/gtksourceview-5/styles/${name}";
              value = {
                clobber = false;
                source = gteStylesDir + "/${name}";
              };
            }) gteStyles
          )
          # Cursors and icons
          // mkEntries iconsDir icons
          // mkEntries cursorsDir cursors
          # Gnome shell theme
          // {
            ".config/gtk-3.0/gtk.css".source =
              ../../assets/dotfiles/gnome/gnome-shell/color-buttons-on-hover/gtk-3.0/gtk.css;
            ".config/gtk-4.0/gtk.css".source =
              ../../assets/dotfiles/gnome/gnome-shell/color-buttons-on-hover/gtk-4.0/gtk.css;
          };
      };

      # Flatpak follows gnome shell theme
      services.flatpak.overrides.global = {
        Context = {
          filesystems = [
            "xdg-config/gtk-3.0:rw"
            "xdg-config/gtk-4.0:rw"
          ];
        };
      };

    };
}
