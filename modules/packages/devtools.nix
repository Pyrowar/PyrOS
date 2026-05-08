{
  flake.nixosModules.devtools =
    { pkgs, ... }:
    {
      programs.tmux.enable = true;
      programs.git = {
        enable = true;
        config = {
          user.name = "Kajetan Ziółkowski";
          user.email = "kajetan.ziolkowsky@gmail.com";
          init.defaultBranch = "main";
          pull.rebase = false;
          push.autoSetupRemote = true;
          core.editor = "micro";
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
