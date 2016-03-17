" expresso.vim
" Maintainer:   Mike Foley
" Version:      1.0

if exists("g:loaded_expresso")
  finish
endif
let g:loaded_expresso = 1

if !exists('g:expresso_ignore_chars')
  let g:expresso_ignore_chars = '[\$,]'
endif

command! -range Expresso call s:Expresso()

function! s:Expresso()
  let l:a_backup = @a
  try
    let @a = s:eval_visual_selection()
    execute 'normal! gv"ap'
  catch
    echo 'Expresso error:' v:exception
  finally
    let @a = l:a_backup
  endtry
endfunction

function! s:eval_visual_selection()
  return string(eval(s:formatted_visual_selection()))
endfunction

function! s:formatted_visual_selection()
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  let l:lines[-1] = l:lines[-1][: l:col2 - (&selection == 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:col1 - 1:]
  let l:string = join(l:lines)
  let l:string = s:strip_ignorable_chars(l:string)
  return l:string
endfunction

function! s:strip_ignorable_chars(string)
  return substitute(a:string, g:expresso_ignore_chars, '', 'g')
endfunction
