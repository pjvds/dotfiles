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

    " disable network history
    let g:netrw_dirhistmax = 0

    " run 'yarn global add standard prettier-standard babel-eslint eslint eslint-plugin-prettier' for this
    let g:ale_linters = {
              \   'javascript': ['standard'],
              \}
    let g:ale_fixers = {'javascript': ['prettier-standard']}
    let g:ale_list_window_size = 10
    let g:jsx_ext_required = 0 " Allow JSX in normal JS files
    let g:ale_completion_enabled = 1
    let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
endf

func! myspacevim#after() abort
    let base16colorspace=256
endf
