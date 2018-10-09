" General {{{
"fold vimrc itself by categories
augroup vimrcFold
  autocmd!
  autocmd FileType vim set foldmethod=marker
  autocmd FileType vim set foldlevel=0
augroup END

"use indentation for folds
set foldmethod=indent
set foldnestmax=5
set foldlevelstart=99
set foldcolumn=0

set history=700 "how many lines of historry to remember
set autoread "auto read when file is changed from outside
filetype on "detect file type

set tm=2000 "leader key timeout

set formatprg=par "use par for prettier line formatting
let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'

set laststatus=2 "always show the status line

"saner window split
set splitbelow
set splitright

set relativenumber number

"turn off backup
set nobackup
set nowb
set noswapfile

"source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost init.vim source $MYVIMRC
augroup END
" }}}

" vim-plug {{{
set nocompatible
call plug#begin('~/.config/nvim/bundle')

"support bundles
Plug 'jgdavey/tslime.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'ervandew/supertab'
Plug 'neomake/neomake'
Plug 'moll/vim-bbye'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-scripts/gitignore'

"git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"bars, panels, and files
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'

"text manipulation
Plug 'vim-scripts/Align'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-commentary'
Plug 'michaeljsmith/vim-indent-object'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"tmux
Plug 'christoomey/vim-tmux-navigator'

"app
Plug 'vimwiki/vimwiki'

"themes
Plug 'vim-airline/vim-airline-themes'
Plug 'mhartington/oceanic-next'
Plug 'NLKNguyen/papercolor-theme'
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'dracula/vim', { 'as': 'dracula' }

"FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"json
Plug 'elzr/vim-json'

"ansible
Plug 'pearofducks/ansible-vim'

"highlight and snip for Dockerfile
Plug 'ekalinin/Dockerfile.vim'

"scala
Plug 'derekwyatt/vim-scala'

"autoformat
Plug 'Chiel92/vim-autoformat'

"haskell
Plug 'neovimhaskell/haskell-vim'

"go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()
" }}}

" VIM user interface {{{
set so=7 "keep cursor center when j/k

"tab-completion files for command line
set wildmenu
set wildmode=list:longest,full

"show current position
set ruler
set number

"show only interesting trailing whitespace
set list
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

set cmdheight=1 "height of the command bar

set backspace=eol,start,indent "configure backspace so it acts as it should act
set whichwrap+=<,>,h,l "wrap line works correctly"

"searching
set ignorecase
set smartcase
set hlsearch
set incsearch

set magic "for regular expression
set showmatch "show matching brackets when text indicator is over them
set mat=2 "how many tenths of a second to blink when matching brackets

"no annoying sound on errors
set noerrorbells
set vb t_vb=

"disable Background Color Erase inside 256-color term
if &term =~ '256color'
  set t_ut=
endif

set mouse=a "default to mouse mode on
" }}}

" Keymap {{{
let g:mapleader = "\<Space>"
nnoremap Q <nop>
map q <nop>
noremap <leader>w :w<cr>
noremap <leader>q :q<cr>
nnoremap j gj
nnoremap k gk
nnoremap <leader>bp :bp<cr>
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bo <c-w>o
noremap <leader>bd :Bd<cr>

"copy and paste to os clipboard
"plus means desktop clipboard, not the primary one used by middle click
set clipboard=unnamedplus

"slime - send text to Tmux
vmap <silent> <Leader>rs <Plug>SendSelectionToTmux
nmap <silent> <Leader>rs <Plug>NormalModeSendToTmux
nmap <silent> <Leader>rv <Plug>SetTmuxVars

"disable highlight when <leader><cr> is pressed but preserve cursor coloring
nmap <silent> <leader><cr> :noh\|hi Cursor guibg=red<cr>

"redraw
map <silent> <leader>r :redraw!<CR>

"search by selection
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

"show undo tree
nmap <silent> <leader>u :MundoToggle<CR>
" }}}

