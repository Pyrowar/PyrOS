# TODO: hjem -> assets/dotfiles/zed/Greentan.json
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
