2019-12-31 - noopduck
-updated several times but last date was 2021-03-14

2021-09-10 - noopduck
-Making scripts (Windows) WSL2 friendlier
-Can run WSL2 Ubuntu 20.04 neovim with ConquerOfCode (coc.nvim)
-Tmux scripts (powerline) should add path setup inside .zshrc correctly now
-Launch tmux session script works



Shell/terminal candy automations.
Intention is to have something up and running fast, it must be practical and good looking
I think this is a good mix.

Disclaimer is a given, but i use this myself and it works very well for me.
if someone has suggestions for improvements I am certain that there is room for that,
make an issue or what it's called and I will most likely look at it.

**__________________________________________________________________________________________**

![Animation of functional i3 setup](https://raw.githubusercontent.com/noopduck/consoletools/master/consoletools.gif)

![Image of nvim working with my setup](https://raw.githubusercontent.com/noopduck/consoletools/master/nvim_setup.png)

**__________________________________________________________________________________________**

NVIM setup

```shell
curl https://raw.githubusercontent.com/noopduck/consoletools/master/vim/nvim_setup.sh | bash
```

Note: FreeBSD users first need to install a C compiler and a few other things.
```shell
pgk install gcc # in order to build node
/usr/local/bin/python3.9 -m ensurepip
python3.9 -m pip install pynvim

```
update into this::
let g:python3_host_prog = '/usr/local/bin/python3.9'
into ~/.config/nvim/init.vim

For some distributions /usr/bin/python may be pointing to python2 instead of python3 in these cases:

```shell

[[ -L /usr/bin/python ]] && [[ ! $(ls -l /usr/bin/python|grep python3) ]] && { 
    sudo unlink /usr/bin/python;
    sudo ln -s /usr/bin/python3 /usr/bin/python;
}
```

Or specify

```shell
let g:python3_host_prog = '/usr/bin/python3'
```
inside ~/.config/nvim/init.vim

**__________________________________________________________________________________________**

VIM setup

ps: This one builds vim from source in order to avoid any issues with compiled-in features,
I use nvim (neovim) instead, i have not tested this one in a good while, and there are some untested
changes in the setup of plugins and such. It may require some manual intervention at this point.
I keep it arround because it may happen that I end up on a more legacy'ish system and may want to trick it out anyway.

```shell
curl https://raw.githubusercontent.com/noopduck/consoletools/master/vim/config.sh | bash
```
**__________________________________________________________________________________________**

TMUX+Powerline setup 

![Image of nvim working with my setup](https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/tmux-powerline.png)

ps: This code unlinks /usr/bin/python and links it to /usr/bin/python3
at least then you are aware in case you use another approach for it.

```shell
curl https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/tmux_setup.sh | bash
```

ZSH setup

Customization of zsh, adds some nice fonts to local user and allow to theme it a bit

```
curl https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/zsh_setup.sh | bash
```

Fix Firefox theme to adhere to adawaita GTK4
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

FONTS...
https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/PowerlineExtraSymbols.otf?raw=true
