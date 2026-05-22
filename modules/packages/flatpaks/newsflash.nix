{
  flake.nixosModules.newsflash =
    { ... }:
    {
      services.flatpak.packages = [
        {
          appId = "io.gitlab.news_flash.NewsFlash";
          origin = "flathub";
        }
      ];

    };
}
