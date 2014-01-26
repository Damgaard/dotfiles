" Vim Configuration file for
"
" Andreas Damgaard Pedersen
"
" --------------------------
"
" Inspiration taken from
" - https://github.com/dougblack/dotfiles/blob/master/.vimrc
" - https://github.com/spladug/dotfiles/blob/master/.vimrc
"
" And others, whose great dotfiles I've unfortunately forgotten to write down.

" General Settings {{{
" ####################

" No need to be compatible with ancient software
set nocompatible

let mapleader=","

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/vimfiles/bundle directory
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

" use utf8
set encoding=utf-8

" Activate mouse
set mouse=a

" No sound thank you very much
set vb

" Fast terminal, give me a smooth graphical experience
set ttyfast

" Pasting is good
set paste

" Only Check final line for file-specific settings
set modelines=1

" }}}
" Visual {{{
" ##########

colorscheme torte

" Show what mode we are in
set showmode
set showcmd
set laststatus=2

" Show the line we're currently on
set cursorline

" Allows vim to handle multiple buffers at the same time
set hidden

" Visual autocomplete for command menu
set wildmenu

" Redraw only when we need to
" Vim loves to redraw the screen during things it probably doesn't need to—like
" in the middle of macros. This tells Vim not to bother redrawing during these
" scenarios, leading to faster macros.
" - http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" Add line number on left side.
set number

" Show current git branch in statusline.
set statusline=%{fugitive#statusline()}

" Keep more lines visible while scrolling down
set scrolloff=5

" }}}
" Spelling {{{
" ############

" set spell
nmap <silent> <leader>s :set spell!<CR>

" }}}
" Search {{{
" ##########

" Make search/replace global by default
set gdefault

" Case-smart search
set ignorecase
set smartcase

" Highlight matching searches as they are found
set incsearch
set hlsearch

" ,m to turn off search highlighting
nmap <silent> <leader>m :silent :nohlsearch<CR>

" Lets remember more than the last 20 search/commands
set history=1000

" Disable vim's regex for search
" Not sure if I really what this.
nnoremap / /\v
vnoremap / /\v

" Standard tab settings
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

" Persistent undo
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer relod
set noswapfile



" keep visual selection after indenting
vmap > >gv
vmap < <gv

nmap <silent> <leader>u :!python setup.py test<CR>

" Control enter now adds a newline
map <C-Enter> i<Enter><ESC>

" Allow % to swap between if/else/then, xml tags and more
" in addition to ()
runtime macros/matchit.vim

" }}}
" Navigation {{{
" ##############

" Faster go to tab left of current. Holding shift is really inconvenient
nnoremap gr gT

" For easier movement between windows in split screen
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Move by lines as seen in editor rather than as in file
map j gj
map k k

" Disable arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable Ex mode
map Q <NOP>

" Disable K doing man lookups
map Q <NOP>

" Set cursor to the position it had when file was closed
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Enable backspace
nnoremap <bs> hx
set backspace=start,indent,eol

" }}}
" Language Specific {{{
" #####################

" Correct auto-indentation for C and Python
set cindent

" Set colourcolumn for python (PEP8) and reStructed text files which are
" mainly used for documenting python projects.
autocmd BufNewFile,BufRead *.py,*.rst setlocal colorcolumn=80

" For easy reformatting of lines within the correct number of lines.
" Use gq on a visual selected number of lines
autocmd BufNewFile,BufRead *.py setlocal tw=79

" Use <leader>c to save and compile various types of documents
autocmd FileType tex map <buffer> <leader>c :w<CR>:!xelatex -shell-escape %<CR>
autocmd FileType rst map <buffer> <leader>c :w<CR>:!rst2pdf %<CR>

" }}}
" Quality of Life {{{
" ###################

" Common mistyping, saves rage
nnoremap ; :

" Stupid shift key fixes
cmap W w
cmap Wq wq
cmap WQ wq
cmap wQ wq
cmap Q q
cmap Tabnew tabnew

" Autofix simple typos
iabbrev teh the
iabbrev Teh The
iabbrev wiht with

" Highligt extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" }}}
" Plugin Configuration {{{
" ########################

let g:pymode_rope = 0

" quickly edit/reload the .vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Allow collapsing of code
set foldmethod=indent
set foldlevel=99
" Remap space to open/close folds. This is mainly to try and encourge myself
" to use folds more.
nnoremap <space> za

" Standard save method. Simpler and shorter
map <c-s> :w<CR>

" Add Omnicomplete for Python Code
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

map <leader>g :GundoToggle<CR>
map <leader>td <Plug>TaskList
map <leader>b :NERDTreeToggle<CR>
map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

" Ignore these files when searching for files, such as with tabnew
:set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*~,*.png,*.PNG,*.jpg,*.JPG,*.gif,*.GIF,*.hi,*.pdf,*.aux

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt) & Ben Orenstein
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Python-Mode
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Skip too high complexity erros.
" This is done as refactoring them out is very timeconsuming. So when working
" on libraries with several classes that exceed the recommended complexity,
" these errors will obscure easily fixed errors such as unused variables.
" Use radon instead to detect these errors when needed.
let g:pymode_lint_ignore = "C901"

" VIM-LATEX
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

" }}}
" Enable local settings {{{
" #########################

" Load Custom per-directory vim configuration.
" All credit to this SO answer http://stackoverflow.com/a/1889646/1368070
if filereadable(".vim.custom")
    so .vim.custom
endif

" }}}

" vim:foldmethod=marker:foldlevel=0
