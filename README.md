2024-10-30 - noopduck
- neovim setup uses Lazy and Mason for plugin management.
- neo-tree does not hide files by default
- A lot of other changes

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

![Image of nvim working with my setup](https://raw.githubusercontent.com/noopduck/consoletools/master/nvim.gif)

**__________________________________________________________________________________________**

NVIM setup

```shell
git clone https://github.com/noopduck/consoletools.git
cd consoletools/vim
./nvim_setup.sh
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

TMUX+Powerline setup 

![Image of nvim working with my setup](https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/tmux-powerline.png)

ps: This code unlinks /usr/bin/python and links it to /usr/bin/python3
at least then you are aware in case you use another approach for it.

```shell
git clone https://github.com/noopduck/consoletools.git
cd consoletools/shell_customizations
./tmux_setup.sh
```

ZSH setup

Customization of zsh, adds some nice fonts to local user and allow to theme it a bit

```shell
git clone https://github.com/noopduck/consoletools.git
cd shell_customizations
./zsh_setup.sh
```

Fix Firefox theme to adhere to adawaita GTK4
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

FONTS...
https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/PowerlineExtraSymbols.otf?raw=true
