"----smartCTRL_w.vim----
"
" SmartCTRL_W () ... A smarter i_CTRL-W that is very useful for changing long
"   identifers that follow Java convention or the C convention. Move the
"   cursor on to or after the word and press ^X^W in input mode.
"   You can also press ^X^W at command line for the same affect.
"
" E.g.:
"   veryLongJavaVariable -> ^X^W -> veryLongJava -> ^X^W -> veryLong
"   veryLongJAVAvariable -> ^X^W -> veryLongJAVA -> ^X^W -> veryLong
"   very_long_anJy_variable -> ^X^W -> very_long_any -> ^X^W -> very_long
"
" TODO:
"   Should work at the middle of the word also.
"
" Author: Hari Krishna <haridsv@hotmail.com>
" Last Change: 03-Sep-1999 @ 23:11
" Version: 5.4 or later (history management).
"

:function! GetOppCase (letter)
:  if a:letter =~ '\l'
:    return '\u'
:  elseif a:letter =~ '\u'
:    return '\l'
:  else
:    return ''
:  endif
:endfunction

:function! SmartCTRL_W (word)
:  let len = strlen (a:word)
:  let oppCase = GetOppCase (a:word[len - 1])
:  if oppCase =~ '^$'
:    " See if you can find the case of any previous letters.
:    let i = len - 2
:    while i >= 0
:      let oppCase = GetOppCase (a:word[i])
:      if oppCase !~ '^$'
:        break
:      endif
:      let i = i - 1
:    endwhile
:  else
:    let oppCase = oppCase
:  endif
:  if oppCase =~ '^$'
:    return a:word
:  endif
:  let i = len - 1
:  let found = 0
:  while i >= 0
:    if a:word[i] =~ oppCase || a:word[i] =~ '_'
:      if found
:        let i = i + 2
:        break
:      else
:        let found = 1
:      endif
:    else
:      if found
:        let i = i + 1
:        break
:      endif
:    endif
:    let i = i - 1
:  endwhile
:  return strpart (a:word, 0, i))
:endfunction

"
" Assumes that the word to-be-processed exists in the " register and returns
" the new word.
"
:function! IsmartCTRL_W ()
:  let curWord = @"
:  if curWord =~ '^$'
:    normal b
:    let curWord = expand ("<cword>")
:    if curWord =~ '^\w\+$'
:      return ''
:    endif
:  endif
:  return SmartCTRL_W (curWord)
:endfunction

"
" Assumes that the command to-be-processed exists as the last item in the
"cmd"
" history. Modifies the history to reflect the changes.
"
:function! CsmartCTRL_W ()
:  let curCom = histget ("cmd", -1)
:  call histdel ("cmd", -1)
:  if curCom =~ '^\s\+'
:    return ""
:  else
:    let newCom = SmartCTRL_W (curCom)
:    call histadd ("cmd", newCom)
:    return newCom
:  endif
:endfunction

:inoremap <C-X><C-W> <C-O>b<C-O>cw<C-R>=IsmartCTRL_W ()<C-M>
:cnoremap <C-X><C-W> <C-C>:<C-R>=CsmartCTRL_W ()<C-M>

