#!/bin/bash
# Written by noopduck
# Modified 2020-09-30
# Modified 2021-03-10

# This script installs vim and builds it from source code
# It also assists in adding the following plugins
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
#
# themes:
# nord-vim - a beautiful and plesant colorscheme for vim
# vim-airline-themes - adds more beauty and elegance to vim, functional powerline setup

# Dependency resolver that handles Arch and Debian distros for now
resolve_deps() {
    # Solve some dependencies for later
    # Change this if you need packages for your spesific distro
    [ $(grep ID_LIKE /etc/os-release |cut -d"=" -f2) == "arch" ] && {
        install_arch_deps;
    } || { # Everything else currently falls into debian based
        install_deps;
    }  
}

# Debian spesific dependencies
install_deps() {
	sudo apt install python3 python3-dev ruby ruby-dev libperl-dev git cmake build-essential ncurses-dev
}

# Arch spesific dependencies
install_arch_deps() {
    sudo pacman -Sy
    sudo pacman -S cmake ruby ruby-rake 
}

install_vim() {
	# Solve some dependencies for later
	resolve_deps;

	# clone git repo
	git clone https://github.com/vim/vim /tmp/vim

	# configure and otherwise build/install vim
	cd /tmp/vim
	make distclean
	cd src

	./configure \
		--with-features=huge \
		--prefix=/usr/local \
		--enable-gui=auto \
		\
		--enable-cscope \
		--enable-fail-if-missing \
		--enable-largefile \
		--enable-multibyte \
		\
		--enable-perlinterp=dynamic \
		--enable-python3interp \
		--with-python3-config-dir=$(python3-config --configdir) \
		--enable-rubyinterp \
		--with-ruby-command=$(which ruby) \
		\

	make && sudo make install
	cd ..
	rm -rf /tmp/vim
}

install_plugins() {

	mkdir -p ~/.vim/bundle

	# Clone 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	git clone https://github.com/noopduck/consoletools/ /tmp/consoletools
	cd /tmp/consoletools/DOTFILES
	cp .vimrc ~/.vimrc

	cd .. && rm -rf consoletools

	printf "\n\n\n"

	# Enters and installs plugins unattended
	vim +VimEnter +PluginInstall "+CocInstall coc-explorer coc-json coc-pairs coc-snippets coc-prettier coc-python coc-java coc-rls"
	#echo "When this completes, you must run config.sh -m to build plugin sources that needs it"
}

# This section is no longer needed
# fzf and Coc doesn't need it
#build_plugs() {
#        # Took out the setup of YCM, using COC instead.
#	echo "Now run vim and :PluginInstall"# Need to compile these two
#	#cd ~/.vim/bundle/YouCompleteMe
#	#python3 install.py
#
#	# To launch command-t in NORMAL MODE HIT; <backslash+t>
#	cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t/
#	ruby extconf.rb
#
#	make
#}

usage() {
	echo "To install vim config.sh -i"
	echo "To install plugins config.sh -p"
	#echo "To build plugins config.sh -m" - not needed anymore
}

if [ "$1" == "-i" ]; then
	install_vim;
elif [ "$1" == "-p" ]; then
	install_plugins;
#elif [ "$1" == "-m" ]; then #not required
#	build_plugs;
else
	usage;
fi

