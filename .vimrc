syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set undodir=~/.vim/undodir
set undofile
set incsearch
set clipboard=unnamedplus
set ts=4 sw=4
set showmatch
set ruler
set smarttab

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Plugin Installation via Plug
call plug#begin('~/.vim/plugged')

" List of Plugins to install
Plug 'nvie/vim-flake8'
Plug 'andrewstuart/vim-kubernetes'
Plug 'hashivim/vim-terraform'
Plug 'stephpy/vim-yaml'
Plug 'b4b4r07/vim-hcl'
Plug 'romainl/vim-dichromatic'
Plug 'mbbill/undotree'
call plug#end()

colorscheme dichromatic

let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_banner = 0
let g:netrw_winsize=25

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>
