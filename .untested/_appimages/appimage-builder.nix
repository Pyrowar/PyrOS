# Requires decoupling from appimages its building
# Would like to try to create a tar-builder too
{ pkgs, ... }:
let
  src = ./samrewritten-adw.AppImage;

  extracted = pkgs.appimageTools.extract {
    pname = "samrewritten";
    version = "1.0";
    inherit src;
  };

  samrewritten = pkgs.appimageTools.wrapType2 {
    pname = "samrewritten";
    version = "1.0";
    inherit src;
    extraPkgs =
      pkgs: with pkgs; [
        libadwaita
        gtk4
        pango
        gdk-pixbuf
        graphene
        glib
      ];
  };

  samrewritten-desktop = pkgs.makeDesktopItem {
    name = "samrewritten";
    desktopName = "SAM Rewritten";
    exec = "${samrewritten}/bin/samrewritten";
    icon = "${extracted}/samrewritten.png";
    categories = [ "Game" ];
    comment = "Steam Achievement Manager";
  };

in
{
  environment.systemPackages = [
    samrewritten
    samrewritten-desktop
  ];
}
