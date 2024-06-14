# This file defines overlays
{inputs, ...}: {
  vscode-extensions = final: _prev: {
    vscode-extensions = import inputs.nix-vscode-extensions;
  };
}
