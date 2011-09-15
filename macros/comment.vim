" -*- vim -*-
" FILE: "~/.vim/contrib/macros/comment.vim"
" LAST MODIFICATION: "Wed Oct  6 18:49:40 1999 (joze)"
" $Id: comment.vim,v 1.4 1999/10/06 17:04:48 joze Exp $

"source al_funcs.vim

vnoremap .c :call CommentifyAutomatic(1)<cr>
vnoremap ,c :call CommentifyAutomatic(0)<cr>

function! CommentifyAutomatic(b_comment) range
    " check for c++ like comments first
    "
    if "c" == &ft || "cpp" == &ft || "java" == &ft || "javascript" == &ft
        let opencomm  = "// "
        let closecomm = "// "
        let midcomm   = "// "
    elseif "fortran" == &ft
        " fortran comments
        "
        let opencomm  = "C "
        let closecomm = "C "
        let midcomm   = "C "
    elseif "vim" == &ft
        let opencomm  = "\" "
        let closecomm = "\" "
        let midcomm   = "\" "
    elseif "tex" == &ft
        let opencomm  = "% "
        let closecomm = "% "
        let midcomm   = "% "
    elseif "html" == &ft || "xml" == &ft || "entity" == &ft
        let opencomm  = "<!--  "
        let closecomm = "  -->"
        let midcomm   = "      "
    elseif "config" == &ft
        let opencomm  = "dnl "
        let closecomm = "dnl "
        let midcomm   = "dnl "
    else
        " default is a shell like comment
        " note that this works also for
        " tclsh ...
        "
        let opencomm  = "# "
        let closecomm = "# "
        let midcomm   = "# "
    endif
   call Commentify(a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline)
endfunction


"A very similar function is easily produced for html etc. Just change the
"definitions of the comment elements.
"The Commentify function is rather longer and is given at the end. =)
"(along with 3 support functions, CommentifyC and Commentify HTML)

"This allows the following behaviour:
"
"1. Commentify a block.
"   - Visual Line select a block
"   - .c
"   - block is commented
"2. Uncommentify 
"   a. Select whole commented block
"      - ,c
"      - block is uncommented
"   b. Select any part of block
"      - ,c
"      - selected part of block is uncommented, surrounding code comments
"         adjusted accordingly.
"
"Examples:
"With the following code:
"
"   char* peeps[] = {
"      "Alistair Hamilton",
"      "Brian McIntosh",
"      "Allen Young",
"      "END" };
"
"1. Produces
"
"/*  
" *  char* peeps[] = {
" *     "Alistair Hamilton",
" *     "Brian McIntosh",
" *     "Allen Young",
" *     "END" };
" */
"
"2  a. Returns to uncommented state.
"   b. With lines "Alistair" to "Allen" selected:
"
"/*  
" *  char* peeps[] = {
" */
"   "Alistair Hamilton",
"   "Brian McIntosh",
"   "Allen Young",
"/*  
" *     "END" };
" */
"
"Here's the al_funcs.vim file in full.

" Commentify : A generic function for vim5.2
" allan.kelly@ed.ac.uk 07th September 1998
" Intended for use through a simple wrapper + keybinding. See CommentifyC at the
" end for an example.

fu! InsertLine ( linenum, linestring )
   exe 'normal' . ":" . a:linenum . "insert\<CR>" . a:linestring . "\<CR>.\<CR>"
endf

fu! AppendLine ( linenum, linestring )
   exe 'normal' . ":" . a:linenum . "append\<CR>" . a:linestring . "\<CR>.\<CR>"
endf

fu! SubstLine ( linenum, pat, rep, flags )
   let thislineStr = getline( a:linenum )
   let thislineStr = substitute( thislineStr, a:pat, a:rep, a:flags )
   call setline( a:linenum, thislineStr )
endf

fu! Commentify ( b_comment, opencomm, closecomm, midcomm, firstln, lastln )
   if a:b_comment
      let midline = a:firstln
      while midline <= a:lastln
         call SubstLine ( midline, '^.*$', a:midcomm . '&', "" )
         let midline = midline + 1
      endwhile
      call InsertLine ( a:firstln, a:opencomm )
      let lastln = a:lastln + 1
      call AppendLine ( lastln, a:closecomm )
   else
      let opencommMatch = escape ( a:opencomm, '*.' )
      let closecommMatch = escape ( a:closecomm, '*.' )
      let midcommMatch = escape ( a:midcomm, '*.' )
      
      let firstlnStr = getline(a:firstln) 
      if ( firstlnStr =~ '^\s*' . opencommMatch . '\s*$' )
         " We're at the top of a block. Remove the line.
         exe 'normal dd'
         let firstline = a:firstln
         let lastline = a:lastln - 1
      elseif ( firstlnStr =~ '^\s*' . midcommMatch )
         " We're in the middle of a block. Add a block-end above and uncomment 
         " this line.
         call InsertLine ( a:firstln, a:closecomm )
         call SubstLine ( a:firstln + 1,  '^' . midcommMatch, "", "" )
         let firstline = a:firstln + 2
         let lastline = a:lastln + 1
      else
         " Something weird. Abort.
         echohl Warning Msg | echo "Couldn't apply uncomment." | echohl None
         return -1
      endif
      
      if ( a:firstln == a:lastln )
         call AppendLine ( lastline, a:opencomm )
         return 0
      else
         let midline = firstline
         while midline < lastline
            call SubstLine ( midline, '^' . midcommMatch, "", "" )
            let midline = midline + 1
         endwhile
      endif
      
      let lastlnStr = getline(lastline)   
      if ( lastlnStr =~ '^\s*' . closecommMatch . '\s*$' )
         " We're at the end of a block. Remove the line.
         exe 'normal' . lastline . 'G'
         exe 'normal dd'
      elseif ( lastlnStr =~ '^\s*' . midcommMatch )
         " We're in the middle of a block. Add a block-start below and uncomment
         " this line.
         call AppendLine ( lastline, a:opencomm )
         call SubstLine ( midline, '^' . midcommMatch, "", "" )
      else
         " Proly the user went past the end of the commented block.
         let midline = firstline
         while midline < lastline
            let midlnStr = getline(midline)  
            if ( midlnStr =~ '^\s*' . closecommMatch . '\s*$' )
               " We're at the end of a block. Remove the line.
               exe 'normal' . midline . 'G'
               exe 'normal dd'
               " exe "echo 'line" . line(".") . "removed'"
               return 0
            endif
            let midline = midline + 1
         endwhile
      endif
   endif
endf


" === END file ===
"HTH someone, al.


"--
"// Allan.Kelly@ed.ac.uk ..   . .     . .
"// R117, Darwin Building   .     . .     .    . .
"// King's Buildings, Mayfield Rd  .       . .     .    . .   
"// Edinburgh EH9 3JU                       .       . .     .  ..
"// +44 131 650 6480                                 .       .    . . . .

