#!/bin/bash
# Written by noopduck
# Modified 2021-03-10

# This script installs vim and builds it from source code
# It also automates the setup of the following plugins
#
# Practical plugins for vim
# vundle - plugin manager
# ansible-vim - Plugin for helping out with ansible
# Coc (Conquer of code) deprecates - #youcompleteme - code completion
# coc-explorer deprecates - #NERDTree - vim editor file navigator
# fzf deprecates - #Command-T - Fuzzy finder for files
# ansible-vim - For ansible
# vim-ruby - ruby
# vim-fugitive - for git
# sparkup - for faster html typing
# Make sure that /tmp/consoletools does not already exist (may be outdated)
function install_npm() {
    # Setup nvm
    curl https://raw.githubusercontent.com/noopduck/consoletools/master/nvm/setup_nvm.sh | bash

    # Setup shell temporarily in order to prepare nvm/npm config
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    nvm install --lts && nvm use --lts && npm install -g neovim yarn
}

function setup_software() {
    if [[ -f /etc/debian_version ]]; then
        echo "apt install python3-pip if not already installed"
        sudo apt -y install python3-pip neovim libcairo2-dev pkg-config python3-dev

        # make sure that python is python3 and not anything else...
        [[ ! $(ls /usr/bin/python|grep python3) ]] && {
            echo "/usr/bin/python does not point at python3 as it should, fixing it."
            sudo unlink /usr/bin/python
            sudo ln -s /usr/bin/python3 /usr/bin/python
        }

    elif [[ "$(uname -r)" =~ "MANJARO" ]]; then
        echo "pacman installing pyton-pip if not already installed"
        [[ ! $(pacman -Qs python-pip|grep "local/python-pip") ]] && { 
                        sudo pacman --noconfirm -S python-pip neovim
                }

    elif [[ "$(grep "ID=fedora" /etc/os-release)" ]]; then
        echo "Fedora running"

        [[ $(which dnf) ]] && {
            echo "dnf installing python3-pip if not already installed"
            sudo dnf install -y python3-pip neovim python-devel cairo-devel
        }

    else
        echo "Not supported, make sure you have python3 and pip."
        exit 1
    fi
}

# Setup DOTFILE DIR
curl https://raw.githubusercontent.com/noopduck/consoletools/master/DOTFILES/.config/nvim/init.vim -o ~/.config/nvim/init.vim
curl https://raw.githubusercontent.com/noopduck/consoletools/master/DOTFILES/.config/nvim/coc.vim -o ~/.config/nvim/coc.vim
curl https://raw.githubusercontent.com/noopduck/consoletools/master/DOTFILES/.config/nvim/coc-settings.json -o ~/.config/nvim/coc-settings.json

# Install required software
setup_software

# Add pynvim
pip install --user pynvim

# Install npm
install_npm

# Setup plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

# Install plugins in nvim
nvim +VimEnter +PluginInstall +qall!

echo "Plugins installed, setting up coc.nvim"
cd ~/.config/nvim/bundle/coc.nvim/src; yarn install; cd

echo "Setup is completed, restart terminal and run neovim with command: nvim"

