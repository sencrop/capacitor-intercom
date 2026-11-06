{ pkgs, lib, ... }:
let
  devNode = (lib.importJSON ./package.json).devEngines.runtime.version;
  nodeMajor = lib.head (builtins.match "[^0-9]*([0-9]+).*" devNode);
in
{
  languages.javascript = {
    enable = true;
    # slim: no npm/npx/corepack in the PATH, pnpm is the only package manager
    package = pkgs."nodejs-slim_${nodeMajor}";
    # bootstrap only: switches to the devEngines.packageManager version
    pnpm.enable = true;
    lsp.enable = false;
  };
}
