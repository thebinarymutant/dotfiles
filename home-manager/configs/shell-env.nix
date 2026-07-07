{...}: {
  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/pnpm"
  ];

  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_NDK_ROOT = "$HOME/Library/Android/sdk/ndk";
    NDK_HOME = "$HOME/Library/Android/sdk/ndk/29.0.14206865";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };
}
