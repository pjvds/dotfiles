call plug#begin()
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'ryanoasis/vim-devicons'
" makes it easier to find and replace though multiple files
Plug 'brooth/far.vim'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/vim-goimports'
Plug 'antoinemadec/coc-fzf'
Plug 'jparise/vim-graphql'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tenfyzhong/reftools.vim'
" adds smooth scrolling
Plug 'yuttie/comfortable-motion.vim'
Plug 'justinmk/vim-sneak'
Plug 'miyakogi/conoline.vim'
Plug 'mattn/vim-goimpl'
Plug 'tpope/vim-sleuth'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'puremourning/vimspector'
Plug 'night-runner/nightrunner.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/lsp-status.nvim'
call plug#end()
