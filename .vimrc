runtime bundle/pathogen/autoload/pathogen.vim

set paste           "use ctrl-p or cmd-p to paste
set number          "line numbers
set ignorecase      "ignore case while searching
set smartcase       "if camel-cased, dont ignore case
set incsearch       "instant search
set nocompatible    "non compatibe
set hlsearch        "Highlight the search term

execute pathogen#infect()
call pathogen#helptags()

let NERDTreeIgnore = ['\.pyc$']             "NERDTree ignore filetypes
let g:gitgutter_enabled = 0                 "Disable GitGutter by default
let g:email = "dhilipsiva@gmail.com"
let g:username = "dhilipsiva"

set tabstop=4
set shiftwidth=4
au BufNewFile,BufReadPost *.coffee,*.rb,*.yml,*.yaml,*.js,*.jade setl tabstop=2 shiftwidth=2

set expandtab

filetype on
autocmd BufWritePost *.py call Flake8() "apply flake8 as files are saved
autocmd BufWritePre * :%s/\s\+$//e "Trim the line endings
syntax on

"I hate 'Modifiable is off' warnings. I dont properly understand how am I ending up with that error. This is a quick trick to restore writable state.
func! ModifiableOff()
    set modifiable
    set noreadonly
    set number
endfu
:com! ModOff call ModifiableOff()

filetype plugin indent on

"post Pathogen functions
colorscheme ansi_blows
if has("gui_running")
    set guifont=Monaco:h12     "favorite font
    set guioptions-=m           "remove menu bar
    set guioptions-=T           "remove toolbar
    set guioptions-=r           "remove right-hand scroll bar
    set fu                      "Goto full screen on mac
endif

"Disable CoffeeSpaceError
hi link coffeeSpaceError NONE
let g:syntastic_mode_map={ 'mode': 'active', 'passive_filetypes': ['html', 'python'] }
"let g:templates_no_autocmd = 1
let g:syntastic_enable_perl_checker = 1
let python_highlight_all = 1
cabbr <expr> %% expand('%:p:h')

" Spell Check - `lexical` plugin
augroup lexical
  autocmd!
  au BufNewFile,BufReadPost *.md,*.txt,*.mkd,*.markdown call lexical#init()
augroup END

" Some people just dont follow pep-8 strongly. This setting for for when I edit those stupid code
" let g:flake8_ignore="W291,W293,E127,E128,E201,E202,E203,E121,E122,E126,E225,E251,E261,E301,E302,E303,E501,E711"
" ^ That is depricated :(

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,.git/*,*/node_modules*/,*/bower_components/*

au BufNewFile,BufRead *.py,*js set colorcolumn=80

autocmd BufNewFile,BufRead *.cap   set syntax=ruby

set backupdir=~/.vim/_backup//
set directory=~/.vim/_tmp//

let g:templates_directory = '~/.vim/templates'

au BufNewFile,BufReadPost *.emblem,*.haml,*.py,*.coffee,*.jade set foldmethod=indent

let g:vim_markdown_conceal = 0
