{ pkgs, ... }:

{
  # ------------------------------------------------------------------ #
  # AppImage support
  #
  # binfmt = true registers the AppImage magic bytes with the kernel so
  # AppImages can be executed directly without a wrapper command.
  #
  # Legacy support packages cover older AppImages that depend on:
  #   - icu / libxcrypt-legacy  — old glibc/crypt symbols
  #   - python312 + torch       — AI/ML AppImages
  # ------------------------------------------------------------------ #
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        icu
        libxcrypt-legacy
        python312
        python312Packages.torch
      ];
    };
  };

}
