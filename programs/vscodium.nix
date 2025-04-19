{
  inputs,
  outputs,
  system,
  pkgs,
  extensions,
  vscode-with-extensions,
  vscodium,
  config,
  user,
  ...
}:
with config;
{
  users.users.${user} = {
    packages = with pkgs; [
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = with vscode-extensions.extensions.${system}; [
          extensions.vscode-marketplace.bbenoist.nix
          extensions.vscode-marketplace.rust-lang.rust-analyzer
          extensions.vscode-marketplace.karunamurti.tera
          extensions.vscode-marketplace.samuelcolvin.jinjahtml
          extensions.open-vsx.jeanp413.open-remote-ssh
          extensions.vscode-marketplace.vscodevim.vim
          extensions.vscode-marketplace.vspacecode.whichkey
          extensions.vscode-marketplace.vspacecode.vspacecode
        ];
      })
    ];
  };
}
