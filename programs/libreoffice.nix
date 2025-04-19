{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.libreoffice-qt
    pkgs.hunspell
    pkgs.hunspellDicts.uk_UA
    pkgs.hunspellDicts.th_TH
  ];
}
