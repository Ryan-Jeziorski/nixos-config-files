{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.kitty
  ];
}
