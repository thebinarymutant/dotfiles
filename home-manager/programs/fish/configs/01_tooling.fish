set -x LS_COLORS (vivid generate catppuccin-mocha)

fish_add_path -Pm /etc/profiles/per-user/$USER/bin
fish_add_path -Pm $HOME/.bun/bin
fish_add_path -Pm $HOME/.local/bin
fish_add_path -Pm $HOME/.local/share/pnpm

set fish_greeting

starship init fish | source
atuin init fish | source

if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
