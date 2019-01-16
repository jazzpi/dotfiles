export PATH="$HOME/bin:$PATH"
export VISUAL="emacsclient -c"
export EDITOR="emacsclient -t"
export TERMINAL="gnome-terminal"
if cmd_exists rustc; then
    export RUST_BACKTRACE=1
    export RUST_SRC_PATH="$(rustc --print sysroot)"/lib/rustlib/src/rust/src
fi
