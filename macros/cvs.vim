" File: cvs.vim
" Author: Thomas S. Urban [tsurban@home.net]
" posted to vim list 2001/01/23 
"
" Modified: Jean Jordaan <jean@mosaicsoftware.com>
" posted to vim list 2001/01/26
"
" Now, the output of the CVS commands is appended to 'cvs-messages.tmp'
" and opened in Vim. The cursor is positioned just before the last
" message. This way, a history of CVS interaction remains available.
"
" Problems I still have:
"
"  - I'd love to be able to edit the log message in the current Vim
"    session. At the moment, a console vim is opened to edit the log
"    message when I commit (I don't want to supply only a oneliner log
"    message). This is workable, but silly.
"
"  - Every CVS command causes a console window to open and query "Hit
"    return to continue". I'm sure I'm missing something about this in
"    the docs, but would appreciate a pointer -- how do I get rid of the
"    console window and its prompt? 
"
" Usage:
" nmap ;CA :!cvs add ...
" nmap ;CC :!cvs commit ...
" nmap ;CD :!cvs diff ...
" nmap ;CH :!cvs history ...
" nmap ;CL :!cvs log ...
" nmap ;CS :!cvs status ...
" nmap ;CU :!cvs update ...

if !exists("cvs_macros_loaded")
  let cvs_macros_loaded = 1
  if has("gui_running")
    nmenu C&VS.&Add<Tab>;CA     :!cvs add %     >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
    " Why doesn't the "OpenWithVim" version work?
    " nmenu C&VS.&Commit<Tab>;CC  :!cvs -e OpenWithVim commit %<cr>
    nmenu C&VS.&Commit<Tab>;CC  :!cvs commit %<cr>
    nmenu C&VS.&Diff<Tab>;CD    :!cvs diff %    >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
    nmenu C&VS.&History<Tab>;CH :!cvs history % >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
    nmenu C&VS.&Log<Tab>;CL     :!cvs log %     >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
    nmenu C&VS.&Status<Tab>;CS  :!cvs status %  >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
    nmenu C&VS.&Update<Tab>;CU  :!cvs update %  >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
  endif
 nmap ;CA :!cvs add %     >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
 nmap ;CC :!cvs commit %<cr>
 nmap ;CD :!cvs diff %    >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
 nmap ;CH :!cvs history % >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
 nmap ;CL :!cvs log %     >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
 nmap ;CS :!cvs status %  >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
 nmap ;CU :!cvs update %  >> cvs-messages.tmp <cr> :e cvs-messages.tmp <bar> norm 0G?====<cr><cr>
endif
