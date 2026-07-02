{
  inputs,
  lib,
  pkgs,
  self,
  userConfig,
  ...
}:
with lib; {
  imports = [
    ../packages.nix
    ../secrets.nix
  ];

  environment.etc."fish/config.fish".text = mkBefore ''
    # set -gx PNPM_HOME "/Users/yoda/.local/share/pnpm"
    # set -gx PATH "$PNPM_HOME" $PATH
  '';

  environment.shells = [
    pkgs.zsh
    pkgs.fish
  ];

  environment.variables = {
    ASTRO_TELEMETRY_DISABLED = "1";
    HOMEBREW_INTERNAL_ALLOW_PACKAGES_FROM_PATHS = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_INSECURE_REDIRECT = "1";
    HOMEBREW_NO_EMOJI = "1";
    MISE_NODE_COREPACK = "true";
    VERCEL_TELEMETRY_DISABLED = "1";
    LLAMA_CACHE = "/Users/${userConfig.userName}/llama_cache";
    LLAMA_PORT = "58721";
  };

  home-manager.backupFileExtension = "bak";

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    allowed-users = [
      userConfig.userName
      "root"
    ];
    warn-dirty = false;
  };

  nix.optimise.automatic = true;

  nixpkgs = {
    hostPlatform = userConfig.hostPlatform;
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.nur.overlays.default
      inputs.nix4vscode.overlays.default
      self.overlays.additions
      self.overlays.modifications
    ];
  };

  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
