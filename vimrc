" ==========================================================
" System resource locations (use same .vimrc across different machines)
" ==========================================================

let hostname = substitute(system('hostname'), '\n', '', '')
if hostname =~# "Joshals-MacBook.."
   " home MacBook
   let home="/Users/joshal/"
   let vimHome=home . ".vim"
   let tmpDir=home . ".tmpvim"
endif

" ==========================================================
" Vundle INITIALIZATION
" ==========================================================
set nocompatible              	" be iMproved, required
filetype off                  	" required
let mapleader=";"             	" change the leader to be a comma vs slash

" add vimhome to rtp
exec 'set rtp+='.vimHome

" set the runtime path to include Vundle and initialize
exec 'set rtp+='.vimHome."/bundle/Vundle.vim"
call vundle#rc(vimHome . "/bundle")

" git repos for vundle installation (arrange alphbetically)
Plugin 'kien/ctrlp.vim'               		    	" Fuzzy file, buffer, mru, tag, etc finder
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'scrooloose/syntastic'						" syntax checking plugin
Plugin 'majutsushi/tagbar'							" a class outline viewer for Vim
Plugin 'bling/vim-airline'			    			" lean & mean status/tabline for vim that's light as air
Plugin 'altercation/vim-colors-solarized'           " precision colorscheme for the vim text editor
Plugin 'tpope/vim-fugitive'							" git wrapper
Plugin 'fatih/vim-go'								" Go (golang) support for Vim
Plugin 'christoomey/vim-tmux-navigator'             " hjkl between vim split and tmux panes
Plugin 'gmarik/Vundle.vim'			    			" let Vundle manage Vundle, required
Plugin 'Valloric/YouCompleteMe'						" fast, as-you-type, fuzzy-search code completion

" ==========================================================
" Basic Settings
" ==========================================================
syntax on                     	" syntax highlighing
filetype on                   	" try to detect filetypes
filetype plugin indent on     	" enable loading indent file; required for vundle

""" Color scheme
syntax enable
set background=dark
colorscheme solarized

set number                    	" Display line numbers
set numberwidth=1             	" using only 1 column (and 1 space) while possible
set title                     	" show title in console title bar
set wildmenu                  	" Menu completion in command mode on <Tab>
set wildmode=full             	" <Tab> cycles between all matching choices.
set cmdheight=2					" give more space for displaying messages; height of command line

""" Moving Around/Editing
set cursorline                	" have a line indicate the cursor location
set ruler                     	" show the cursor position all the time
set nostartofline             	" Prevent the cursor from changing the current column when jumping to other lines
set virtualedit=block         	" Let cursor move past the last char in <C-v> mode
set scrolloff=3               	" Keep 3 context lines above and below the cursor
set backspace=2               	" Allow backspacing over autoindent, EOL, and BOL
set showmatch                 	" Briefly jump to a paren once it's balanced
set linebreak                 	" don't wrap textin the middle of a word
set autoindent                	" always set autoindenting on
set smartindent               	" use smart indent if there is no indent file
set textwidth=119             	" lines longer than 119 columns will be broken
set tabstop=4                 	" <tab> inserts 4 spaces

"""" Messages, Info, Status
set laststatus=2				" Always show statusline, even if only 1 window

" don't bell or blink
set noerrorbells
set vb t_vb=

" ==========================================================
" Mappings
" ==========================================================

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

" ==========================================================
" Plugin Settings
" ==========================================================

""" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""" vim-airline
" automatically populate the g:airline_symbols dictionary with the powerline symbols
let g:airline_powerline_fonts = 1

""" vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
