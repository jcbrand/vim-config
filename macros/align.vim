" -*- vim -*-
"
" FILE: "/home/joze/share/vim/functions/Align.vim"
" LAST MODIFICATION: "Tue Apr 27 17:17:28 1999 (joze)"
" (C) 1999 by Johannes Zellner
" johannes@zellner.org
" $Id: Align.vim,v 1.2 1999/04/27 15:17:53 joze Exp $

command! -nargs=? -range Align call Align (<line1>, <line2>, "l", <q-args>)
command! -nargs=? -range RAlign call Align (<line1>, <line2>, "r", <q-args>)
command! -range EQAlign call Align (<line1>, <line2>, "rword")

vnoremap ;= :EQAlign<CR>
vnoremap ;a :Align<CR>
vnoremap ;r :RAlign<CR>
vnoremap ;A :RAlign<CR>

function! Align (first, last, whence, ...)
    if a:0 > 0
        if strlen (a:1) > 0
            let p = a:1
        elseif a:whence == "l"
            if exists ("g:leftalign")
                let p = g:leftalign
            else
                let p = '/\*'
            endif
        elseif a:whence == "r"
            if exists ("g:rightalign")
                let p = g:rightalign
            else
                let p = '\*/'
            endif
        else
            let p = "="
        endif
    else
        let p = ""
    endif
    let at = FindInRange (a:first, a:last, p, a:whence)
    call AlignInRangeAt (a:first, a:last, p, at, a:whence)
endfunction


function! FindPattern (line, p, whence)
    let line = escape (a:line, '"')
    let d = strlen (line) - strlen (a:line)
    if a:whence == "r"
        exec "let z = match ('".line."','".a:p."[^".a:p."]*$\') - d"
    elseif a:whence == "l"
        exec "let z = match ('".line."','".a:p.".*$\') - d"
    elseif a:whence == "lword"
        exec "let z = matchend ('".line."','^\\s*\\S\\+\\s') - d"
    elseif a:whence == "rword"
        " let z = 0 " TODO
        exec "let z = matchend ('".line."','^\\s*\\S\\+\\s') - d"
    endif
    return z
endfunction


function! FindInRange (first, last, p, whence)
    let maxlen = 0
    let n = a:first
    while n <= a:last
        let newlen = FindPattern (getline (n), a:p, a:whence)
        if newlen > maxlen
            let maxlen = newlen
        endif
        let n = n + 1
    endwhile
    return maxlen
endfunction


function! AlignInRangeAt (first, last, p, at, whence)
    if exists ("g:fillchar")
        let fill = g:fillchar
    else
        let fill = " "
    endif
    let n = a:first
    while n <= a:last
        let new = AlignedString (getline (n), a:p, a:at, fill, a:whence)
        call setline (n, new)
        let n = n + 1
    endwhile
endfunction


function! AlignedString (line, p, at, fill, whence)
    let cpos = FindPattern (a:line, a:p, a:whence)
    if cpos < 0
        return a:line
    endif
    let left = strpart (a:line, 0, cpos)
    let right = strpart (a:line, cpos, 1000000000)
    while cpos < a:at
        let left = left . a:fill
        let cpos = cpos + 1
    endwhile
    return left . right
endfunction


    "int i = 15, j = 1000000, k = 1; /* great stuff */
    "WINDOW* w; /* this is a comment */
    "double x = 1.0;
    "i = sin (3.0) * x / 75000;
