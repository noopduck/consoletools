set nocompatible              " be iMproved, required, welcome to the modern world
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'arcticicestudio/nord-vim'
Plugin 'dracula/vim'
Plugin 'rmehri01/onenord.nvim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'vim-ruby/vim-ruby'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'pearofducks/ansible-vim'
Plugin 'lilydjwg/colorizer'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'nvim-lua/plenary.nvim'
Plugin 'saecki/crates.nvim'
call vundle#end()            " required

lua require('crates').setup()

"let g:nord_cursor_line_number_background = 1
"let g:nord_uniform_status_lines = 1
"colorscheme nord
"colorscheme onenord
colorscheme dracula
set background=dark
highlight Normal ctermbg=none
"if (has("termguicolors"))
"    set termguicolors
"endif

syntax on
set relativenumber
set clipboard=unnamedplus " set to system clipboard, yank,delete pops to sysclipboard
filetype plugin indent on
set expandtab
set smartindent
set tabstop=4
set shiftwidth=4

" Enable display of whitespace chars
set list
set listchars=eol:$,space:·,tab:>-,trail:.,extends:>,precedes:<

" SHOW TABLINE

let g:airline_symbols = {}
"let g:airline_theme='nord'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

"airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#buffers_label = 'b'

nnoremap <silent> <Leader>t :FZF<CR>
let g:python3_host_prog = '/usr/bin/python'

source ~/.config/nvim/coc.vim

