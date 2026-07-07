{
  lib,
  pkgs,
  ...
}: let
  privacy = import ./browser-privacy.nix {inherit lib;};
  extensions = import ./browser-extensions.nix {inherit lib pkgs;};
in {
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies =
      privacy.policies
      // {
        ExtensionSettings = extensions.extensionSettingsFor "zen";
      };

    profiles.default = {
      id = 0;
      isDefault = true;
      path = "default";

      extensions = {
        force = true;
        packages = extensions.packagesFor "zen";
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = ["ddg" "google"];
        engines = {
          bing.metaData.hidden = true;
        };
      };

      settings =
        privacy.settings
        // {
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.urlbar.behavior" = "float";
        };
    };
  };

  # Zen hashes the Nix store app path for dedicated profiles. That path changes
  # after rebuilds, and Home Manager's declarative profiles.ini is read-only,
  # which can make Zen try to create a new inaccessible profile. Use the normal
  # profiles.ini default instead.
  home.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    MOZ_LEGACY_PROFILES = "1";
  };

  launchd.agents.moz-legacy-profiles = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = ["/bin/launchctl" "setenv" "MOZ_LEGACY_PROFILES" "1"];
      RunAtLoad = true;
    };
  };

  # Keep macOS Zen's install-specific profile lock in sync with the declarative
  # Home Manager profile as a fallback for launches that do not inherit the
  # launchd environment above.
  home.file."Library/Application Support/Zen/installs.ini" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    text = ''
      [A63691297E687233]
      Default=Profiles/default
      Locked=1

      [C6181402110E1D04]
      Default=Profiles/default
      Locked=1

      [92D6F075B049FE64]
      Default=Profiles/default
      Locked=1

      [9FE932608B093EF5]
      Default=Profiles/default
      Locked=1

      [80B1E8CB709C1CDE]
      Default=Profiles/default
      Locked=1
    '';
  };
}
