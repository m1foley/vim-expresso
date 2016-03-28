" expresso.vim
" Maintainer:   Mike Foley
" Version:      1.0

if exists('g:loaded_expresso')
  finish
endif
let g:loaded_expresso = 1

if !exists('g:expresso_ignore_chars')
  let g:expresso_ignore_chars = '[\$,\x00]'
endif

command! -range=2 Expresso call s:Expresso('range', <line1>, <line2>)
vmap <silent> g= :<C-U>call <SID>Expresso(visualmode())<CR>
nmap g= <SID>Expresso
nnoremap <silent> <SID>Expresso :<C-U>set operatorfunc=<SID>Expresso<CR>g@

function! s:Expresso(type, ...)
  try
    if a:type == 'range'
      call s:expresso_range(a:2, a:3)
    elseif a:type == 'char'
      call s:expresso_normal_char()
    elseif a:type == 'line'
      call s:expresso_normal_line()
    elseif a:type == ''
      throw 'Blockwise select not supported.'
    else
      call s:expresso_visual_selection()
    endif
  catch
    echo 'Expresso error:' v:exception
  endtry
endfunction

function! s:expresso_range(line1, line2)
  let l:input = s:range_selection(a:line1, a:line2)
  let l:result = s:evaluate_input(l:input)
  call s:replace_range_selection(a:line1, a:line2, l:result)
endfunction

function! s:range_selection(line1, line2)
  let l:e_backup = @e
  try
    execute a:line1 . ',' . a:line2 . 'yank e'
    return @e
  finally
    let @e = l:e_backup
  endtry
endfunction

function! s:replace_range_selection(line1, line2, text)
  execute 'normal!' a:line1 . 'gg | V | ' . a:line2 . "gg | \<Esc>"
  call s:replace_prev_visual_selection(a:text)
endfunction

function! s:evaluate_input(text)
  return string(eval(s:strip_ignorable_chars(a:text)))
endfunction

function! s:strip_ignorable_chars(text)
  return substitute(a:text, g:expresso_ignore_chars, '', 'g')
endfunction

function! s:expresso_visual_selection()
  let l:result = s:evaluate_input(s:visual_selection())
  call s:replace_prev_visual_selection(l:result)
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

function! s:replace_prev_visual_selection(text)
  let l:e_backup = @e
  try
    let @e = a:text
    silent normal! gv"ep
  finally
    let @e = l:e_backup
  endtry
endfunction

function! s:expresso_normal_char()
  let l:input = s:normal_char_selection()
  let l:result = s:evaluate_input(l:input)
  call s:replace_prev_visual_selection(l:result)
endfunction

function! s:normal_char_selection()
  let l:e_backup = @e
  try
    silent normal! `[v`]"ey
    return @e
  finally
    let @e = l:e_backup
  endtry
endfunction

function! s:expresso_normal_line()
  let l:input = s:normal_line_selection()
  let l:result = s:evaluate_input(l:input)
  call s:replace_prev_visual_selection(l:result)
endfunction

function! s:normal_line_selection()
  let l:e_backup = @e
  try
    silent normal! `[V`]"ey
    return @e
  finally
    let @e = l:e_backup
  endtry
endfunction
