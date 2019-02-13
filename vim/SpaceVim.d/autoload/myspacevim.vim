func! myspacevim#before() abort
    " use jj as escape to exit insert mode
    inoremap jj <Esc>
    let g:auto_save = 1

    " use ss in insert or normal mode to save
    noremap ss :w<CR>

    " use ss in insert or normal mode to save
    noremap sq :wq<CR>

    " use ss in insert or normal mode to save
    noremap qq :q<CR>

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

let g:netrw_dirhistmax = 0
endf
