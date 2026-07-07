# Base Home Manager configuration shared by every host/profile.
{
  inputs,
  lib,
  pkgs,
  userConfig,
  hostName,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/${userConfig.userName}"
    else "/home/${userConfig.userName}";

  homeSecretsFile = ../secrets + "/${hostName}/${userConfig.userName}.yaml";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    username = userConfig.userName;
    inherit homeDirectory;
    stateVersion = "24.05";

    packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];
  };

  programs.home-manager.enable = true;

  sops = lib.mkIf (builtins.pathExists homeSecretsFile) {
    defaultSopsFile = homeSecretsFile;
    age.sshKeyPaths = [
      "${homeDirectory}/.ssh/sops.id_ed25519"
      "${homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
