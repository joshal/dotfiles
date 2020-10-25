" ==========================================================
" System resource locations (use same .vimrc across different machines)
" ==========================================================

let vimHomeDir = $HOME . "/.vim"
let tmpDir = $HOME . "/.tmpvim"

" ==========================================================
" Plugin installation with vim-plug
" ==========================================================

let vimPluggedHomeDir = vimHomeDir . '/plugged'
call plug#begin(vimPluggedHomeDir)

" Make sure you use single quotes
Plug 'w0rp/ale'
Plug 'psf/black'                                                                     " uncompromising Python code formatter
Plug 'neoclide/coc.nvim', {'branch': 'release'}                                      " intellisense engine for neovim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }                    " fuzzy file search
Plug 'junegunn/fzf.vim'                                                              " fzf + vim (a replacement for ctrl+p)
Plug 'morhetz/gruvbox'                                                               " retro groove color scheme for Vim
Plug 'sbdchd/neoformat'                                                              " a (Neo)vim plugin for formatting code.
Plug 'scrooloose/nerdtree'                                                           " tree explorer plugin, on demand load
Plug 'Xuyuanp/nerdtree-git-plugin'                                                   " A plugin of NERDTree showing git status
Plug 'AndrewRadev/splitjoin.vim'                                                     " simplifies the transition between multiline and single-line code
Plug 'majutsushi/tagbar'                                                             " a class outline viewer for Vim
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }                                  " tern based javascript editing
Plug 'edkolev/tmuxline.vim'                                                          " tmux statusline generator
Plug 'bling/vim-airline'                                                             " lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline-themes'                                                " themes for vim-airline plugin
Plug 'chase/vim-ansible-yaml'                                                        " additional support for Ansible in vim
Plug 'junegunn/vim-easy-align'                                                       " easy-to-use Vim alignment plugin
Plug 'tpope/vim-fugitive'                                                            " git wrapper
Plug 'airblade/vim-gitgutter'                                                        " shows a git diff in the gutter
Plug 'fatih/vim-go', { 'for' : ['go', 'markdown'] }                                  " go (golang) support for Vim
Plug 'fisadev/vim-isort'                                                             " sort python imports
Plug 'jeffkreeftmeijer/vim-numbertoggle'                                             " Toggles between hybrid and absolute line numbers automatically
Plug 'lifepillar/vim-solarized8'                                                     " solarized colorscheme for true-color terminals
Plug 'christoomey/vim-tmux-navigator'                                                " hjkl between vim split and tmux panes

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
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=128

""" Color scheme
set termguicolors
set background=light
let g:gruvbox_contrast_light = 'soft'
colorscheme gruvbox

set number                      " Display line numbers
set numberwidth=1               " using only 1 column (and 1 space) while possible
set title                       " show title in console title bar
set wildmenu                    " Menu completion in command mode on <Tab>
set wildmode=full               " <tab> cycles between all matching choices.
set cmdheight=1                 " height of command line

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
set complete+=kspell            " available when spellcheck is on; ctrl+n in insert-mode to complete the word
set clipboard=unnamed           " yy, D, P, etc. copy to clipboard

""" Searching
set ignorecase                  " perform a case-insensitive search
set smartcase                   " use case-sensitive search if any caps used
set hlsearch                    " search highlighting
set incsearch                   " incremental search
set inccommand=nosplit          " do not show preview window while incremental search

""" Messages, Info, Status
set laststatus=2                " Always show statusline, even if only 1 window
"" don't bell or blink
set noerrorbells
set vb t_vb=

""" Windows, splits
"" Auto resize Vim splits to active split
set winwidth=104
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail
set winheight=5
set winminheight=5
set winheight=999

" ==========================================================
" Mappings (non-plugin)
" ==========================================================

" :W behaves like :w; for fat fingers
command! W :w
" Save a file as root (;W)
noremap <leader>W :w !sudo tee % > /dev/null<cr>

" Resize panes (use arrow keys)
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Switch buffers
nnoremap <leader>l :bnext<cr>
nnoremap <leader>k :bprevious<cr>
"" https://superuser.com/a/370121
nnoremap <leader>d :bprevious<bar>split<bar>bnext<bar>bdelete<cr>

" ==========================================================
" Settings (non-plugin)
" ==========================================================

