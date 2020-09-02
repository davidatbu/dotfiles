set textwidth=88 " Google Styleguide

augroup JediRelated
	" Jedi for go to definition
	au!
	nnoremap gd :call jedi#goto()<CR>
	nnoremap K :call jedi#show_documentation()<CR>
	nnoremap <Leader>js :call jedi#goto_stubs()<CR>
	nnoremap <Leader>jr :call jedi#rename()<CR>
	nnoremap <Leader>jd :call jedi#goto_definitions()<CR>
	nnoremap <Leader>ja :call jedi#goto_assignments()<CR>
	nnoremap <Leader>ju :call jedi#usages()<CR>
augroup end

" Black to do formatting, don't wrap lines
set formatoptions-=t
set nowrap

" Setup a shortcut for tagbar
augroup TagBar
	au!
	nnoremap <Leader>t :TagbarToggle<CR>
augroup END

" Set omnifunc
setlocal omnifunc=jedi#completions

set noshowmode " jedi docs say we need this for the below.
let g:jedi#show_call_signatures=2
" auto_initialization is 0, so we gotta do this for call signatures.
call jedi#configure_call_signatures()
