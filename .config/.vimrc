syntax on
set number
set clipboard=unnamed,unnamedplus
set pastetoggle=<leader>p
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set ignorecase
set smartcase
set incsearch
set hlsearch
set wildmenu

let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>f :find 

" Quick escape
inoremap jk <ESC>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Quick save/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

call plug#begin()

" Essential for your workflow
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Language support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'ekalinin/Dockerfile.vim'
Plug 'stephpy/vim-yaml'

call plug#end()

" Fuzzy file finder
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>

" File tree
nnoremap <leader>t :NERDTreeToggle<CR>

" Git integration with vim-gitgutter
nnoremap <leader>gh :GitGutterToggle<CR>
nnoremap <leader>gp :GitGutterPreviewHunk<CR>
nnoremap <leader>gu :GitGutterUndoHunk<CR>

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gl :Git log --oneline<CR>


" YAML indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab

" JSON formatting
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab

" Go specific
autocmd FileType go setlocal ts=4 sts=4 sw=4 noexpandtab
