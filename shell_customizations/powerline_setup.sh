#!/bin/bash

# Setup powerline
# Configure $HOME/.bashrc to use powerline.
# Add $HOME/.local/bin to path in zsh if not already present 

# Written by: noopduck
# 2020-07-22
#
# Modified: 2021-07-22
# Separated powerline setup from tmux setup.
# Some may only want to use the powerline setup.

# Make sure pip exists
if [[ -f /etc/debian_version ]]; then
    echo "apt install powerline if not already installed"
    sudo apt -y install powerline python3-powerline python3-setuptools

    # make sure that python is python3 and not anything else...
    [[ ! $(ls /usr/bin/python|grep python3) ]] && {
        echo "/usr/bin/python does not point at python3 as it should, fixing it."
        sudo unlink /usr/bin/python
        sudo ln -s /usr/bin/python3 /usr/bin/python
    }

elif [[ "$(uname -r)" =~ "MANJARO" ]]; then
    echo "pacman installing pyton-pip if not already installed"
    [[ ! $(pacman -Qs python-pip|grep "local/python-pip") ]] && { sudo pacman -S python-pip; }

elif [[ "$(grep "ID=fedora" /etc/os-release)" ]]; then
    echo "Fedora running"

    [[ $(which dnf) ]] && {
        echo "dnf installing python3-pip if not already installed"
        sudo dnf install -y python3-pip
    }

else
    echo "Not supported, make sure you have python 3 pip."
    exit 1
fi

# On Debian just clone this repo and be done with it...
[[ -f /etc/debian_version ]] && {
    # Install powerline-shell
    git clone https://github.com/b-ryan/powerline-shell
    cd powerline-shell
    sudo python setup.py install
}

# As long as it's not debian, install regularly
# Debian gets it's install from apt
[[ ! -f /etc/debian_version ]] && {
 # Install the powerline tools using pip3
    # This way we dont need to be root and I prefer this.
    pip3 install --user powerline-status
    pip3 install --user powerline-shell

}

# Setup path for powerline temporarily
export PATH=$PATH:~/.local/bin

BASH_CONF_PART="ZXhwb3J0IFBBVEg9JFBBVEg6fi8ubG9jYWwvYmluCgpmdW5jdGlvbiBfdXBkYXRlX3BzMSgpIHsg
ICAgIAogICAgUFMxPSQocG93ZXJsaW5lLXNoZWxsICQ/KSAKfSAKCiMgQXZvaWQgdGhlIHNoZWxs
IHVnbHluZXNzIHVuZGVyIC9kZXYvdHR5IHR5cGUgdGVybSAKWyAhICIkKHR0eSB8IGdyZXAgL2Rl
di90dHkpIiBdICYmIHsgICAgIAogICAgaWYgW1sgJFRFUk0gIT0gbGludXggJiYgISAkUFJPTVBU
X0NPTU1BTkQgPX4gX3VwZGF0ZV9wczEgXV07IHRoZW4gICAgICAgICAKICAgIFBST01QVF9DT01N
QU5EPSJfdXBkYXRlX3BzMTsgJFBST01QVF9DT01NQU5EIiAgICAgCiAgICBmaSAKfQo="

# Assume that there is a .bashrc file in ~ regardless
[ ! $(grep -c "function _update_ps1" ~/.bashrc) == 1 ] && {
     echo "Adding powerline part to .bashrc"
     echo "$BASH_CONF_PART" | base64 -d >> ~/.bashrc
} || {
     echo "Call to powerline-shell already exists within .bashrc"
}

# Check if zsh is running
# Find the config file in the user home dir and add
# .local/bin to path inside it.
if [[ "$SHELL" =~ "zsh" ]]; then
    echo "Found zsh shell running"
    for i in $(find ~/.* -type f -name ".zshrc" -print0 2>/dev/null|xargs -0 echo); do
        if [[ -f $i ]]; then
            ZSHRC=$i
        fi
    done

    if ! grep ".local/bin" $ZSHRC; then
        echo "Adding .local/bin to PATH"
        echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC"
    else
        echo ".local/bin already exists"
    fi
fi
