{ pkgs, ... }:

{
  # sudo chown -R (username):users /etc/nixos
  programs.tmux.enable = true;
  programs.ssh.startAgent = true;
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
    # mkdir -p ~/.config/sops/age
    # age-keygen -o ~/.config/sops/age/keys.txt
    # sops = {
    #   defaultSopsFile = ./secrets.yaml;
    #   defaultSopsFormat = "yaml";
    # };
    # age = {
    #   # Use your existing SSH key to derive the age key automatically
    #   sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    #   # Or point to an explicit age key file:
    #   # keyFile = "/var/lib/sops-nix/key.txt";
    #   generateKey = true;
    # };
    # secrets = {
    #   "github_token" = {};
    #   "some_password" = {};
    # };
    
  };
  environment.systemPackages = with pkgs; [
    sops
    age
    ghostty
    nil
    nixd
    nixfmt
    vscode-json-languageserver
    marksman
    bash-language-server
    zed-editor
  ];

}
