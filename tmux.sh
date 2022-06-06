#!/bin/bash
export PATH=$PATH:~/.local/bin

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

# Avoid the shell uglyness under /dev/tty type term
[ ! "$(tty | grep /dev/tty)" ] && {
    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
}

if [[ $TERM_PROGRAM ]]; then
        if [[ $TERM_PROGRAM = "vscode" ]]; then
                exit
        fi
fi

SESSION=noopduck

SESSIONS=$(tmux list-sessions | grep $SESSION)

[[ "$SESSIONS" =~ "no server running" ]] && {
        SESSIONS=""
}

[[ "$SESSIONS" = "" ]] && {
        [[ ! "$(uname -a)" =~ "microsoft-standard" ]] && {
                systemd-run --scope --user tmux new-session -d -s $SESSION
        } || {
                tmux new-session -d -s $SESSION
        }
        tmux rename-window -t $SESSION:0 'Chat'
        tmux send -t $SESSION:0 'TERM=tmux-256color /usr/bin/irssi -c irc' 'ENTER';

        tmux set-window-option -g mode-keys vi
        tmux bind h select-pane -L
        tmux bind j select-pane -D
        tmux bind k select-pane -U
        tmux bind l select-pane -R
}

#[[ ! "$TMUX" ]] && {
#        tmux attach-session -t $SESSION:0
#}


