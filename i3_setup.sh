#/bin/bash

# Written by noopduck
# 2020-10-15
#
# A fast mockup in order to quickly setup i3wm on Manjaro
#
# Gets i3 rust working plus all my i3 tweaks e.t.c
#
# At this date this script is too straight forwards and untested!!!
# For a new setup it's fine since it wont blow up anything in a bad way.
#
# 2021-02-18 Added zsh to the blend, just because it's pretty nice.
# Respect the bourn again!
#

# Disable nm-applet connect/disconnect notifications
gsettings set org.gnome.nm-applet disable-disconnected-notifications "true"
gsettings set org.gnome.nm-applet disable-connected-notifications "true"

# Install a few utilities
sudo pacman -S rofi git sysstat lsd i3status-rust alacritty strace ltrace zsh

git clone https://github.com/noopduck/consoletools.git /tmp/consoletools

cp -r /tmp/consoletools/DOTFILES/.config/i3/ $HOME/.config/
cp -r /tmp/consoletools/DOTFILES/.config/alacritty/ $HOME/.config/

# Setup powerline for tmux and bash
/tmp/consoletools/powerline/config.sh

# Tampering here causes a headache with omz and powerlevel10k
#echo "Add zsh into ~/.config instead of directly on ~"
#sudo bash -c "echo \"export ZDOTDIR=~/.config/zsh\" > /etc/zsh/zshenv"
#sudo bash -c "echo \"emulate sh -c \'source /etc/profile\'\" > /etc/zsh/zprofile\'"

echo "Add dotfiles into .config to make zsh awesome"
cp -r /tmp/consoletools/DOTFILES/.config/zsh ~/.config/

echo "DONE!: Run ctrl+shift+r inside i3 to reload configuration" 

