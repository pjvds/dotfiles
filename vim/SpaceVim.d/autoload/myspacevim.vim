func! myspacevim#before() abort
    " use jj as escape to exit insert mode
    inoremap jj <Esc>
    let g:auto_save = 1
  endf
