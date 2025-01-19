{
  pkgs,
  #config,
  ...
}:
#with config;
{
  #environment.systemPackages = with pkgs; [
  environment.systemPackages = [
    pkgs.kitty
  ];
}
