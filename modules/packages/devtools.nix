{
  flake.nixosModules.devtools =
    { pkgs, ... }:
    {
      programs.tmux.enable = true;
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
