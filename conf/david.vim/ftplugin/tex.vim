set omnifunc=vimtex#complete#omnifunc

" tex-conceal.vim
set conceallevel=2
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

" https://vi.stackexchange.com/questions/13080/setting-tab-to-2-spaces
" On pressing tab, insert 4 spaces
setlocal expandtab
" show existing tab with 4 spaces width
setlocal tabstop=2
setlocal softtabstop=2
" when indenting with '>', use 4 spaces width
setlocal shiftwidth=2

" ALE Config
let b:ale_linters = { 'tex': ['chktex' ] }
let b:ale_fixers = { 'tex': [ 'latexindent', 'remove_trailing_lines', 'trim_whitespace'] }

" Suggestion of vimtex docs 
" To enable adding latex environments using vim-surround
let b:surround_{char2nr('e')} = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
let b:surround_{char2nr('c')} = "\\\1command: \1{\r}"


set nohlsearch
set formatoptions-=c " Don't insert bullet on auto-wrap
set spell


" We're taking notes here, stop fussing over quotes chktex
" error code 18 found form http://www.nongnu.org/chktex/ChkTeX.pdf
" 45 is not using $$
let b:ale_tex_chktex_options = '-n 18' . ' -n 45'

" Don't stress about enclosing parens within curlies either
let b:ale_tex_chktex_options .= ' -n 3'

let b:ale_tex_chktex_options .= ' -n 13' " Enter sentence spacing.

let b:ale_tex_latexindent_options  = '-m'

let b:ale_fix_on_save = 1
