# TODO: separate each flatpak app into a different dendritic module
{ ... }:

{
  # ------------------------------------------------------------------ #
  # Flatpak remotes and packages
  #
  # To list all installed apps with their runtimes, run:
  #   flatpak list --app --columns=application,runtime
  # ------------------------------------------------------------------ #
  services.flatpak.packages = [
    {
      # Colobot
      appId = "info.colobot.Colobot";
      origin = "flathub";
    }
    {
      # Parabolic
      appId = "org.nickvision.tubeconverter";
      origin = "flathub";
    }
    {
      # Audacity
      appId = "org.audacityteam.Audacity";
      origin = "flathub";
    }
    {
      # Pinta
      appId = "com.github.PintaProject.Pinta";
      origin = "flathub";
    }
    {
      # LosslessCut
      appId = "no.mifi.losslesscut";
      origin = "flathub";
    }
    {
      # Upscayl
      appId = "org.upscayl.Upscayl";
      origin = "flathub";
    }
    {
      # Zettlr
      appId = "com.zettlr.Zettlr";
      origin = "flathub";
    }
    {
      # Foliate
      appId = "com.github.johnfactotum.Foliate";
      origin = "flathub";
    }
    {
      # Fooyin
      appId = "org.fooyin.fooyin";
      origin = "flathub";
    }
    {
      # Marknote
      appId = "org.kde.marknote";
      origin = "flathub";
    }
    {
      # EasyEffects
      appId = "com.github.wwmm.easyeffects";
      origin = "flathub";
    }
    {
      # qBittorrent
      appId = "org.qbittorrent.qBittorrent";
      origin = "flathub";
    }
    {
      # Vorta
      appId = "com.borgbase.Vorta";
      origin = "flathub";
    }
    {
      # Optiimage
      appId = "org.kde.optiimage";
      origin = "flathub";
    }
    {
      # Converseen
      appId = "net.fasterland.converseen";
      origin = "flathub";
    }
  ];
}
