
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cameractrls-gtk4
  ];
}
