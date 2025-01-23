{
  pkgs,
  ...
}:
{
    # Mullvad VPN
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
}
