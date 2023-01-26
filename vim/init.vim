set termguicolors
let g:conoline_auto_enable = 1

source $DOTFILES/vim/plugins.vim
source $DOTFILES/vim/coc.vim
source $DOTFILES/vim/keymap.vim
let loaded_netrwPlugin = 1

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-go', 'CodeLLDB', 'vscode-node-debug2' ]

" General options
let g:presence_auto_update         = 1
let g:presence_neovim_image_text   = "How do I quit?"
let g:presence_main_image          = "neovim"
let g:presence_blacklist           = []
let g:presence_buttons             = 0
let g:presence_file_assets         = {}

" Rich Presence text options
let g:presence_editing_text        = "Coding"
let g:presence_file_explorer_text  = "Searching"
let g:presence_git_commit_text     = "Committing"
let g:presence_plugin_manager_text = "Configuring"
let g:presence_reading_text        = "Coding"
let g:presence_workspace_text      = "How do I quit this?"
let g:presence_line_number_text    = "Line"

set noswapfile

set undofile " persistent undo for the win!
set undodir=~/.vim/undo

let mapleader="'"
set list
"let g:sneak#label = 1
" The width of a hard tabstop measured in "spaces" -- effectively the (maximum) width of an actual tab character.
set tabstop=2
set shiftwidth=2
set softtabstop=0
set smarttab

" Hide the status bar
set laststatus=2

" Open files browser if VIM is opened without a specific file
"au VimEnter * if (@% == "") | execute ':Files' | endif

" search and replace selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

set scroll=5

" Search workspace symbols.
noremap <silent><nowait> <leader>T :<C-u>CocFzfList outline<cr>
noremap <silent><nowait> <leader>t :<C-u>CocFzfList symbols<CR>
nnoremap <silent><nowait> <leader>j  :call CocAction('diagnosticNext')<CR>
nnoremap <silent><nowait> <leader>k  :call CocAction('diagnosticPrevious')<CR>
nnoremap <silent><leader>r :<C-u>call CocAction('jumpReferences')<CR>
au FileType go nmap <leader>s <plug>(reftools#fillstruct)
au FileType go imap <leader>s <ESC><plug>(reftools#fillstruct)
noremap <silent><nowait> <leader>f :Rg<CR>
noremap <silent><nowait> <leader>l :BLines<CR>
map <leader>s <Plug>Sneak_s

" TextEdit might fail if hidden is not set.
set hidden

" use ctrl-c to copy to clipboard register in visual mode
vnoremap <C-c> "+y

noremap <silent><nowait> <leader>e :CocCommand explorer --preset floating<CR>

let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

let g:lightline={
	\ 'colorscheme': 'NightRunner',
	\ }

let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ ".*coc.*" ]
let g:rainbow_active = 1

let test#strategy = "neovim"

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

noremap <silent> gd :call <SID>GoToDefinition()<CR>
noremap <silent> gy <Plug>(coc-type-definition)
noremap <silent> gi <Plug>(coc-implementation)
noremap <silent> gr <Plug>(coc-references)
noremap <silent> <leader>h :noh<CR>

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" When 'ignorecase' and 'smartcase' are both on, if a pattern contains an uppercase letter, it is case sensitive, otherwise, it is not. For example, /The would find only 'The', while /the would find 'the' or 'The' etc.
set ignorecase
set smartcase

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" expand selection in visual mode
xmap v <Plug>(expand_region_expand)
xmap V <Plug>(expand_region_shrink)

noremap <leader>p :Files<CR>

"
" buffers, windows and tabs
"
" fuzzy search windows
nmap <leader>w Windows

" fuzzy search buffers
nmap <leader>b Buffers

" highlight all matches while incremental searching
setglobal incsearch

"set signcolumn=number
set scl=no
set number relativenumber
" open files in previous window (4)
let g:netrw_browse_split = 4


let g:dracula_colorterm = 0
colorscheme NightRunner

" decreate gitgutter update time
set updatetime=0

let g:coc_explorer_global_presets = {
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }


nmap <leader>a <Plug>(coc-codeaction)
vmap <leader>a <Plug>(coc-codeaction-selected)

" define prettier command
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

"autocmd VimEnter * call SetupLightlineColors()
"function SetupLightlineColors() abort
"	let l:palette = lightline#palette()
"	let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
"	let l:palette.inactive.middle = l:palette.normal.middle
"	let l:palette.tabline.middle = l:palette.normal.middle
"
"	call lightline#colorscheme()
"endfunction
"
luafile ~/.config/nvim/myline.lua

let g:conoline_color_normal_dark = 'guibg=#000000 ctermbg=black'
let g:conoline_color_normal_nr_dark = 'guibg=#000000 ctermbg=black'

" prefix line breaks
let &showbreak = '↳ '
set wrap
set cpo=n

" -------------------- vim sneak   ---------------------------------
lua <<EOF
vim.g["sneak#use_ic_scs"] = 1
EOF
" -------------------- vim sneak   ---------------------------------

" -------------------- TREESITTTER ---------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
}
EOF
" -------------------- LSP ---------------------------------

" -------------------- LSP ---------------------------------
:lua << EOF
  local nvim_lsp = require('lspconfig')

  local servers = {'gopls'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

" Completion
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" -------------------- LSP ---------------------------------
