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
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export NVM_DIR="$HOME/.nvm"

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}
export XDG_DATA_DIRS=${XDG_DATA_DIRS:="/usr/local/share:/usr/share"}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:="/etc/xdg"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:="/run/user/$(id -u)"}

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
if [ "$XDG_SESSION_DESKTOP" = "sway" ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
    # Make sway suck less on proprietary nvidia drivers
    if lsmod | grep -q nvidia; then
        export WLR_RENDERER=vulkan
        export WLR_NO_HARDWARE_CURSORS=1
        export XWAYLAND_NO_GLAMOR=1
    fi
fi
fi

if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.bashrc"
fi
