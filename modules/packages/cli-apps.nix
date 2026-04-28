{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kew
    btop
  ];

  programs.yazi.enable = true;

}
