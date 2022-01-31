" Shoutout to Dom, who got me started on this

" set nocompatible
filetype off
set fileformats=unix,dos

" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle..."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	let iCanHazVundle=0
endif

"" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
"
"" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'jiangmiao/auto-pairs'
" Plugin 'rust-lang/rust'
" also will need ctags
Plugin 'vim-syntastic/syntastic'
Plugin 'itchyny/lightline.vim'
Plugin 'kshenoy/vim-signature'
Plugin 'majutsushi/tagbar'
Plugin 'kien/tabman.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'preservim/nerdtree'
call vundle#end()			" required
filetype plugin indent on	" required
"" To ignore plugin indent changes, instead use:
"" filetype plugin on

if !iCanHazVundle
	echo "Installing Bundles, please ignore key map error messages"
	echo ""
	:BundleInstall
endif

let g:gitgutter_sign_column_always = 1

" always show statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%F\ %l\:%c
set laststatus=2

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_w = 1

"Set syntax on
syntax on

if has('persistent_undo')
	set undofile
	set undodir=$HOME/.vim/undo
endif

let g:yankring_history_dir='$HOME/.vim/yank'

let g:lightline = { 'colorscheme' : 'deus' }

" let g:tagbar_ctags_bin = '~/.vim/bundle/ctags/ctags'

ca WQA wqa
ca WQa wqa
ca Wqa wqa
ca qwa wqa
ca WQ wq
ca Wq wq
ca QW wq
ca Qw wq
ca qw wq
ca WA wa
ca Wa wa
ca AW wa
ca Aw wa
ca aw wa
ca QA qa
ca Qa qa
ca AQ qa
ca Aq qa
ca aq qa
ca W w
ca Q q
ca w!! w !sudo tee %
ca delma delm!
ca delmall delm! | delm A-Z0-9
ca SP sp
ca Sp sp
ca sP sp
ca nnn noh

" Indent automatically depending on filetype
" filetype indent on
set backspace=2

set lazyredraw

set autoindent

set ruler

set number

set showmatch

set ignorecase

set smartcase

"set foldmethod=manual
nnoremap <Space> zA

" Wrap text instead of being on one line
set linebreak

" see `:help fo-table` for explanations
set formatoptions=tcrq

" Change colorscheme from default
colorscheme vpurpura

set t_Co=256

set incsearch

set hlsearch

set background=dark

set mouse=a

set tabstop=4

set noexpandtab

set shiftwidth=0

set softtabstop=0

set smarttab

set showcmd

set noshowmode

set shortmess=at

" yank what's under a visual block
vnoremap // y/<C-R>"<CR>

" append and prepend visual block with single/double quotes
vnoremap qq <Esc>`>a'<Esc>`<i'<Esc>
vnoremap QQ <Esc>`>a"<Esc>`<i"<Esc>

nnoremap <C-j> :m+<CR>
nnoremap <C-k> :m-2<CR>
" vnoremap <C-j> :m+<CR>gv=gv TODO
vnoremap <C-k> :m-2<CR>gv=gv TODO

function! Tab_Or_Complete()
	if col('.')>1 && strpart( getline('.'), col('.')-2, 3) =~ '^\w'
		return "\<C-N>"
	else
		return "\<Tab>"
	endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

set dictionary="/usr/dict/words"

set list
set listchars=tab:>-

"Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" reopen file to last line that cursor was on instead of opening to the top
" every time
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

nnoremap <S-Tab> :SyntasticReset<CR>
nnoremap <F9> :TMToggle<CR>
nnoremap <F10> :YRShow<CR>
nnoremap <F11> :TagbarToggle<CR>
"<shift+i> for hidden files
nnoremap <F12> :NERDTreeToggle<CR>

" auto set screen/tmux title to be current file
autocmd BufEnter * let &titlestring = "vim: " . expand("%:t")
set title
set t_ts=k
set t_fs=\
" set title after exiting
if expand("%:p:h") == expand("$HOME")
	let &titleold = "~"
elseif expand("%:p:h") == "/"
	let &titleold = "/"
else
	let &titleold = expand("%:p:h:t")
endif

" attempt to restrict length of git commit messages
if expand("%:t") == "COMMIT_EDITMSG"
	set colorcolumn=72
endif

" let g:ctrlp_map = '<c-p>'
" let g:strlp_by_filename = 1
" let g:ctrlp_cmd = 'CtrlP'

" highlight excess whitespace
match ExtraWhiteSpace /\s\+$/
autocmd BufWinEnter * match ExtraWhiteSpace /\s\+$/
autocmd InsertEnter * match ExtraWhiteSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" search and replace in a visual block
" after highlighting text, type the following in normal mode:
" :%s/\%V<search>/<replace>/g
