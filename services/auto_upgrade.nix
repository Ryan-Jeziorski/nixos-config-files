# Note this whole file needs a rework if I want it to be
# reusable on other hosts. Currently the value of ashyn.local is
# hardcoded
{
  pkgs,
  ...
}:
{
  systemd.services."hello-world" = {
    path = [ pkgs.git ];
    script = ''
      set -xu
      echo "hello world"
      /run/wrappers/bin/sudo -u ryan /run/current-system/sw/bin/nix flake update --commit-lock-file --flake /home/ryan/nixos-config-files/
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    startAt = "*:0/5";
  };
}
