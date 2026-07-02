{
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    ./chromium-extensions.nix
    ./homebrew.nix
    ./llama-server.nix
  ];

  ids.gids.nixbld = 350;

  fonts.packages = [
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    pkgs.nerd-fonts.open-dyslexic
    pkgs.nerd-fonts.shure-tech-mono
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  # services.nix-daemon.enable = true;

  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
      NowPlaying = true;
      Sound = true;
    };
    dock = {
      autohide = true;
      enable-spring-load-actions-on-all-items = true;
      magnification = false;
      mru-spaces = false;
      orientation = "left";
      persistent-apps = [
        {app = "/Applications/Cursor.app";}
        {app = "/Users/${userConfig.userName}/Applications/Home Manager Apps/Visual Studio Code.app";}
        {app = "/Applications/Zed.app";}
        {app = "/Applications/Google Chrome.app";}
        {app = "/Applications/Firefox.app";}
        # {app = "/Applications/Firefox Developer Edition.app";}
        {app = "/Applications/Microsoft Edge.app";}
        {app = "/Users/${userConfig.userName}/Applications/Home Manager Apps/Zen Browser (Beta).app";}
        {app = "/Applications/Docker.app";}
        {app = "/Applications/Alacritty.app";}
        {app = "/Applications/WezTerm.app";}
        {app = "/System/Applications/Music.app";}
        {app = "/Applications/Spotify.app";}
      ];
    };
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "${userConfig.userName}, I'm";
    screencapture.location = "~/Desktop/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  system.primaryUser = userConfig.userName;
  system.stateVersion = 4;

  users.knownUsers = [userConfig.userName];
  users.users = {
    ${userConfig.userName} = {
      home = "/Users/${userConfig.userName}";
      shell = pkgs.fish;
      uid = 501;
    };
  };
}
