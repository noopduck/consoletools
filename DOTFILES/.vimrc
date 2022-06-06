set nocompatible              " be iMproved, required, welcome to the future
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'vim-ruby/vim-ruby'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'pearofducks/ansible-vim'
Plugin 'arcticicestudio/nord-vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
call vundle#end()            " required

let g:nord_cursor_line_number_background = 1
let g:nord_uniform_status_lines = 1
colorscheme nord
set background=light

syntax on
set relativenumber
set clipboard=unnamedplus

"filetype on
"filetype plugin indent on    " required
"filetype indent on
"filetype plugin on
"autocmd FileType ruby compiler ruby
"set wildmode=list:longest
   
"au FileType php setl ofu=phpcomplete#CompletePHP
"au FileType ruby,eruby setl ofu=rubycomplete#Complete
"au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
"au FileType c setl ofu=ccomplete#CompleteCpp
"au FileType css setl ofu=csscomplete#CompleteCSS
"au FileType java setl ofu=javacomplete#CompleteJava
"set completeopt-=preview
"set completeopt+=noinsert
"let g:syntastic_java_checkers = []

" SHOW TABLINE

let g:airline_symbols = {}
let g:airline_theme='nord'

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
source ~/.vim/coc.vim
