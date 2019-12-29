func! myspacevim#before() abort
    let base16colorspace=256

    " live update of substitution
    set inccommand=nosplit
    
    " scroll n lines before end
    set scroll=5

    " use jj as escape to exit insert mode
    inoremap jj <Esc>
    "
    " use jsq to save and quit from insert modjsqe
    inoremap jsq <Esc>:wq

    " use ss in insert or normal mode to save
    noremap ss :w<CR>

    " use ss in insert or normal mode to save
    noremap sq :wq<CR>

    " use ss in insert or normal mode to save
    noremap qq :q<CR>

    nnoremap ; :
    nnoremap : ;

    nnoremap <Leader>j :GoDeclsDir<CR>

    " no linters for go
    let g:go_metalinter_enabled=0

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

    " Use the stdio version of OmniSharp-roslyn
    let g:OmniSharp_server_stdio = 1
endf
