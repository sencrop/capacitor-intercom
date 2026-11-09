{ pkgs, lib, ... }:
let
  devNode = (lib.importJSON ./package.json).devEngines.runtime.version;
  nodeMajor = lib.head (builtins.match "[^0-9]*([0-9]+).*" devNode);
in
{
  # No Nix compiler nor Apple SDK in the shell: xcodebuild reads CC, LD,
  # DEVELOPER_DIR… from the environment as build settings, and the iOS build
  # then fails on the Nix toolchain.
  stdenv = pkgs.stdenvNoCC;
  apple.sdk = null;

  packages = [ pkgs.google-java-format ];

  # same JDK as google-java-format's, so it adds nothing to download
  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk21;
  };

  languages.javascript = {
    enable = true;
    # slim: no npm/npx/corepack in the PATH, pnpm is the only package manager
    package = pkgs."nodejs-slim_${nodeMajor}";
    # bootstrap only: switches to the devEngines.packageManager version
    pnpm.enable = true;
    lsp.enable = false;
  };
}
