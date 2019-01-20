export PATH="$HOME/bin:$HOME/.pyenv/bin:$PATH"
export VISUAL="emacsclient -c"
export EDITOR="emacsclient -t"
export TERMINAL="gnome-terminal"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
if command -v rustc &>/dev/null; then
    export RUST_BACKTRACE=1
    export RUST_SRC_PATH="$(rustc --print sysroot)"/lib/rustlib/src/rust/src
fi
