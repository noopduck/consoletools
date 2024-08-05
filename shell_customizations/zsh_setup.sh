#!/bin/bash

# Setting up zsh as default shell and launching it via bash temporarily
# Installing omz
# Installing powerlevel10k which is pretty sweet
function setup_software() {
	if [[ -f /etc/debian_version ]]; then
		echo "apt install zsh if not already installed"
		sudo apt -y install zsh fzf uuid-runtime tmux
	
	elif [[ "$(uname -r)" =~ "MANJARO" ]]; then
		echo "pacman installing zsh if not already installed"
		[[ ! $(pacman -Qs python-pip|grep "local/zsh") ]] && {
                        sudo pacman --noconfirm -S zsh fzf tmux
                }
	
	elif [[ "$(grep "ID=fedora" /etc/os-release)" ]]; then
		echo "Fedora running"
	
		[[ $(which dnf) ]] && {
			echo "dnf installing zsh if not already installed"
			sudo dnf install -y zsh util-linux-user fzf tmux
		}
	fi
}

echo "WHEN THIS SCRIPT PUTS YOU ON THE ZSH PROMPT, type: 'exit' in order to resume this script"

# Install zsh
setup_software

# Set gnome keyboard repeat rate and delay rates in order for a
# snappier and more plesant shell, vim, editor e.t.c experience.
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 140

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [ -d ~/.oh-my-zsh ]; then
export ZSH_CUSTOM="~/.oh-my-zsh/custom"
echo "source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
zsh -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc"

fi

# Install fonts
wget https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/fonts/fonts.tar.gz
# Create directory for user fonts if it doesn't exist
[[ ! -d ~/.local/share/fonts ]] && {  
    mkdir ~/.local/share/fonts
}
tar zvfx fonts.tar.gz -C ~/.local/share/fonts/.
fc-cache # Update font cache

rm fonts.tar.gz # cleanup font download

# Install nord theme for gnome-terminal
curl https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/nord.sh | bash

echo "Restart terminal after this..."
