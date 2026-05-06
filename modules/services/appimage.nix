{
  flake.nixosModules.appimage =
    { pkgs, ... }:
    {
      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs =
            pkgs: with pkgs; [
              icu
              libxcrypt-legacy
              python312
              python312Packages.torch
            ];
        };
      };
    };
}
