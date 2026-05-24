{
  flake.nixosModules.appimage =
    { pkgs, ... }:
    {
      # Older appimages require fuse2 to run
      # New appimages have fuse3 built in
      environment.systemPackages = [ pkgs.fuse2 ];

      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs =
            pkgs: with pkgs; [
              icu
              libxcrypt-legacy
              python312
              # TODO: Triton is not cached in upstream
              # python312Packages.torch
            ];
        };
      };
    };
}
