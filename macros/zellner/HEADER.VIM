Date sent:        Fri, 20 Nov 1998 12:46:47 +0100 (MET)
From:             Johannes Zellner <joze@krisal.physik.uni-karlsruhe.de>
To:               Mark Waller <markwa@redac.co.uk>
Copies to:        vim@vim.org
Subject:          Re: User defined commands


> I would like to map
> ":header"
> so that it reads in a standard header file.

User defined command have to begin with a capital letter.
So your command would read ':Header'.
I've already created a command 'Header' by myself and append it to this
mail. You have to source this file
(e.g. in your .vimrc:
 source Header.vim)

:Header         --> file type is guessed
:Header sh      --> #!/bin/sh Header
:Header tcl     --> #!/usr/local/bin/tclsh Header
:Header tk      --> #!/usr/local/bin/wish Header
:Header c       --> c comment Header
:Header f       --> fortran Header
:Header js      --> javascript Header
:Header pov     --> povray Header
 ...

The file Header.vim also includes the function
function! HeaderTimeStamp ()
which changes the time and file name in the Header if you write the file.
If you don't like this you have to remove the corresponding line with
the autocommand.

Of course you have to edit the stuff, which is printed in the Header.

--
          .. __o    __o    __o    __o
         .. -\<,   -\<,   -\<,   -\<,
 (joze) ..(_)/(_)(_)/(_)(_)/(_)(_)/(_)
 ------------------------------------------------------------------------------
 Johannes Zellner                
 Institut für Kristallographie   fon : ++49 721 608-7263
 Universität Karlsruhe           fax : ++49 721 608-7264
 Kaiserstrasse 12                mail: Johannes.Zellner@physik.uni-karlsruhe.de
 76128 Karlsruhe                 http://krisal.physik.uni-karlsruhe.de/~joze


 ------------------- CUT HERE ---------------
" vim
" ==================================================================
" FILE: "/tmp/pico.26135"
" LAST MODIFIED: "Fri Nov 20 12:46:37 1998 (joze)"
" (c) 1998 by Johannes Zellner
" Johannes.Zellner@physik.uni-karlsruhe.de
" $Id:$
" ================================================================== 

command! -nargs=? Header call Header (<q-args>)

autocmd BufNewFile * call Header ("")
autocmd BufWritePre,FileWritePre  * call HeaderTimeStamp ()


function! GuessHeader ()
    if expand ("%:e") == "c" || expand ("%:e") == "h"
        call CHeader ()
    elseif expand ("%:e") == "f" || expand ("%:e") == "F"
        call FHeader ()
    elseif expand ("%:e") == "sh"
        call SHHeader ()
    elseif expand ("%:e") == "vim" || expand ("%:e") == "fcn" || expand ("%:e") ==
    "mac"
        call VIMHeader ()
    elseif expand ("%:e") == "tcl" || expand ("%:e") == "itcl"
        call TCLHeader ()
    elseif expand ("%:e") == "tk" || expand ("%:e") == "itk"
        call TKHeader ()
    elseif expand ("%:e") == "tex"
        call TEXHeader ()
    elseif expand ("%:e") == "java" || expand ("%:e") == "js"
        call JSHeader ()
    elseif expand ("%:e") == "pov"
        call POVHeader ()
    elseif expand ("%:e") == "mk" || match (expand ("%:t"), "[Mm]akefile") != -1
        call MAKEHeader ()
    else
        call TCLHeader ()
endfunction

