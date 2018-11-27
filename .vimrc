colorscheme badwolf
syntax enable
set tabstop=4
set softtabstop=4
set expandtab
set number
set showcmd
set cursorline
filetype indent on
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
set shiftwidth=4
execute pathogen#infect()
autocmd FileType python map <buffer> <F3> :call Flake8()<CR>
