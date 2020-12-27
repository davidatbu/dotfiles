call plug#begin()
Plug 'lifepillar/vim-mucomplete'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'SirVer/ultisnips'

" Avoid loading most plugins if we're on a temporary  file (which is the case when 
" bash launches my $EDITOR to edit my commands, which I often do), for speed purposes. 
let s:temp_file_ptrn = '\v^/(tmp|scratch)/.*'
let s:NOT_IN_TEMP_FILE =  !(expand('%') =~ s:temp_file_ptrn)

if (s:NOT_IN_TEMP_FILE)
    Plug 'embear/vim-localvimrc'

    " Python
    Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
    Plug 'bfredl/nvim-ipy', { 'for': ['python'] }
    Plug 'jeetsukumaran/vim-pythonsense', { 'for': ['python'] }
    Plug '$HOME/git/ale'
    Plug 'Shougo/echodoc'
    Plug 'vim-test/vim-test'
    Plug 'tartansandal/vim-compiler-pytest'

    " Frontend
    Plug 'pangloss/vim-javascript', {'for': ['javascript'] }
    Plug 'AndrewRadev/tagalong.vim', {'for': ['html'] }
    Plug 'mattn/emmet-vim', { 'for': ['html'] }

    " Markdown/writing
    Plug 'godlygeek/tabular', { 'for': ['markdown'] }
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
    Plug 'iamcco/markdown-preview.nvim', {
                \ 'for': ['markdown'],
                \ 'do': { -> mkdp#util#install() },
                \ }
    Plug 'dkarter/bullets.vim',  { 'for': ['markdown', 'vimwiki'] }

    " Tpope makes great plugins.
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-dispatch'
    

    " Colors and other niceties
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/goyo.vim'

    " Tex, writing
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'KeitaNakamura/tex-conceal.vim', { 'for': 'tex' }

    " Fuzzy find buffers, command and search history, ... etc
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " My own touches
    Plug '$HOME/git/dotfiles/conf/david.vim'
else
    echomsg 'Tmp file: not loading some plugins'
endif
call plug#end()

"" vim-test
let test#strategy = "dispatch"

"" Vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
" This should be set automatically, actually.


""" Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
let g:mkdp_open_to_the_world = 1

""" ALE Settings
" Show status using vim airline
let g:airline#extensions#ale#enabled = 1

" Only lint when I ask
let g:ale_linters_explicit=1

" Nice to know which linter is dissatisfied
let g:ale_echo_msg_format = '%linter%:%severity%:%code:%%s' 

" Show errors in virtualtext
let g:ale_virtual_text_cursor = 1
let g:ale_virtualtext_delay = 0
let g:ale_echo_cursor = 1

" Use echo for ALE errors
let g:ale_echo_cursor = 0

" Make ale less automatic
let g:ale_fix_on_save = 0
let g:ale_lint_on_enter = 0

let g:ale_hover_to_preview = 1

" Somehow, ale autoimport works with mucomplete
let g:ale_completion_enabled = 0
let g:ale_completion_delay = 0
let g:ale_completion_autoimport = 1

" Adapted from https://github.com/neovim/neovim/issues/1887#issuecomment-280653872
" Use whatever venv we're in
" if exists("$VIRTUAL_ENV")
    " let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
" else
let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
" endif

" Make ultisnips use other triggers so mucomplete can do it's thing
let g:UltiSnipsExpandTrigger = "<A-e>"        " Do not use <tab>
let g:UltiSnipsJumpForwardTrigger = "<A-f>"   " Do not use <c-j>
let g:UltiSnipsJumpBackwardTrigger = "<A-b>"

"" Mu complete
" We prefer completefunc (user) over omnifunc (omni) cuz we set
" completefunc=jedi#completions, and jedi shows docs.
" We keep ALE as omni cuz pyright does autoimport.
let g:mucomplete#chains = {
	    \ 'default' : ['path', 'omni', 'ulti'],
	    \ 'vim'     : ['path', 'omni', 'cmd', 'ulti'],
        \ 'python'     : ['path', 'user', 'omni', 'ulti'] 
	    \ }
let g:mucomplete#no_popup_mappings = 0
let g:mucomplete#enable_auto_at_startup = 1 " automatic completion(as opposed to <tab>-triggered)

"" nvim-ipy
let g:nvim_ipy_perform_mappings = 0
let g:ipy_celldef = '\v^\s*##[^#]*$' " Ipython cell boundary line regex.

" Add parenthesis to vaid filename chars for completion
set isfname+=(
set isfname+=)

