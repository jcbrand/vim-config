" Author: Jean Jordaan 2000/11/18 11:56:18  
" Edited: 2001/02/25 04:19:56  
"
" Some macros to read mailing list digests with Vim.
"
" Usage: 
"
"       Register: 
"        a       -- Message seperator (yank this first)
"
"        <bs>    -- Page back 
"        <space> -- Page forward
"        <f4>    -- Go back one message
"        <f5>    -- Go forward one message
"        <f6>    -- Clip the message for keeping (go to start of message
"                   first)
"        <f7>    -- Browse previous thread
"        <f8>    -- Previous in thread
"        <f9>    -- Next in thread
"        <f10>   -- Start browsing next thread
"        <f11>   -- Wrap the next paragraph (for all those sloppy
"                   unwrapped messages mangled by mailinglist software).
"
" Uniq lives in my '_vimrc'. Uncomment the following or move it to where
" you want to source it from.
" START
" " Author: Jean Jordaan
" " Uniq -- remove duplicate lines from a sorted file.
" " Very basic implementation supporting no options.
" 
"   func! Uniq() range
"     let a = a:firstline
"     let z = a:lastline
"     while (a <= z)
"       let str1 = getline(a)
"       let str2 = getline(a+1)
"       if (str1 == str2)
"         exec a."delete"
"         let z = z - 1
"       else
"         let a = a + 1
"       endif
"     endwhile
"   endfunc
" 
"   " :Uniq takes a range of sorted lines and discards duplicates.
"   command! -nargs=0 -range Uniq <line1>,<line2>call Uniq()
" END

" From a mail:
" ------------
" I often find myself having to use Outlook. When reading digests, I like
" to <c-a><c-c> to copy the whole digest in Outlook, <m-tab> to vim, p and
" then ':so mailing-list-digest.vim'
" 
" When I source the script, it switches to 'ft=mail' for syntax
" highlighting, builds a quick & dirty table of contents from the
" "Subject: " lines of the messages, and goes to the first message. This
" is useful in case '@a' doesn't contain the seperator yet.
" 
" Then I can use <f4> and <f5> to browse by message, <f7> and <f10> to 
" jump between threads, and <f8> and <f9> to browse within a thread. 
" 
" It works OK for me, but of course there are some caveats and a wishlist.
" 
" - I'd love to get rid of all the "1 line yanked" and "1 line deleted"
"   messages at startup.
" XXX See 'report' option! That probably fixes it.
" 
" - I'd like to have the "Subject: " lines of the thread I'm currently
"   browsing to have the search highlight. How do I manage this?
" 
" - If 'set wrapscan', wrapping happens silently. I don't think I want
"   this when browsing in a thread, so I 'set nowrapscan'. There must be a
"   smarter way to manage this .. 
" 
" - Browsing by thread makes use of the same search as jumping to the
"   previous message. This should be a reference to a common mapping or
"   function instead of a duplication.
" 
" - Perhaps it should be possible to start browsing the thread of which
"   the current message forms part.
" 
" - The TOC is alphabetical. Browsing alphabetically by thread means that
"   the message numbers jump around. This might be disorienting.
"------------------------------------------------------------------------

fu! Make_toc()
  " Should save this setting instead:
  set nomore
  " Copy all subject lines to top (how do I get this to happen silently?)
  global/^Subject: /yank|0put
  " Delete all lines except 'Subject: ' header lines.
  " Strip patterns like 'Subject: ', 'Re: ', 'Fwd: ' and '[List Title]'
  " from the TOC.
  " Strip only from start of line, and strip 'Re: ' & co. twice.
  0,/^$/substitute?^Subject:\s
  0,/^$/substitute?^\(re: *\|fwd: *\|fw: *\)\+??gi
  0,/^$/substitute?^\[.\{-}\]\s
  0,/^$/substitute?^\(re: *\|fwd: *\|fw: *\)\+??gi
  " Sort the TOC (uses 'Sort' example function; see ':h eval-examples').
  " Uniquify the TOC (uses basic 'Uniq' function; improvements welcome).
  0,/^$/-1Sort
  0,/^$/-1Uniq
  let g:toc_entry = 1
  let g:thread = Get_toc_entry()
  " Restore 'more' setting
  set more
endf 

fu! Get_toc_entry()
  let str = getline(g:toc_entry)
  return escape(str, '"*^$.[]/\')
endfu

fu! Next_thread()
  let g:toc_entry = g:toc_entry + 1
  let g:thread = Get_toc_entry()
  let @/ = g:thread
  0
  call Next_in_thread()
endf

fu! Prev_thread()
  let g:toc_entry = g:toc_entry - 1
  let g:thread = Get_toc_entry()
  let @/ = g:thread
  0
  call Next_in_thread()
endf

fu! Next_in_thread()
  " Should save option state.
  set nowrapscan
  exe '/^Subject:.*'.g:thread
  exec "normal ?\<c-r>a\<cr>zt"
  exe '/^Subject:.*'.g:thread
  set wrapscan
endf

fu! Prev_in_thread()
  " Should save option state.
  set nowrapscan
  exe '?^Subject:.*'.g:thread
  exec "normal ?\<c-r>a\<cr>zt"
  exe '/^Subject:.*'.g:thread
  set wrapscan
endf

  set ft=mail
  call Make_toc()
  " Go to first message near seperator
" norm /From:\s
  exec "norm /From:\\s\<cr>"
  norm {k
  " Specially for Dieter Maurer on the Zope list: unindent quotes.
  global/^\s\+>/s/^\s*//

  map <bs>    <c-b>
  map <space> <c-f>
  map <f4>    ?<c-r>a<cr>zt
  map <f5>    /<c-r>a<cr>zt
  map <f6>    y/<cr>
  map <f7>    :call Prev_thread()<cr>
  map <f8>    :call Prev_in_thread()<cr>
  map <f9>    :call Next_in_thread()<cr>
  map <f10>   :call Next_thread()<cr>
  map <f11>   gq}''
