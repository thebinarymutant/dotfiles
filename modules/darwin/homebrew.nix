{config, ...}: {
  # Homebrew needs to be installed on its own. nix-homebrew keeps taps declarative.
  homebrew = {
    enable = true;

    brews = [
      "awscli"
      "cloudflared"
      "doggo"
      "exercism"
      "gemini-cli"
      "hermes-agent"
      "pi-coding-agent"
      "pkgconf"
      "ruby-build"
      "trash" # Delete files and folders to trash instead of rm
      "git-lfs" # Git LFS for large files
      "nss"
      "mise"
      "moon"
      "watchman"
      "jjui"
      "gopeed"
      "anomalyco/tap/opencode"
      "modem-dev/tap/hunk"
      "jnsahaj/lumen/lumen"
      "postgresql@18"
      # GRD
      "mysql@8.0"
      "percona-toolkit"
      "imagemagick"
      "vips"
      "libsodium"
      "lnav"
      "nginx"
      "protobuf"
      "redis"
    ];

    casks = [
      "android-studio"
      "alacritty"
      "antigravity"
      "brave-browser"
      # cursor / cursor-cli — commented out because the Homebrew cask tries to set
      # kMDItemAlternateNames xattr on a binary inside Cursor.app. Once macOS TCC
      # grants privacy perms to Cursor, com.apple.macl locks all xattr writes (even
      # as root). brew treats the failure as fatal and rolls back the install.
      # See: https://forum.cursor.com/t/cursor-couldnt-finish-installing/162469/16
      # "cursor"
      # "cursor-cli"
      "codex"
      "codex-app"
      "discord"
      "docker-desktop"
      "figma"
      "firefox"
      "flying-carpet"
      "gitbutler"
      "google-chrome"
      "handy"
      "helium-browser"
      "marta"
      "microsoft-edge"
      "opencode-desktop"
      "open-design"
      "paper-design"
      "surge-downloader/tap/surge"
      "raycast"
      "rectangle"
      "signal"
      "spotify"
      "steam"
      "vlc"
      "wezterm"
      "zed"
      # "amethyst"
      # "ferdium"
      # "firefox-developer-edition"
      # "gitify" # Git notifications in menu bar
      "handbrake-app"
      # "logitech-g-hub"
      "losslesscut"
      # "meetingbar" # Show meetings in menu bar
      # "obsidian" # Obsidian packaging on Nix is not available for macOS
      # "visual-studio-code"
      # SketchyBar status bar https://github.com/slano-ls/SketchyBar
      # TODO:
    ];

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = true;
      extraEnv = {
        HOMEBREW_INTERNAL_ALLOW_PACKAGES_FROM_PATHS = "1";
      };
      extraFlags = ["--force-cleanup"];
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    masApps = {
      Xcode = 497799835;
      slack = 803453959;
      surfshark = 1437809329;
      tailscale = 1475387142;
      telegram = 747648890;
      whatsapp = 310633997;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
