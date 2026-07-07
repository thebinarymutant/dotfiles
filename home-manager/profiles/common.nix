{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ../programs/fish.nix
    ../programs/shells.nix
    ../programs/git.nix
    ../programs/tealdeer.nix
    ../configs/writable-config-files.nix
    ../configs/mise-config.nix
    ../configs/shell-env.nix
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
  };

  home.shellAliases = {
    l = "eza -l -g --icons --git -a";
    lt = "eza --tree -g --level=2 --long --icons --git";
    cat = "bat";
    zja = "zellij --layout agent";
  };

  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    bat.enable = true;
    bottom.enable = true;
    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    starship.enable = true;
    zellij = {
      enable = true;
      layouts = {
        agent = ../configs/zellij/layouts/agent.kdl;
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  systemd.user.startServices = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "sd-switch";
}
