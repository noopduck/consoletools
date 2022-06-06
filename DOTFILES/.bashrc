# Starts powerline shell status line
# pip install powerline-shell
alias ls='lsd --icon never'

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

# Avoid the shell uglyness under /dev/tty type term
[ ! "$(tty | grep /dev/tty)" ] && {
    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
}

export TERM=xterm-256color
export EDITOR=vim

# For sway (wayland) to set norwegian keyboard mapping
export XKB_DEFAULT_LAYOUT=no

# Maven setup
export MAVEN_HOME=~/projects/software/mvn_latest
export PATH=$PATH:MAVEN_HOME/bin

# Node stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