" One note: lack of 'longest' is so that mucomplete doesn't insert longest
" match(especailly annoying during autocompletion)
set completeopt=menu,menuone,preview,noinsert,noselect

" From mucomplete docs
" It is also possible to expand snippets or complete text using only <tab>. That
" is, when you press <tab>, if there is a snippet keyword before the cursor then
" the snippet is expanded (and you may use <tab> also to jump between the
" snippet triggers), otherwise MUcomplete kicks in. The following configuration
" achieves this kind of behaviour:
let g:ulti_expand_or_jump_res = 0

fun! TryUltiSnips()
  if !pumvisible() " With the pop-up menu open, let Tab move down
    call UltiSnips#ExpandSnippetOrJump()
  endif
  return ''
endf

fun! TryMUcomplete()
  return g:ulti_expand_or_jump_res ? "" : "\<plug>(MUcompleteFwd)"
endf

"""" Here's my own addition, avoid automatic mapping when doing this so that
"""" I don't get the "^I is already mapped" error
let g:mucomplete#no_mappings=1
" Map for <s-tab> used to be automatically added, but not so once we
" disable with the var above.
imap <s-tab> <plug>(MUcompleteBwd) 
"""" own addition done

inoremap <plug>(TryUlti) <c-r>=TryUltiSnips()<cr>
imap <expr> <silent> <plug>(TryMU) TryMUcomplete()
imap <expr> <silent> <tab> "\<plug>(TryUlti)\<plug>(TryMU)"

"" Vimtex
let g:vimtex_quickfix_ignore_filters = [ '\v(Under|Over)full \\(h|v)box'] " Ignore some latex 'errors'
let g:vimtex_quickfix_open_on_warning=0

" Enable nvimrc as the local initialization file
let g:localvimrc_debug=1
let g:localvimrc_name=['.lnvimrc']
" Whitelist everything in home directory
" https://stackoverflow.com/a/48519356
let g:localvimrc_whitelist = [ fnamemodify('~', ':p') ]

" Disable "sandbox" mode
let g:localvimrc_sandbox=0

"" Stuff I wish was in ftplugin/, but doesn't work there.
" Jedi takes over a bunch of key mappings if I don't do this
let g:jedi#auto_initialization = 0
" Set latex filetypes as tex, not plaintex
let g:tex_flavor='latex'

let g:goyo_height=100
" Variable to keep track of Goyo state to facilitate toggling.
" Just :Goyo would toggle, except that I want to read textwidth
" dynamically (and thus do :exec Goyo &tw), which doesn't toggle.
if ! exists('s:goyo_on')
    let s:goyo_on = 0
endif
function! GoyoToggle()
    if ! s:goyo_on
        " + 3 for good measure (aka error indicators from ALE)
        execute 'Goyo ' &textwidth + 3 
        let s:goyo_on = 1
    else
        execute 'Goyo!'
        let s:goyo_on = 0
    endif
endfunction


function! s:goyo_enter()
" Make Goyo make tmux panes dissapear
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Disable indenting lines more than necessary when typing :
" This doens't work in ftplugin/python.vim or after/python.vim.
" https://stackoverflow.com/a/37889460/13664712
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:




" Automatically save views
augroup SaveViewsOnEnter
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END


" Bash
autocmd FileType sh setlocal makeprg=bash\ %

" Other vim preferences
set splitbelow
set splitright

" Enable backspace on everything
set backspace=indent,eol,start


let session_file=".Session.vim"
" https://github.com/tpope/vim-obsession/issues/17
augroup ObsessionGroup
  autocmd!
  " When opening a file, start recording the Vim session with its tabs and splits.
  " If Vim is called without arguments and there is already a session file,
  " source it and record the session.
  " Checking 'modified' avoids recording a session when reading from stdin.
  " !argc() makes sure we only source a session file if Vim was started without arguments.
  " Otherwise we would open an old session instead of opening a file when calling 'vim my_file'.
  " Calling Obsession when the session is being recorded would pause the recording,
  " that's why we check if v:this_session is empty.
  autocmd VimEnter * nested
      \ if !&modified && s:NOT_IN_TEMP_FILE |
      \   if !argc() && filereadable(session_file) |
      \   execute "source" session_file |
      \   elseif empty(v:this_session) |
      \     execute "Obsession" session_file|
      \   endif |
      \ endif
augroup END

"" Colors
" https://browntreelabs.com/base-16-shell-and-why-its-so-awsome/
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

"" Airline
" Status line theme is whatever base16 theme I am using
let g:airline_theme='base16'
" No error messages about whitespaces please
let g:airline#extensions#whitespace#enabled = 0

" Resize vim splists with a mouse when inside tmux
set mouse+=a

" Draw a line at wrapwidth
set colorcolumn=+1


"" Netrw
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'

" Make netrw moving work 
let g:netrw_keepdir=1


"" Markdown related
set conceallevel=2
let g:vim_markdown_conceal = 1

" Markdown fenced languages support
let g:markdown_fenced_languages = ['json', 'javascript', 'html', 'python', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0





"""""" Mappings
""""""
" Change leader
let mapleader = ","
let maplocalleader = ","


" ]s means go to next spelling error.
nnoremap  <Leader>s ]s1z=<C-X><C-S>

" https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
" Insert mode, correct last error.
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" <tab> is no good in visual mode without launching UltiSnips:
xmap  <tab> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

"" vim-ipy
" leader-e is mapped to running text objects, but since I never
" wanna run till end of word(which is 'e'), but much more commonly to end of line...
nmap <silent> <leader>ee <Plug>(IPy-Run)

" Run arbitrary text objects
nmap <silent> <leader>e <Plug>(IPy-RunOp)
" Run in visual mode
vmap <silent> <leader>e <Plug>(IPy-Run)


" Run cell
nmap <silent> <leader>ec <Plug>(IPy-RunCell)

" Terminate kernel
map <silent> <leader>iq <Plug>(IPy-Terminate)

" (Re)start kernel
nmap <silent> <leader>ei :IPython<CR>

" Inspect variable under cursor. k cuz K means look up man page in vim.
nmap <silent> <leader>ek <Plug>(IPy-WordObjInfo)

" We use the IpyOmniFunc in mu-complete's chain, but it's synchronous.
" This is async.
imap <silent> <C-f> <Plug>(IPy-Complete)



" Goyo. Distraction free writing.
" No justification for key choice except that it's the shortest that's not yet taken.
nnoremap <leader>z :call GoyoToggle()<CR>


" Dispatch related shortcuts
" open and close quickfix
nnoremap <Leader>qo :copen<CR>
" make using compiler in bg
nnoremap m<CR>  :Make!<CR>

" Same pattern for loclist
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>

" Read vimrc again.
noremap <Leader>ri :source $MYVIMRC<CR>
" Reload filetype plugins by setting filetype to current filetype
noremap <Leader>rf :let &filetype=&filetype<CR>

augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
augroup END


" fzf shortcuts
" second f for search in directory of curetn *F*ile
nnoremap <Leader>ff :execute 'Files' . expand('%:p:h')<CR> 
" c for current dir
nnoremap <Leader>fc :Files<CR> 
nnoremap <Leader>fr :Rg<CR>
inoremap <Leader>fa :Ag<CR> 
" Search through buffers and history
nnoremap <Leader>f: :History:<CR> 
nnoremap <Leader>f/ :History/<CR>
nnoremap <Leader>fb :Buffers<CR> 

" Run tests
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>


" Neovim's terminal mode, escape with Ctrl-P which happens to
" be my Tmux "leader" key, which works great cuz I don't see
" a reason to use Neovim's :terminal inside tmux.
tnoremap <C-p> <C-\><C-n>

" ALE mappings
nnoremap <Leader>ah :ALEHover<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>ai :ALEInfo<CR>
nnoremap <Leader>au :ALEFindReferences<CR>
nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>aa :ALECodeAction<CR>
nnoremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <Leader>at :ALEGoToTypeDefinition<CR>
nnoremap <Leader>ar :ALERename<CR>
" t for toggle
nnoremap <Leader>at :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<CR>

" Jedi mappings
nnoremap <Leader>ju :call jedi#usages()<CR>
nnoremap <Leader>jk :call jedi#show_documentation()<CR>
nnoremap <Leader>jd :call jedi#goto_definitions()<CR>
nnoremap <Leader>ja :call jedi#goto_assignments()<CR>
nnoremap <Leader>jt :call jedi#goto_stubs()<CR>
nnoremap <Leader>jr :call jedi#rename()<CR>
let g:jedi#auto_initialization=0  " Don't take over
let g:jedi#completions_enabled=0 " Pyright+ALE=autoimport
let g:jedi#show_call_signatures=2  " Show ginatures in window
let g:jedi#show_call_signatures_delay=0 " Show ginatures in window


" t for toggle
nnoremap <leader>at :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<cr>

" Fugutive mappings
nnoremap <Leader>gs :Git!<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gpull --rebase<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gg :Git 

" Allow a 'computer dependent' initialization
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

" From an issue on the official github repo.
function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))
