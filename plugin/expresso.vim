" expresso.vim
" Maintainer:   Mike Foley
" Version:      1.0

if exists("g:loaded_expresso")
  finish
endif
let g:loaded_expresso = 1

if !exists('g:expresso_ignore_chars')
  let g:expresso_ignore_chars = '[\$,\x00]'
endif

command! -range Expresso call s:Expresso()

function! s:Expresso()
  try
    if visualmode() ==# ""
      throw "Blockwise select not supported."
    end

    let l:result = s:eval_visual_selection()
    call s:replace_visual_selection(l:result)
  catch
    echo 'Expresso error:' v:exception
  endtry
endfunction

function! s:eval_visual_selection()
  return string(eval(s:formatted_visual_selection()))
endfunction

function! s:formatted_visual_selection()
  let l:e_backup = @e
  try
    normal! gv"ey
    return s:strip_ignorable_chars(@e)
  finally
    let @e = l:e_backup
  endtry
endfunction

function! s:strip_ignorable_chars(string)
  return substitute(a:string, g:expresso_ignore_chars, '', 'g')
endfunction

function! s:replace_visual_selection(result)
  let l:e_backup = @e
  try
    let @e = a:result
    normal! gv"ep
  finally
    let @e = l:e_backup
  endtry
endfunction