autocmd BufReadPost *gitlocal set filetype=gitconfig

""" Change local filetype settings (keep alphabetically arranged by file type)
autocmd FileType gitcommit setlocal spell spelllang=en_us synmaxcol=0
autocmd FileType gitconfig setlocal ts=8 sts=8 sw=8
autocmd FileType groovy setlocal ts=3 sts=3 sw=3 expandtab
autocmd FileType java setlocal ts=3 sts=3 sw=3 textwidth=120
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType python setlocal spell spelllang=en_us
autocmd FileType rst setlocal spell spelllang=en_us
autocmd FileType text setlocal spell spelllang=en_us
autocmd FileType xml setlocal ts=3 sts=3 sw=3 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 tw=79 expandtab

" Save buffer when text is changed
autocmd InsertLeave * silent write

" ==========================================================
" Custom Functions
" ==========================================================

" Remove trailing whitespace
" Remove unwanted spaces
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<cr>
        normal `z
        retab
    endif
endfunction

function! ToggleNERDTreeFind()
    if g:NERDTree.IsOpen()
        execute ':NERDTreeClose'
    else
        " Use NERDTreeToggle when current filename is empty
        if (expand("%:t") != '')
            execute ':NERDTreeFind'
        else
            execute ':NERDTreeToggle'
        endif
    endif
endfunction

" ==========================================================
" Plugin Settings
" ==========================================================

""" ale
let g:ale_python_flake8_options = "--max-line-length=99"

""" black
let g:black_linelength = 99

""" fzf.vim
"" disable statusline overwriting
let g:fzf_nvim_statusline = 0
"" ctrl+p opens fuzzy search for files
nnoremap <c-p> :Files<cr>
nnoremap <leader>p :Files!<cr>
"" ctrl+a opens fuzzy search for buffers
nnoremap <c-a> :Buffers<cr>
"" [[B]Commits] to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"" use ;o to search under the cursor
nnoremap <leader>o :Rg <C-R><C-W><CR>
"" when fzf starts in a terminal buffer, hide the statusline of the containing buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
"" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
"" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \                    <bang>0 ? fzf#vim#with_preview('up:60%')
  \                            : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                    <bang>0)
"" Customize fzf colors to match your color scheme
let g:fzf_colors =
    \ { 'border': ['fg', 'Normal'] }

""" neoformat
"" add yaml formatter using ruamel.yaml
let g:neoformat_yaml_ruamel = {
    \ 'exe': 'python3',
    \ 'args': [ '~/.config/nvim/utils/format_yaml.py' ],
    \ 'stdin': 1,
    \ }
let g:neoformat_enabled_yaml = ['ruamel']

""" NERDTree
"" open a NERDTree automatically when vim starts up
" autocmd VimEnter * NERDTree
"" move the cursor to the file editing area and not nerdtree
" autocmd VimEnter * wincmd p
"" open a nerdtree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if (argc() == 0 && !exists("s:std_in")) |  execute 'NERDTree' | endif
"" use ;n to open nerdtree
map <leader>n :call ToggleNERDTreeFind()<CR>
"" close vim if nerdtree is the only window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

""" tagbar
"" open Tagbar with ;t
nnoremap <leader>t :TagbarToggle<CR>

""" tmuxline
""
let g:tmuxline_powerline_separators = 0

""" vim-airline
"" automatically populate the g:airline_symbols dictionary with the powerline symbols
let g:airline_powerline_fonts = 1
"" set the theme for airline
let g:airline_theme='gruvbox'
"" automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1
" disable tmuxline extention for airline; we load our own tmux statusbar config
let g:airline#extensions#tmuxline#enabled = 0

""" vim-easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""" vim-go
"" go lint
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
" automatically run `golint` on `:w`
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

""" coc.nvim
let g:coc_global_extensions = [
    \ 'coc-java',
    \ 'coc-json',
    \ 'coc-python',
    \ 'coc-yaml',
    \ ]

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" GoTo code navigation.
nmap <buffer> <leader>m <Plug>(coc-definition)
nmap <buffer> <leader>gy <Plug>(coc-type-definition)
nmap <buffer> <leader>gi <Plug>(coc-implementation)
nmap <buffer> <leader>r <Plug>(coc-references)

" Add `:OR` command for organize imports of the current buffer.
nnoremap <leader>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
