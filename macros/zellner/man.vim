" -*- vim -*-
" FILE: "/home/joze/.vim/functions/man.vim"
" LAST MODIFICATION: "Tue, 29 Feb 2000 22:53:01 +0100 (joze)"
" (C) 1999 - 2000 by Johannes Zellner, <johannes@zellner.org>
" $Id: man.vim,v 1.5 2000/02/29 21:54:55 joze Exp $


" PURPOSE:
"   - view UNIX man pages in a split buffer
"   - includes syntax highlighting
"   - works also in gui (checked in gtk-gui)
"
" USAGE:
"   put this line in your ~/.vimrc
"      :source ~/<dir where you put>/man.vim
"
" NORMAL MODE:
"   place the cursor on a keyword, e.g. `sprintf' and
"   hit Q. The window will get split and the man page
"   for sprintf will be displayed in the new window.
"   The Q can be preceeded by a `count', e.g. typing
"   2Q while the cursor is on the keyword `open' would
"   take you to `man 2 open'.
"
" COMMAND MODE:
"   The usage is like if you type it in your shell
"   (except, you've to use a capital `M').
"
"   :Man sprintf
"   :Man 2 open
"
" REQUIREMENTS:
"   man, col
"   `col' is used to remove control characters from the `man' output.
"   if `col' is not present on your system, you can set a global variable
"       let g:man_vim_only = 1
"   in your ~/.vimrc. If this variable is present vim filters away the
"   control characters from the man page itself.
"   
" CREDITS:
"   Adrian Nagle
"   John Spetz
"   Bram Moolenaar
"   Rajesh Kallingal
"   Antonio Colombo
"
" LICENSE:
"   no warranties, everything else is allowed.
"   if you like this script type :help uganda<Enter>
"
" URL: http://www.zellner.org/vim/functions/man.vim

let session_man_prep = tempname()
"map Q :<c-u>call ManPrep(v:count, expand("<cword>"))<cr>
map Q :<c-u>call ManFancyCword(v:count)<cr>
command! -nargs=* Man call ManPrePrep(<f-args>)


fun! ManFancyCword(cnt)
    if a:cnt == 0
        if bufname("%") == g:session_man_prep
            let save_iskeyword = &iskeyword
            set iskeyword+=(,)
        endif
        let page_section = expand("<cword>")
        if bufname("%") == g:session_man_prep
            let &iskeyword = save_iskeyword
        endif
        let page = substitute(page_section, '\(\k\+\).*', '\1', '')
        let section = substitute(page_section, '\(\k\+\)(\([^()]*\)).*', '\2', '')
        if -1 == match(section, '^[0-9 ]\+$')
            let section = ""
        endif
        if section == page
            let section = ""
        endif
    else
        let section = a:cnt
        let page = expand("<cword>")
    endif
    call ManPrep(section, page)
endfun

fun! ManPrePrep(...)
    if a:0 >= 2
        let section = a:1
        let page = a:2
    elseif a:0 >= 1
        let section = ""
        let page = a:1
    else
        return
    endif
    if "" == page
        return
    endif
    call ManPrep(section, page)
    " let i = 1 | while i <= a:0
    "     exe 'echo a:'.i
    " let i = i + 1 | endwhile
endfun

fun! ManPrep(section, page)

    if 0 == a:section || "" == a:section
        let section = ""
    elseif 9 == a:section
        let section = 0
    else
        let section = a:section
    endif

    let this_winnr = winnr()
    let old_report = &report
    let &report=999999999
    " why can't we open /dev/null ?
    "let tmp = "/dev/null"
 
    " check if a man window exists
    " and if so, go to it.
    let man_winnr = bufwinnr(g:session_man_prep)
    if -1 != man_winnr
        " go to bottom window
        exe "normal \<c-w>b"
        let i = winnr()

        " go up through the windows until
        " we've reached the man window.
        while i != man_winnr && 1 <= i
            exe "normal \<c-w>k"
            let i = i - 1
        endwhile
        if 0 == i
            " something went wrong
            let &report=old_report
            return ""
        endif
    else
        exec 'new '.g:session_man_prep
    endif
    set noreadonly
    %d " delete old manpage

    if exists("g:man_vim_only")
	exe 'read !man '.section.' '.a:page
	" col is not present. So we let vim filter away
	" the control characters. hope this works on
	" all systems.
	exe "%s/_\<c-h>\\(.\\)/\\1/ge"
	exe "%s/\\(.\\)\<c-h>\\(.\\)/\\1/ge"
    else
	" do we really need to redirect stderr ?
	" exe 'read !man '.section.' '.a:page.' | col -b 2>/dev/null'
	exe 'read !man '.section.' '.a:page.' | col -b'
    endif

    " go to start of manpage
    0
    write!
    set readonly
    " set iskeyword+=(,)
    call ManPrepHighlight(a:page)

    " go back to `this'
    exe "normal ".this_winnr."\<c-w>W"
    let &report=old_report

endfun


" set isprint+=27
" [1mbold[0m

fun! ManPrepHighlight(page)

    " Remove any old syntax stuff hanging around
    syn clear

    syn match  manPrepSectionHeader	"^[A-Z ]*\s*$"
    syn match  manPrepOptions		/\W--\=[0-9a-zA-Z_-]*\>/hs=s+1
    syn match  manPrepLinks             /\<\w*\>([0-9a-z])/
    exec 'syn match  manPrepThisRequest /\<'.a:page.'\>/'

    if !exists("did_manPrep_syntax_inits")

        let did_manPrep_syntax_inits = 1

        hi link manPrepSectionHeader Comment
        hi link manPrepOptions       String
        hi link manPrepLinks         Type
        hi link manPrepThisRequest   Statement

    endif

endfun


"%s/^\(\s.*\)\<\([^-]\)\2/\1(\2/g " leading '('s
"%s/^\(\s.*\)\(.\)\2\>/\1\2)/g " trailing ')'s


