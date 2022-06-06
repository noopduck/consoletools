#!/bin/bash

# Setup tmux, install tpm (tmux plugin manager)
# Configure tmux.conf to my liking.

# Written by: noopduck
# 2020-05-20
#
# Modified: 2021-07-22
# Separated powerline setup from tmux setup.
# Some may only want to use the powerline setup.

# Setup powerline
/tmp/consoletools/shell_customizations/powerline_setup.sh

# Make sure tmux exists
if [[ -f /etc/debian_version ]]; then
	echo "apt install tmux if not already installed"
	sudo apt -y install tmux

	# make sure that python is python3 and not anything else...
	[[ ! $(ls /usr/bin/python|grep python3) ]] && {
		echo "/usr/bin/python does not point at python3 as it should, fixing it."
		sudo unlink /usr/bin/python
		sudo ln -s /usr/bin/python3 /usr/bin/python
	}

elif [[ "$(uname -r)" =~ "MANJARO" ]]; then
        echo "pacman installing tmux if not already installed"
        [[ ! $(pacman -Qs tmux|grep "local/tmux") ]] && {
	       sudo pacman -S tmux
        }

elif [[ "$(grep "ID=fedora" /etc/os-release)" ]]; then
	echo "Fedora running"

	[[ $(which dnf) ]] && {
		echo "dnf installing tmux if not already installed"
		sudo dnf install -y tmux
	}

else
	echo "Not supported, make sure you have tmux."
	exit 1
fi

[ ! -d ~/.tmux/plugins ] && {
    echo "~./tmux/plugins does not exist, creating dirs and cloning tpm git repo into it"
    mkdir -p ~/.tmux/plugins

    # Clone the tmux plugin manager and console tools
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
} || {
    echo "~/.tmux/plugins already exists"

    # Does tmux-plugins tpm exist?
    [ ! -d ~/.tmux/plugins/tpm ] && {
	echo "~/.tmux/plugins/tpm ... tmux-plugins does not exist, creating"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm    
    } ||  {
	echo "tpm is already installed, leaving everything alone"
    }	
}

# Setup path for powerline temporarily
export PATH=$PATH:~/.local/bin

# Copy the .tmux.conf file into ~/
[ -f ~/.tmux.conf ] && {
    echo "~/.tmux.conf already exists, assuming append is in order"
    cat /tmp/consoletools/DOTFILES/.tmux.conf >> ~/.tmux.conf
} || {
    echo "~/.tmux.conf does not exist, creating file"
    cat /tmp/consoletools/DOTFILES/.tmux.conf > ~/.tmux.conf
} 

# Inside tmux run this to setup the plugins
echo "INSIDE tmux RUN ~/.tmux/plugins/tpm/tpm to install tpm"
echo "INSIDE tmux RUN CTRL+B followed by SHIFT+I"
