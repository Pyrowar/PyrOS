{
  flake.nixModules.utils =
    { pkgs, ... }:
    {
      environment.sessionVariables = {
        SUDO_EDITOR = "micro";
        EDITOR = "micro";
        VISUAL = "micro";
      };

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        flags = [ "--cmd cd" ];
      };

      programs.bat.enable = true;
      programs.fzf.fuzzyCompletion = true;
      programs.yazi.enable = true;

      environment.systemPackages = with pkgs; [
        micro
        btop
        fzf
        unrar
        tree
        compsize
        pciutils
        fastfetch
        ffmpegthumbnailer
        unar
        poppler
        fd
      ];
    };
}
