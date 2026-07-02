{
  description = "Nix config + Flakes + Home Manager";

  inputs = {
    # Nixpkgs
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";

      # The main branch follows the "canary" channel of the Android SDK
      # repository. Use another android-nixpkgs branch to explicitly
      # track an SDK release channel.
      #
      # url = "github:tadfisher/android-nixpkgs/stable";
      # url = "github:tadfisher/android-nixpkgs/beta";
      # url = "github:tadfisher/android-nixpkgs/preview";
      # url = "github:tadfisher/android-nixpkgs/canary";
    };
    # If you have nixpkgs as an input, this will replace the "nixpkgs" input
    # for the "android" flake.
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin = {
      url = "github:catppuccin/nix";
    };
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # SOPS + age secret management for NixOS, nix-darwin, and Home Manager.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux-only Helium Browser flake. macOS uses Homebrew's helium-browser cask.
    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "brew-src";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: Declarative tap management
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    anomalyco-tap = {
      url = "github:anomalyco/homebrew-tap";
      flake = false;
    };

    modemdev-tap = {
      url = "github:modem-dev/homebrew-tap";
      flake = false;
    };

    jnsahaj-lumen-tap = {
      url = "github:jnsahaj/homebrew-lumen";
      flake = false;
    };

    surge-downloader-tap = {
      url = "github:surge-downloader/homebrew-tap";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    android-nixpkgs,
    catppuccin,
    home-manager,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    anomalyco-tap,
    modemdev-tap,
    jnsahaj-lumen-tap,
    surge-downloader-tap,
    nix4vscode,
    ...
  } @ inputs: let
    inherit (self) outputs;

    overlays = import ./overlays {inherit inputs;};

    users = {
      sakatagintoki = {
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "sakatagintoki";
        userName = "yoda";
      };
      hijikatatoshiro = {
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "hijikatatoshiro";
        userName = "yoda";
      };
    };

    hosts = {
      sakatagintoki = {
        type = "darwin";
        system = users.sakatagintoki.hostPlatform;
        user = users.sakatagintoki;
        modulesPath = ./hosts/darwin/sakatagintoki;
        profiles = ["common" "darwin-common" "workstation"];
      };
      hijikatatoshiro = {
        type = "darwin";
        system = users.hijikatatoshiro.hostPlatform;
        user = users.hijikatatoshiro;
        modulesPath = ./hosts/darwin/hijikatatoshiro;
        profiles = ["common" "darwin-common" "workstation"];
      };
    };

    darwinHosts = nixpkgs.lib.filterAttrs (_: h: h.type == "darwin") hosts;
    nixosHosts = nixpkgs.lib.filterAttrs (_: h: h.type == "nixos") hosts;

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nur.overlays.default
          inputs.nix4vscode.overlays.default
          overlays.additions
          overlays.modifications
        ];
      };

    mkHomeImports = host:
      [
        ./home-manager
      ]
      ++ (map (profile: ./home-manager/profiles/${profile}.nix) host.profiles);

    mkHomeSpecialArgs = hostName: host: {
      inherit self inputs outputs hostName;
      userConfig = host.user;
      hostProfiles = host.profiles;
    };

    mkHomeManagerModule = hostName: host: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${host.user.userName}.imports = mkHomeImports host;
      home-manager.extraSpecialArgs = mkHomeSpecialArgs hostName host;
    };

    mkHomeConfiguration = hostName: host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs host.system;
        modules = mkHomeImports host;
        extraSpecialArgs = mkHomeSpecialArgs hostName host;
      };

    mkHomeConfigurations = hosts:
      builtins.listToAttrs (map (hostName: let
          host = hosts.${hostName};
        in {
          name = "${host.user.userName}@${hostName}";
          value = mkHomeConfiguration hostName host;
        })
        (builtins.attrNames hosts));

    mkNixosConfiguration = hostName: host:
      nixpkgs.lib.nixosSystem {
        system = host.system;
        specialArgs = {
          inherit self inputs outputs hostName;
          userConfig = host.user;
          nixosModules = "${self}/modules/nixos";
        };
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.helium-browser.nixosModules.default
          ./modules/shared
          ./modules/nixos
          host.modulesPath
          home-manager.nixosModules.home-manager
          (mkHomeManagerModule hostName host)
        ];
      };

    mkDarwinConfiguration = hostName: host:
      nix-darwin.lib.darwinSystem {
        system = host.system;
        specialArgs = {
          inherit self inputs outputs hostName;
          userConfig = host.user;
        };
        modules = [
          inputs.sops-nix.darwinModules.sops
          ./modules/shared
          ./modules/darwin
          host.modulesPath
          home-manager.darwinModules.home-manager
          (mkHomeManagerModule hostName host)
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = host.user.userName;
              extraEnv = {
                HOMEBREW_INTERNAL_ALLOW_PACKAGES_FROM_PATHS = "1";
              };
              taps = {
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "anomalyco/homebrew-tap" = anomalyco-tap;
                "modem-dev/homebrew-tap" = modemdev-tap;
                "jnsahaj/homebrew-lumen" = jnsahaj-lumen-tap;
                "surge-downloader/tap" = surge-downloader-tap;
              };
              mutableTaps = true;
            };
          }
        ];
      };

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixfmt'
    formatter = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.writeShellApplication {
        name = "format-nix";
        runtimeInputs = [pkgs.alejandra];
        text = ''
          if [ "$#" -eq 0 ]; then
            exec alejandra .
          fi

          exec alejandra "$@"
        '';
      });
    # Your custom packages and modifications, exported as overlays
    inherit overlays;

    darwinConfigurations = builtins.mapAttrs mkDarwinConfiguration darwinHosts;
    nixosConfigurations = builtins.mapAttrs mkNixosConfiguration nixosHosts;
    # Example: add a darwin host
    # darwinConfigurations.example-mac = mkDarwinConfiguration "example-mac" {
    #   type = "darwin";
    #   system = "aarch64-darwin";
    #   user = users.sakatagintoki;
    #   modulesPath = ./hosts/darwin/example-mac;
    #   profiles = ["common" "workstation"];
    # };
    # Example: add a nixos host
    # nixosConfigurations.kotarokatsura = mkNixosConfiguration "kotarokatsura" {
    #   type = "nixos";
    #   system = "aarch64-linux";
    #   user = users.yoda;
    #   modulesPath = ./hosts/nixos/kotarokatsura;
    #   profiles = ["common" "server"];
    # };

    homeConfigurations = mkHomeConfigurations hosts;
  };
}
