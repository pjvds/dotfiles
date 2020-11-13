func! myspacevim#before() abort
    let g:spacevim_disabled_plugins = ['vim-startify']
    au VimEnter * if (@% == "") | execute ':FzfFiles' | endif

    filetype plugin on
    set omnifunc=syntaxcomplete#Complete

    let g:mapleader = "'"

    let base16colorspace=256

    let g:airline_theme='dracula'

    " live update of substitution
    set inccommand=nosplit
    
    " keep n lines below and above the cursor
    set scroll=5

    " disable network history
    let g:netrw_dirhistmax = 0

    " Override default ignore pattern in file tree to still
    " show other . files
    set completeopt+=noselect

    " This instructs deoplete to use omni completion for Go files.
    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })


    let g:ctrlp_buftag_types = { 'go' : '--language-force=go --go-types=d' }

    "autocmd FileType startify exec ':FzfFiles'
    "autocmd! User Startified echomsg "First"
    "
    autocmd User Startified execute ':FzfFiles'
    "autocmd FocusGained * execute ':FzfFiles'
    "autocmd BufNewFile,BufRead * execute ':FzfFiles'
    

    "let g:tagbar_type_go = {
    "\ 'ctagstype' : 'go',
    "\ 'kinds'     : [
    "  \ 'p:package',
    "  \ 'i:imports:1',
    "  \ 'c:constants',
    "  \ 'v:variables',
    "  \ 't:types',
    "  \ 'n:interfaces',
    "  \ 'w:fields',
    "  \ 'e:embedded',
    "  \ 'm:methods',
    "  \ 'r:constructor',
    "  \ 'f:functions'
    "\ ],
    "\ 'sro' : '.',
    "\ 'kind2scope' : {
    "  \ 't' : 'ctype',
    "  \ 'n' : 'ntype'
    "\ },
    "\ 'scope2kind' : {
    "  \ 'ctype' : 't',
    "  \ 'ntype' : 'n'
    "\ },
    "\ 'ctagsbin'  : 'gotags',
    "\ 'ctagsargs' : '-sort -silent'
  \ "}


endf

func! myspacevim#after() abort
    " lessen shift key wear :)
    noremap ; :

    " use jj as escape to exit insert mode
    inoremap jj <Esc>

    " use jsq to escape, save and quit from insert mode
    inoremap jsq <Esc>:wq<CR>

    " use ss in insert or normal mode to save
    noremap ss :w<CR>

    " use ss in insert or normal mode to save
    noremap sq :wq<CR>

    " use ss in insert or normal mode to save
    noremap qq :q<CR>

    " use ctrl-c to copy to clipboard register in visual mode
    vnoremap <C-c> "+y

    " disable network history
    let g:netrw_dirhistmax = 0

    " Override default ignore pattern in file tree to still
    " show other . files
    set completeopt+=noselect

    " This instructs deoplete to use omni completion for Go files.
    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })


    let g:ctrlp_buftag_types = { 'go' : '--language-force=go --go-types=d' }
    
endf

func! myspacevim#after() abort
    au FileType go nmap <leader>t :FzfTags<CR>
    
    " Start vim commit message in insert mode
    autocmd FileType gitcommit exec 'au VimEnter * startinsert'

    :FzfFiles

    " This instructs deoplete to use omni completion for Go files.
    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
      let g:deoplete#enable_at_startup = 1
  let g:deoplete#complete_method = "omnifunc"
  call deoplete#custom#option('omni_patterns', {
  \ 'go': '[^. *\t]\.\w*',
  \})

    noremap ; :
endf
