" -*- vim -*-
"
" FILE: "/home/joze/share/vim/functions/Header.vim"
" LAST MODIFICATION: "Mon Apr 26 17:44:35 1999 (joze)"
" (C) 1998, 1999 by Johannes Zellner
" johannes@zellner.org
" $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $


command! -nargs=? Header call Header (<q-args>)

autocmd BufNewFile * call Header ("")
autocmd BufWritePre,FileWritePre  * call HeaderTimeStamp ()



function! GuessHeader ()
    if expand ("%:e") == "c"
        call CHeader ()
    elseif expand ("%:e") == "cc" || expand ("%:e") == "C" || expand ("%:e") == "cxx" || expand ("%:e") == "h" || expand ("%:e") == "cpp"
        call CCHeader ()
    elseif expand ("%:e") == "f" || expand ("%:e") == "F"
        call FHeader ()
    elseif expand ("%:e") == "sh"
        call SHHeader ()
    elseif expand ("%:e") == "vim" || expand ("%:e") == "fcn" || expand ("%:e") == "mac" || expand ("%") == ".vimrc"
        call VIMHeader ()
    elseif expand ("%:e") == "tcl" || expand ("%:e") == "itcl"
        call TCLHeader ()
    elseif expand ("%:e") == "tk" || expand ("%:e") == "itk"
        call TKHeader ()
    elseif expand ("%:e") == "tex"
        call TEXHeader ()
    elseif expand ("%:e") == "java"
        call JAVAHeader ()
    elseif expand ("%:e") == "js"
        call JSHeader ()
    elseif expand ("%:e") == "pov"
        call POVHeader ()
    elseif expand ("%:e") == "snk"
        call SNARKHeader ()
    elseif expand ("%:e") == "mk" || match (expand ("%:t"), "[Mm]akefile") != -1
        call MAKEHeader ()
    elseif expand ("%:e") == "html"
        call HTMLHeader ()
    else
        call TCLHeader ()
endfunction

function! HeaderTimeStamp ()

    ks

    let errmsg = ""
    ijump! /FILE:[^<\"]*[<\"]/
    if (errmsg == "")
        exec 's#FILE:[^<\"]*\([<\"]\)[^>\"]*\([>\"]\)#FILE: \1' . expand ("%:p") . '\2#ge'
    endif

    let errmsg = ""
    ijump! /Time-stamp:\|LAST MODIFIED:\|LAST MODIFICATION:/
    if (errmsg == "")
    exec 's#\(Time-stamp:\|LAST MODIFIED:\|LAST MODIFICATION:\)\([^<\"]*\)\([<\"]\)\([^>\"]*\)\([>\"]\)#\1 \3'.strftime ("%c").' ('.$USER.')\5#ge'
    endif

    's

endfunction

function! Header (...)
    
    if a:1 == ""
        call GuessHeader ()
    elseif a:1 == "c"
        call CHeader ()
    elseif a:1 == "h" || a:1 == "cc" || a:1 == "C" || a:1 == "cpp"
        call CCHeader ()
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
    elseif a:1 == "java"
        call JAVAHeader ()
    elseif a:1 == "js"
        call JSHeader ()
    elseif a:1 == "pov"
        call POVHeader ()
    elseif a:1 == "snark" || a:1 == "snk"
        call SNARKHeader ()
    elseif a:1 == "html"
        call HTMLHeader ()
    else
        echo "unknown header"
        return
    endif

    call HeaderTimeStamp ()

endfunction

function! CCHeader ()

    0insert
// -*- C++ -*-
//
// FILE: ""
// LAST MODIFICATION: ""
// (C) 1999 by Johannes Zellner
// johannes@zellner.org
// $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $
.
    "call CProg ()

endfunction


function! CHeader ()

    0insert
/* -*- C -*-
 *
 * FILE: ""
 * LAST MODIFICATION: ""
 * (C) 1999 by Johannes Zellner
 * johannes@zellner.org
 * $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $
 */
.
    "call CProg ()

endfunction

function! FHeader ()
    0insert
C     -*- FORTRAN -*-
C
C     FILE: ""
C     LAST MODIFICATION: ""
C     (C) 1999 by Johannes Zellner
C     johannes@zellner.org
C     $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! SHHeader ()
    0insert
#!/bin/sh
#
# FILE: ""
# LAST MODIFICATION: ""
# (C) 1999 by Johannes Zellner
# johannes@zellner.org
# $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! MAKEHeader ()
    0insert
# -*- gmake -*-
#
# FILE: ""
# LAST MODIFICATION: ""
# (C) 1999 by Johannes Zellner
# johannes@zellner.org
# $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

BASE =
include ~/make/c.mk

endfunction

function! VIMHeader ()
    0insert
" -*- vim -*-
"
" FILE: ""
" LAST MODIFICATION: ""
" (C) 1999 by Johannes Zellner
" johannes@zellner.org
" $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! TCLHeader ()
    0insert
#!/usr/local/bin/tclsh
#
# FILE: ""
# LAST MODIFICATION: ""
# (C) 1999 by Johannes Zellner
# johannes@zellner.org
# $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! TKHeader ()
    0insert
#!/usr/local/bin/wish
#
# FILE: ""
# LAST MODIFICATION: ""
# (C) 1999 by Johannes Zellner
# johannes@zellner.org
# $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! TEXHeader ()
    0insert
% -*- latex -*-
%
% FILE: ""
% LAST MODIFICATION: ""
% (C) 1999 by Johannes Zellner
% johannes@zellner.org
% $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! JAVAHeader ()
    call CHeader ()
endfunction

function! JSHeader ()
    0insert
// -*- javascript -*-
//
// FILE: ""
// LAST MODIFICATION: ""
// (C) 1999 by Johannes Zellner
// johannes@zellner.org
// $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! POVHeader ()
    0insert
// -*- povray -*-
//
// FILE: ""
// LAST MODIFICATION: ""
// (C) 1999 by Johannes Zellner
// johannes@zellner.org
// $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

function! HTMLHeader ()
    0insert
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<!-- FILE: ""
     LAST MODIFICATION: ""
     (C) 1999 by Johannes Zellner
     johannes@zellner.org
     $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $ -->
<html lang="en">
<head>
    <title>__TITLE__</title>
    <link rev=Made href="mailto:johannes@zellner.org">
    <link rel=Start href="./">
    <link rel=Copyright href="http://www.zellner.org/copyright.html">
    <link rel=StyleSheet href="css/misc.css" type="text/css">
    <script language="javascript" src="javascript/buttons.js"> </script>
    <meta name="author" content="Johannes Zellner">
    <meta name="description" content="__DESCRIPTION__">
    <meta name="keywords" content="__KEYWORDS__">
</head>


endfunction


function! SNARKHeader ()
    0insert
* -*- snark93 -*-
*
* FILE: ""
* LAST MODIFICATION: ""
* (C) 1999 by Johannes Zellner
* johannes@zellner.org
* $Id: Header.vim,v 1.1 1999/04/27 14:11:11 joze Exp $

endfunction

