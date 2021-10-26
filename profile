# -*- mode: shell-script -*-

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.pyenv/bin:$HOME/.cargo/bin:$HOME/perl5/bin:/usr/local-cuda-11.0/bin:$HOME/.platformio/penv/bin:$PATH"
if [ -d /mnt/c/WINDOWS ]; then
   export PATH="/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0:/mnt/c/WINDOWS/System32:$PATH"
fi
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5:$PERL_LOCAL_LIB_ROOT"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
export VISUAL="emacsclient -c"
export EDITOR="emacsclient -t"
export TERMINAL="gnome-terminal"
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export NVM_DIR="$HOME/.nvm"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if command -v rustc &>/dev/null; then
    export RUST_BACKTRACE=1
    export RUST_SRC_PATH="$(rustc --print sysroot)"/lib/rustlib/src/rust/src
fi
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
fi

if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.bashrc"
fi
