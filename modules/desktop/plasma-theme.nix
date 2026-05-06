# TODO: dendritic pattern, rethink hjem strategy
{ config, pkgs, ... }:

let
  user = config.system.user;
  wallpaper = ../assets/wallpapers/NixOS-default.jpg;
  cursor = ../assets/cursors/Win11OS;
in

{
  config = {

    environment.systemPackages = with pkgs; [ klassy ];
    environment.sessionVariables = {
      XCURSOR_THEME = "Win11OS";
      XCURSOR_SIZE = "32";
    };

    hjem.users.${user} = {
      directory = "/home/${user}";
      files.".local/share/wallpapers/NixOS-default.jpg" = {
        clobber = false;
        source = wallpaper;
      };
      files.".local/share/icons/Win11OS" = {
        clobber = false;
        source = cursor;
      };
      files.".local/share/konsole/Ghostty.profile" = {
        clobber = false;
        source = ../assets/themes/konsole/Ghostty.profile;
      };
      files.".local/share/konsole/Ghostty.colorscheme" = {
        clobber = false;
        source = ../assets/themes/konsole/Ghostty.colorscheme;
      };
      files.".config/konsolerc" = {
        clobber = false;
        text = ''
          [Desktop Entry]
          DefaultProfile=Ghostty Default Theme.profile
        '';
      };
    };
  };
}
