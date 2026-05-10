{
  flake.nixosModules.devtools =
    { pkgs, ... }:
    {
      programs.tmux.enable = true;
      xdg.terminal-exec = {
        enable = true;
        settings = {
          GNOME = [ "ghostty" ];
          default = [ "ghostty" ];
        };

        # Preserve terminfo under sudo
        # security.sudo.extraConfig = ''
        #   Defaults env_keep += "TERMINFO"
        # '';

      };
      environment.systemPackages = with pkgs; [
        statix
        nil
        nixd
        nixfmt
        bash-language-server
        package-version-server
        marksman
        ghostty
        zed-editor
      ];
    };
}
