# Wise old man timer to update my character
# once every hour
{
  pkgs,
  ...
}:
{
  systemd.timers."wom_updater" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
    };
  };
  systemd.services."wom_updater" = {
    path = [ pkgs.curl ];
    script = ''
      set -xu
      curl -X POST https://api.wiseoldman.net/v2/players/eganwo \
        -H "Content-Type: application/json"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "ryan";
    };
  };
}
