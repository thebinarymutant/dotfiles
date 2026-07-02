# ls/exa/eza
set -x LS_COLORS (vivid generate catppuccin-mocha)

# Nix
fish_add_path -Pm /etc/profiles/per-user/$USER/bin


# pnpm
set -x PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -P "$PNPM_HOME"

# local bin
# fish_add_path -P "$HOME/.local/bin"

# java
# set -gx ANDROID_HOME ~/.android/sdk
# set NDK (ls -1 $ANDROID_HOME/ndk | head -n 1)
# set -gx NDK_HOME "$ANDROID_HOME/ndk/$NDK"

set -gx ANDROID_HOME ~/Library/Android/sdk
set -gx ANDROID_NDK_ROOT $ANDROID_HOME/ndk
set -gx NDK_HOME $ANDROID_NDK_ROOT/29.0.14206865


# function expose_app_to_path
#     set -f app $argv[1]

#     if test -d ~/"Applications/$app.app"
#         fish_add_path -P ~/"Applications/$app.app/Contents/MacOS"
#     end
#     if test -d "/Applications/$app.app"
#         fish_add_path -P "/Applications/$app.app/Contents/MacOS"
#     end
# end

# expose_app_to_path "Visual Studio Code"
# expose_app_to_path Ghostty

# suppress greeting
set fish_greeting

# llama.cpp
set -gx LLAMA_CACHE "$HOME/llama_cache"
set -gx LLAMA_PORT 58721

starship init fish | source
atuin init fish | source

if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
