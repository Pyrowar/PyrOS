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

      environment.systemPackages = with pkgs; [
        nixos-install-tools
        nix-output-monitor
        nvd
        micro
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
