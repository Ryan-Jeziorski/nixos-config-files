{
  pkgs,
  #config,
  ...
}:
#with config;
{
  #environment.systemPackages = with pkgs; [
  environment.systemPackages = [
    pkgs.tmux
    pkgs.alacritty
    pkgs.kitty
  ];
}
