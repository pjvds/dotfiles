func! myspacevim#before() abort
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

    au FileType go nmap <leader>t :FzfTags<CR>
    
    " Start vim commit message in insert mode
    autocmd FileType gitcommit exec 'au VimEnter * startinsert'

    " This instructs deoplete to use omni completion for Go files.
    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
endf
