{
  flake.nixosModule.devtools =
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
        nixd
        nixfmt
        bash-language-server
        vscode-json-languageserver
        marksman
        sops
        age
        ghostty
        zed-editor
      ];
    };
}