function! HeaderTimeStamp ()

    ijump! /FILE:[^<\"]*[<\"]/
    exec 's#FILE:[^<\"]*\([<\"]\)[^>\"]*\([>\"]\)#FILE: \1' . expand ("%:p") . '\2#g'
    ijump! /Time-stamp:\|LAST MODIFIED:.*[<\"].*[>\"]/ exec 's#\(Time-stamp:\|LAST
    MODIFIED:\)\([^<\"]*\)\([<\"]\)\([^>\"]*\)\([>\"]\)#\1 \3'.strftime ("%c").'
    ('.$USER.')\5'

endfunction

function! Header (...)

    if a:1 == ""
        call GuessHeader ()
    elseif a:1 == "c" || a:1 == "h"
        call CHeader ()
    elseif a:1 == "f"
        call FHeader ()
    elseif a:1 == "sh"
        call SHHeader ()
    elseif a:1 == "make"
        call MAKEHeader ()
    elseif a:1 == "vim"
        call VIMHeader ()
    elseif a:1 == "tcl"
        call TCLHeader ()
    elseif a:1 == "tk"
        call TKHeader ()
    elseif a:1 == "tex"
        call TEXHeader ()
    elseif a:1 == "java" || a:1 == "js"
        call JSHeader ()
    elseif a:1 == "pov"
        call POVHeader ()
    else
        echo "unknown header"
        return
    endif

    call HeaderTimeStamp ()

endfunction


function! CHeader ()
    0insert

    /* ==================================================================
       FILE: ""
       LAST MODIFIED: ""
       (c) 1998 by Johannes Zellner
       Johannes.Zellner@physik.uni-karlsruhe.de
       $Id:$
       ================================================================== */  

endfunction

function! FHeader ()
    0insert
C ==================================================================
C FILE: ""
C LAST MODIFIED: ""
C (c) 1998 by Johannes Zellner
C Johannes.Zellner@physik.uni-karlsruhe.de
C $Id:$
C ==================================================================

endfunction

function! SHHeader ()
    0insert
#!/bin/sh
# ==================================================================
# FILE: ""
# LAST MODIFIED: ""
# (c) 1998 by Johannes Zellner
# Johannes.Zellner@physik.uni-karlsruhe.de
# $Id:$
# ==================================================================

endfunction

function! MAKEHeader ()
    0insert
# gmake
# ==================================================================
# FILE: ""
# LAST MODIFIED: ""
# (c) 1998 by Johannes Zellner
# Johannes.Zellner@physik.uni-karlsruhe.de
# $Id:$
# ==================================================================

endfunction

function! VIMHeader ()
    0insert
" vim
" ==================================================================
" FILE: ""
" LAST MODIFIED: ""
" (c) 1998 by Johannes Zellner
" Johannes.Zellner@physik.uni-karlsruhe.de
" $Id:$
" ==================================================================

endfunction

function! TCLHeader ()
    0insert
#!/usr/local/bin/tclsh
# ==================================================================
# FILE: ""
# LAST MODIFIED: ""
# (c) 1998 by Johannes Zellner
# Johannes.Zellner@physik.uni-karlsruhe.de
# $Id:$
# ==================================================================

endfunction

function! TKHeader ()
    0insert
#!/usr/local/bin/wish
# ==================================================================
# FILE: ""
# LAST MODIFIED: ""
# (c) 1998 by Johannes Zellner
# Johannes.Zellner@physik.uni-karlsruhe.de
# $Id:$
# ==================================================================

endfunction

function! TEXHeader ()
    0insert
% latex
% ==================================================================
% FILE: ""
% LAST MODIFIED: ""
% (c) 1998 by Johannes Zellner
% Johannes.Zellner@physik.uni-karlsruhe.de
% $Id:$
% ==================================================================

endfunction

function! JSHeader ()
    0insert
// javascript
// ==================================================================
// FILE: ""
// LAST MODIFIED: ""
// (c) 1998 by Johannes Zellner
// Johannes.Zellner@physik.uni-karlsruhe.de
// $Id:$
// ==================================================================

endfunction

function! POVHeader ()
    0insert
// povray
// ==================================================================
// FILE: ""
// LAST MODIFIED: ""
// (c) 1998 by Johannes Zellner
// Johannes.Zellner@physik.uni-karlsruhe.de
// $Id:$
// ==================================================================

endfunction