" Themes {{{
set termguicolors
set background=dark
colorscheme dracula

"adjust signscolumn
hi! link SignColumn LineNr

"pleasant but very visible search hilighting
hi Search ctermfg=white ctermbg=173 cterm=none guifg=#ffffff guibg=#e5786d gui=none
hi! link Visual Search

"colors in nerd tree
hi Directory guifg=#8ac6f2

"searing red very visible cursor
hi Cursor guibg=red

" Use Unix as the standard file type
set ffs=unix,dos,mac

" airline
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
" }}}

" Text, tab and indent related {{{
set expandtab "use spaces instead of tabs
set smarttab
set shiftwidth=2
set tabstop=2
set lbr "linebreak on 500 characters
set tw=500
set ai "auto indent
set si "smart indent
set wrap "wrap lines

"delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

augroup whitespace
  autocmd!
  autocmd BufWrite *.hs :call DeleteTrailingWS()
augroup END
" }}}

" Moving around {{{
"return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
set viminfo^=% "remember info about open buffers on close
set hidden "don't close buffers when you aren't displaying them

"quicklist
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

"move between windows
noremap <C-h> <c-w>h
noremap <C-k> <c-w>k
noremap <C-j> <c-w>j
noremap <C-l> <c-w>l

"create windows
nmap <leader>sh :leftabove  vnew<CR>
nmap <leader>sl :rightbelow vnew<CR>
nmap <leader>sk :leftabove  new<CR>
nmap <leader>sj :rightbelow new<CR>

"navigate tmux
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

"terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-j> <C-\><C-n><C-w>j
tnoremap <c-k> <C-\><C-n><C-w>k
tnoremap <c-l> <C-\><C-n><C-w>l
" }}}

" Helper functions {{{

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.' . a:extra_filter)
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" }}}

" NERDTree {{{
let NERDTreeQuitOnOpen = 1 "close nerdtree after a file is selected

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
    exec ':NERDTreeFind'
  endif
endfunction

"if nerdtree is closed, find current file, if open, close it
nmap <silent> <leader>f <ESC>:call ToggleFindNerd()<CR>
nmap <silent> <leader>F <ESC>:NERDTreeToggle<CR>
" }}}

" Git {{{

let g:extradite_width = 60
" Hide messy Ggrep output and copen automatically
function! NonintrusiveGitGrep(term)
  execute "copen"
  " Map 't' to open selected item in new tab
  execute "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
  execute "silent! Ggrep " . a:term
  execute "redraw!"
endfunction

command! -nargs=1 GGrep call NonintrusiveGitGrep(<q-args>)
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :copen<CR>:GGrep 
nmap <leader>gl :Extradite!<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>

function! CommittedFiles()
  " Clear quickfix list
  let qf_list = []
  " Find files committed in HEAD
  let git_output = system("git diff-tree --no-commit-id --name-only -r HEAD\n")
  for committed_file in split(git_output, "\n")
    let qf_item = {'filename': committed_file}
    call add(qf_list, qf_item)
  endfor
  " Fill quickfix list with them
  call setqflist(qf_list)
endfunction

" Show list of last-committed files
nnoremap <silent> <leader>g? :call CommittedFiles()<CR>:copen<CR>

" }}}

" go {{{

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

"highlighting
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

let g:go_list_type = "quickfix"
let g:go_metalinter_autosave = 1
" }}}

" FZF {{{
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

noremap <leader>bb :History<cr>
noremap <leader>p :Files<cr>
noremap <leader>/ :Ag<Space>
noremap <leader>e :GFiles<cr>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" }}}

" Python {{{
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python'
let g:jedi#use_splits_not_buffers = "right"
" }}}

" Scala {{{
autocmd BufNewFile,BufRead *.sc set syntax=scala

let g:formatdef_scalafmt = "'scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']
" }}}

" vimwiki {{{
let g:vimwiki_list = [{'path': '~/shinsekai/vimwiki'}]
let g:nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'scala': 'scala'}
" }}}
