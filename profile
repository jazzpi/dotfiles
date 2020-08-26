# -*- mode: shell-script -*-

export PATH="$HOME/bin:$HOME/.pyenv/bin:$PATH"
export VISUAL="emacsclient -c"
export EDITOR="emacsclient -t"
export TERMINAL="gnome-terminal"
export XDG_RUNTIME_DIR=/run/user/$(id -u)
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if command -v rustc &>/dev/null; then
    export RUST_BACKTRACE=1
    export RUST_SRC_PATH="$(rustc --print sysroot)"/lib/rustlib/src/rust/src
fi

if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.bashrc"
fi
