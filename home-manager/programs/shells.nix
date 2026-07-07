{...}: {
  programs.bash = {
    enable = true;
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    bashrcExtra = ''
      export PATH="$HOME/.bun/bin:$HOME/.local/bin:$HOME/.local/share/pnpm:$PATH"
      eval "$(mise activate bash)"
    '';
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    initContent = ''
      export PATH="$HOME/.bun/bin:$HOME/.local/bin:$HOME/.local/share/pnpm:$PATH"
      eval "$(mise activate zsh)"
    '';
  };
}
