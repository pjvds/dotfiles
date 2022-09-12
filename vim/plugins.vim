call plug#begin()
Plug 'night-runner/nightrunner.vim'

" Adds Discord presence to VIM
Plug 'andweeb/presence.nvim'

" Adds support for Debug Adapter Protocol, in short: debugging support
Plug 'mfussenegger/nvim-dap'

" Nice UI to support a debugging session
Plug 'rcarriga/nvim-dap-ui'

" Debug jest (nodejs) tests
Plug 'David-Kunz/jester'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'tpope/vim-sleuth'

"Plug 'OmniSharp/omnisharp-vim'

Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

Plug 'ryanoasis/vim-devicons'

" makes it easier to find and replace though multiple files
"Plug 'brooth/far.vim'
Plug 'leafgarland/typescript-vim'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'mattn/vim-goimports'
"Plug 'antoinemadec/coc-fzf'
"Plug 'jeffkreeftmeijer/vim-numbertoggle'
"Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf.vim'
"Plug 'airblade/vim-gitgutter'
Plug 'tenfyzhong/reftools.vim'
" adds smooth scrolling
Plug 'yuttie/comfortable-motion.vim'
Plug 'justinmk/vim-sneak'
"Plug 'miyakogi/conoline.vim'
Plug 'mattn/vim-goimpl'
"Plug 'tpope/vim-sleuth'
"Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
"Plug 'puremourning/vimspector'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/lsp-status.nvim'
call plug#end()
