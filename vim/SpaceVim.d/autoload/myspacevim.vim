func! myspacevim#before() abort
    " use jj as escape to exit insert mode
    inoremap jj <Esc>
    let g:auto_save = 1

    " use ss in insert or normal mode to save
    noremap ss :w<CR>
endf
