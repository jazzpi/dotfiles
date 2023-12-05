alias rsrc=". ~/.bashrc"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias la="ls -lAh"
alias ll="ls -lh"
alias lsa="ls -lah"
alias l="ls -A --group-directories-first"

alias uds="udisksctl status"
alias udm="udisksctl mount -b"
alias udu="udisksctl unmount -b"

alias g="git"
alias gco="git checkout"
alias gst="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gf="git fetch"
alias gl="git pull"
alias glg="git log"

function dockattach {
    docker start $@ && docker attach $@
}
