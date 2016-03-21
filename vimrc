" ==========================================================
" System resource locations (use same .vimrc across different machines)
" ==========================================================

let hostname = substitute(system('hostname'), '\n', '', '')
if hostname =~# "Joshals-Home-MacBook.."
    " home MacBook
    let homeDir = "/Users/joshal"
elseif hostname=~# "Joshals-Work-MacBook.."
    " work MacBook
    let homeDir = "/Users/joshaldaftari"
endif
let vimHomeDir = homeDir . "/.vim"
let tmpDir = homeDir . "/.tmpvim"


" ==========================================================
" Plugin installation with vim-plug
" ==========================================================

let vimPluggedHomeDir = vimHomeDir . '/plugged'
call plug#begin(vimPluggedHomeDir)

" Make sure you use single quotes
Plug 'rking/ag.vim'                                                           " plugin for the_silver_searcher, 'ag'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }             " fuzzy file search
Plug 'junegunn/fzf.vim'                                                       " fzf + vim (a replacement for ctrl+p)
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }                        " tree explorer plugin, on demand load
Plug 'scrooloose/syntastic'                                                   " syntax checking plugin
Plug 'majutsushi/tagbar'                                                      " a class outline viewer for Vim
Plug 'bling/vim-airline'                                                      " lean & mean status/tabline for vim that's light as air
Plug 'altercation/vim-colors-solarized'                                       " precision colorscheme for the vim text editor
Plug 'junegunn/vim-easy-align'                                                " easy-to-use Vim alignment plugin
Plug 'tpope/vim-fugitive'                                                     " git wrapper
Plug 'fatih/vim-go', { 'for' : ['go', 'markdown'] }                           " go (golang) support for Vim
Plug 'fisadev/vim-isort'                                                      " sort python imports
Plug 'christoomey/vim-tmux-navigator'                                         " hjkl between vim split and tmux panes
Plug 'Valloric/YouCompleteMe',
    \ { 'do' : vimPluggedHomeDir . '/YouCompleteMe/install.py --clang --go' } " fuzzy-search code completion

" Add plugins to &runtimepath
call plug#end()

" ==========================================================
" Basic Settings
" ==========================================================
set nocompatible                " make vim more useful
syntax on                       " syntax highlighing
filetype on                     " try to detect filetypes
filetype plugin indent on       " enable loading indent file; required for vundle
let mapleader=";"               " change the leader to be a colon vs slash

""" Color scheme
set t_Co=256
syntax enable
set background=dark
colorscheme solarized

set number                      " Display line numbers
set numberwidth=1               " using only 1 column (and 1 space) while possible
set title                       " show title in console title bar
set wildmenu                    " Menu completion in command mode on <Tab>
set wildmode=full               " <tab> cycles between all matching choices.
set cmdheight=2                 " give more space for displaying messages; height of command line

""" Moving Around/Editing
set cursorline                  " have a line indicate the cursor location
set ruler                       " show the cursor position all the time
set nostartofline               " Prevent the cursor from changing the current column when jumping to other lines
set virtualedit=block           " Let cursor move past the last char in <C-v> mode
set scrolloff=3                 " Keep 3 context lines above and below the cursor
set backspace=2                 " Allow backspacing over autoindent, EOL, and BOL
set showmatch                   " Briefly jump to a paren once it's balanced
set linebreak                   " don't wrap textin the middle of a word
set autoindent                  " always set autoindenting on
set smartindent                 " use smart indent if there is no indent file
set textwidth=99                " lines longer than 99 columns will be broken
set tabstop=4                   " <tab> inserts 4 spaces
set shiftwidth=4                " how many columns text is indented with the reindent operations (<< and >>)
set expandtab                   " hitting <tab> in insert mode will produce the appropriate number of spaces
set softtabstop=4               " how many columns vim uses when you hit <tab> in insert mode

""" Searching
set ignorecase                  " perform a case-insensitive search
set smartcase                   " use case-sensitive search if any caps used
set hlsearch                    " search highlighting

"""" Messages, Info, Status
set laststatus=2                " Always show statusline, even if only 1 window

" don't bell or blink
set noerrorbells
set vb t_vb=

" ==========================================================
" Mappings (non-plugin)
" ==========================================================

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w
" Save a file as root (;W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" ==========================================================
" Plugin Settings
" ==========================================================

""" ag.vim
"" always start searching from your project root instead of the cwd
let g:ag_working_path_mode = "r"

""" fzf.vim
"" disable statusline overwriting
let g:fzf_nvim_statusline = 0
"" ctrl+p opens fuzzy search for files
nnoremap <c-p> :Files<cr>

""" ctrlp
"" gitignore with ctrl p
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

""" NERDTree
"" open a NERDTree automatically when vim starts up
" autocmd VimEnter * NERDTree
"" move the cursor to the file editing area and not nerdtree
" autocmd VimEnter * wincmd p
"" open a nerdtree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if (argc() == 0 && !exists("s:std_in")) |  execute 'NERDTree' | endif
"" use ;n to open nerdtree
map <leader>n :NERDTreeToggle<CR>
"" close vim if nerdtree is the only window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

""" syntastic
"" *NOTE*: linters that syntastic supports:
"" https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"" ignore certain flake8 errors and warnings
"" E221: multiple spaces before operator
"" E241: multiple spaces after ‘,’
"" E272: multiple spaces before keyword
let g:syntastic_python_flake8_post_args='--ignore=E221,E241,E272 --max-line-length=99'

""" vim-airline
"" automatically populate the g:airline_symbols dictionary with the powerline symbols
let g:airline_powerline_fonts = 1
"" displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

""" vim-easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""" vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
"" go lint
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
" automatically run `golint` on `:w`
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

""" YouCompleteMe
"" map ;m to go to declaration/definition
nnoremap <leader>m :YcmCompleter GoTo<CR>
"" python to use with ycm
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'
