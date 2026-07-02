{
  pkgs,
  inputs,
  self,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # pkgs.age
    # pkgs.glow
    bandwhich # Terminal bandwidth utilization tool

    catppuccin-catwalk
    cmake
    curl

    devenv
    dua # Tool to conveniently learn about the disk usage of directories
    dust # du + rust = dust. Like du but more intuitive
    self.packages.${pkgs.stdenv.hostPlatform.system}.exifcleaner
    mkcert
    eza
    fd # Simple, fast and user-friendly alternative to find
    ffmpeg
    go
    hoppscotch # Open source API development ecosystem
    hyperfine # Command-line benchmarking tool
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    jujutsu # Git-compatible DVCS
    llama-cpp # High-performance LLM inference
    just # Handy way to save and run project-specific commands
    # lapce # Lightning-fast and Powerful Code Editor written in Rust
    lefthook # Fast and powerful Git hooks manager for any type of projects
    neovim
    typescript-language-server
    osv-scanner
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    pdftk
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    silicon # Create beautiful image of your source code
    scc # Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
    stripe-cli
    vivid # Color genratero for `ls` like commands
    # yaak # Desktop API client for organizing and executing REST, GraphQL, and gRPC requests
    inputs.zen-browser
    # Android
    # androidSdkPackages.cmdline-tools-latest # Provides adb, avdmanager, sdkmanager, etc.
    # androidSdkPackages.emulator           # Provides the Android emulator
    # You might also add specific build tools or platform tools if needed globally, e.g.:
    # androidSdkPackages.build-tools-35-0-0
    # androidSdkPackages.platform-tools
    # androidSdkPackages.platforms-android-35
    # androidSdkPackages.ndk-26-1-10909125           # Provides the Android emulator
    # androidSdkPackages.tools
    # zulu17

    # Nix
    alejandra
    nil
    nixd
  ];
}
