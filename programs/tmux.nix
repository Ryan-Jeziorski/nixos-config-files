{
  ...
}:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "Space";
    extraConfig = '' # Used for less common options, intelligently combines if defined in multiple places.
    '';
  };
}
