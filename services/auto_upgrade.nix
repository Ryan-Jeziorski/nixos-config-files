# Note this whole file needs a rework if I want it to be
# reusable on other hosts. Currently the value of ashyn.local is
# hardcoded
{
  pkgs,
  ...
}:
{
  systemd.services."auto-upgrade" = {
    path = [ pkgs.git ];
    script = ''
      set -xu
      # Variable initalization
      user="ryan"

      echo "Start of auto-upgrade script\n"

      # Update flake, run command as owner of the 
      /run/wrappers/bin/sudo -u $user /run/current-system/sw/bin/nix flake update --commit-lock-file --flake /home/ryan/nixos-config-files/
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
  systemd.timers."auto-upgrade" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 11:37:00 CST";
      #OnCalendar = "*-*-* 04:00:00 CST";
      Unit = "auto-upgrade.service";
    };
  };
}
