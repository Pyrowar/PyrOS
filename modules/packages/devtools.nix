{
  flake.nixosModules.devtools =
    { config, pkgs, ... }:
    {
      # Import Zed theme
      hjem.users.${config.system.user} = {
        files.".config/zed/themes/Greentan.json" = {
          clobber = false;
          source = ../../assets/dotfiles/zed/Greentan.json;
        };
      };

      programs.tmux.enable = true;
      xdg.terminal-exec = {
        enable = true;
        settings = {
          GNOME = [ "ghostty" ];
          default = [ "ghostty" ];
        };

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
