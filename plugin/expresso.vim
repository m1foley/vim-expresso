" expresso.vim
" Maintainer:   Mike Foley
" Version:      1.0

if exists('g:loaded_expresso')
  finish
endif
let g:loaded_expresso = 1

if !exists('g:expresso_ignore_chars')
  let g:expresso_ignore_chars = '[\$,]'
endif

command! -range=2 Expresso call s:Expresso('range', <line1>, <line2>)
vmap <silent> g= :<C-U>call <SID>Expresso(visualmode())<CR>
nmap g= <SID>Expresso
nmap g== <SID>ExpressoLine
nnoremap <silent> <SID>Expresso :<C-U>set operatorfunc=<SID>Expresso<CR>g@
nnoremap <silent> <SID>ExpressoLine :<C-U>set operatorfunc=<SID>Expresso<Bar>execute 'normal! ' v:count1 . 'g@_'<CR>

function! s:Expresso(type, ...)
  try
    if a:type ==# 'range'
      execute 'normal!' a:1 . 'gg'
      normal! V
      execute 'normal!' a:2 . 'gg'
      execute 'normal!' "\<Esc>"
    elseif a:type ==# 'char'
      silent normal! `[v`]
      execute 'normal!' "\<Esc>"
    elseif a:type ==# 'line'
      silent normal! `[V`]
      execute 'normal!' "\<Esc>"
    elseif a:type ==# ''
      throw 'Blockwise select not supported.'
    endif

    let l:result = s:evaluate_input(s:visual_selection())
    call s:replace_prev_visual_selection(l:result)
  catch
    echo 'Expresso error:' v:exception
  endtry
endfunction

function! s:visual_selection()
  let l:e_backup = @e
  try
    silent normal! gv"ey
    return @e
  finally
    let @e = l:e_backup
  endtry
endfunction

function! s:evaluate_input(text)
  return string(eval(s:strip_ignorable_chars(a:text)))
endfunction

function! s:strip_ignorable_chars(text)
  let l:stripped = substitute(a:text, g:expresso_ignore_chars, '', 'g')
  let l:stripped = substitute(l:stripped, '[\x00]', ' ', 'g') " line breaks
  return l:stripped
endfunction

function! s:replace_prev_visual_selection(text)
  let l:e_backup = @e
  try
    let @e = a:text
    silent normal! gv"ep
  finally
    let @e = l:e_backup
  endtry
endfunction
