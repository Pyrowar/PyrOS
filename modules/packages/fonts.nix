{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    corefonts # Arial, Times New Roman, Courier New…
    vista-fonts # Calibri, Cambria, Consolas…
    fira # Fira Sans, Fira Mono
    nerd-fonts.jetbrains-mono # Jetbrains Mono
  ];
}
