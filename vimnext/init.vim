let mapleader="'"
au VimEnter * if (@% == "") | execute ':Files' | endif

call plug#begin()

set scroll=5
noremap ; :

" Search workspace symbols.
nmap <silent><nowait> <leader>T :<C-u>CocFzfList outline<cr>
nmap <silent><nowait> <leader>t :<C-u>CocFzfList symbols<CR>
au FileType go nmap <leader>s <plug>(reftools#fillstruct)
au FileType go imap <leader>s <ESC><plug>(reftools#fillstruct)

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
Plug 'jparise/vim-graphql'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'airblade/vim-gitgutter'

call plug#end()

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

"
" netrw: you don't need NERDtree!
"
"
" remove banner
let g:netrw_banner = 0

"
" coding
"
function! s:GoToDefinition()
  " first try to jumpDefinition with Coc
  if CocAction('jumpDefinition')
    return v:true
  endif

  " try to just with tags
  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    " searchdecl as last resort
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"
" Use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"
" searching
"
" The 'smartcase' option only applies to search patterns that you type; it
" does not apply to * or # or gd. If you press * to search for a word, you can
" make 'smartcase' apply by pressing / then up arrow then Enter (to repeat the
" search from history).
setglobal smartcase

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nmap <leader>p :Files<CR>

"
" buffers, windows and tabs
"
" fuzzy search windows
nmap <leader>w Windows

" fuzzy search buffers
nmap <leader>b Buffers

" highlight all matches while incremental searching
setglobal incsearch

set number relativenumber
" open files in previous window (4)
let g:netrw_browse_split = 4


let g:dracula_colorterm = 0
colorscheme dracula

" decreate gitgutter update time
set updatetime=100
