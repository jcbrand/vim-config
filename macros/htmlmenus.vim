" NJJ: mostly useless but use the table function. 990818 
"
"HTML Authoring macros for VIM
"by Paul Kirkaas, pkirkaas@tibco.com
" For several menu commands, executing them while selecting a visual block 
" will format the selected text according to the command.  
" Executing that same menu command while not in a visual block will simply 
" insert an example of the type of structure specified.


:inoremap <CR><CR> <p><CR><CR>
:set timeoutlen=250
:set sw=2

: let docName=expand("%:r")
": normal kA // End =className
:function! AddJumpTo()
: set paste
: normal a<A HREF="http://www.[ref].html"> VisibleLabel </A>
: set nopaste
:endfunction

"Put open & close text around the visually selected text
:function! VisWrap(open,close)
: set paste
": normal `<"xy`>`>a">"xpa</A>`<i<A HREF="http://
: normal `>a=a:close`<i=a:open
: set nopaste

:endfunction
:function! VisAddLink(open,close)
: set paste
": normal `<"xy`>`>a">"xpa</A>`<i<A HREF="http://
: normal `<"xy`>`>a">"xpa</=a:close>`<i<=a:open
: set nopaste
:endfunction


:function! AddIncludeGraphic()
: set paste
: normal a<IMG SRC="http://www.[ref]">
: set nopaste
:endfunction

:function! MakeHeader(style)
: set paste
: normal   I<=a:style>A</=a:style> 
: set nopaste
:endfunction

:function! AddTable()
: set paste
: normal a<Table BORDER=3 Width=100% >  <Caption> Table Caption </Caption>
: normal o  <TR> <TH ColSpan=2> Table Header </TH> </TR>
: normal o  <TR> <TH Width=10> HEADER1 </TH> <TH> HEADER2 </TH> </TR>
: normal o  <TR> <TD> Col1 </TD> <TD> Col2 </TD> </TR>
: normal o  <TR> <TD> Col1 </TD> <TD> Col2 </TD> </TR>
: normal o</Table>
: set nopaste
:endfunction

:function! AddMailTo()
: set paste
: normal i<a href="mailto:ME@MYPLACE.COM">MyName</a>
: set nopaste
:endfunction

:function! MakeDocTemplate()
: let docName=expand("%:r")
: set paste
: normal 1GO<HTML><HEAD><TITLE>=docName</TITLE></HEAD>
": normal o<BODY BGCOLOR=#FFFFFF TEXT=#000000><H1>=docName</H1>
: normal o<BODY BGCOLOR=#FFFFFF TEXT=#000000>
: normal o<font size=+3><center><b>=docName</b></center></font><p>
: normal o<font size=+1><center>Paul Kirkaas </center></font><p>
: normal Go</Body></html>
: set nopaste
:endfunction

:function! UnorderedList()
: set paste
: normal o<ul>
: normal o  <li> First Item
: normal o  <li> Successive Items
: normal o</ul>
: set nopaste
:endfunction

"Call only from visual mode!
"Takes a visually selected group of lines & makes them an html list.
:function! VisList(listType)
: set paste
: normal :'<,'>s/^/<li>
: normal '<O<=a:listType>
: normal '>o</=a:listType>
: set nopaste
:endfunction

"Call only from visual mode!
"Takes a visually selected group of lines & makes them an html table.
"  Use <tab>s to separate columns.
:function! VisTable()
: set paste
: normal :'<,'>s/^/<TR><TD>
: normal :'<,'>s/$/<\/TD><\/TR>
: normal :'<,'>s/\t/<\/TD> <TD>/g
: normal '<O<Table BORDER=3 Width=100% >  <Caption> Table Caption </Caption>
: normal '>o</Table>
: set nopaste
:endfunction

:function! OrderedList()
: set paste
: normal o<ol>
: normal o  <li> First Item
: normal o  <li> Successive Items
: normal o</ol>
: set nopaste
:endfunction


:function! Bold()
: normal i<b>"*pa</b>
:endfunction

:function! Italicize()
: normal i<i>"*pa</i>
:endfunction

:function! MakeStyle(style)
: normal   i<=a:style>"*pa</=a:style> 
:endfunction

:function! MakeStyle2(open,close)
: normal   i=a:open"*pa=a:close 
:endfunction


:amenu &Html.&Add.&Links.&JumpTo   :call AddJumpTo()
:amenu &Html.&Add.&Links.&IncludeGraphic :call AddIncludeGraphic()
:amenu &Html.&Add.&Links.&MailTo :call AddMailTo()
:amenu &Html.&Add.&Structures.&Table :call AddTable()
:vmenu &Html.&Add.&Structures.&Table<tab>Visually\ select\ tab\ separated\ columns. :call AddTable()
:amenu &Html.&Add.&Structures.&OrderedList :call OrderedList()
:amenu &Html.&Add.&Structures.&UnorderedList :call UnorderedList()
:amenu &Html.&Templates.&Document :call MakeDocTemplate()

"Visual mode overrides...
:vmenu &Html.&Add.&Structures.&OrderedList :call VisList("ol")
:vmenu &Html.&Add.&Structures.&UnorderedList :call VisList("ul")
:vmenu &Html.&Add.&Structures.&Table :call VisTable()
:vmenu &Html.&Add.&Links.&JumpTo   :call VisAddLink("A HREF=\"http:/","A")
:vmenu &Html.&Add.&Links.&MailTo   :call VisAddLink("A HREF=\"mailto:","A")
:vmenu &Html.&Add.&Links.&IncludeGraphic :call VisWrap("<IMG SRC=\"http:/","\">")


"Formatting menus
:vmenu &Html.&Format.&Styles.&Header.1 "*x:call MakeStyle("h1")
:nmenu &Html.&Format.&Styles.&Header.1 :call MakeHeader("h1")

:vmenu &Html.&Format.&Styles.&Header.2 "*x:call MakeStyle("h2")
:nmenu &Html.&Format.&Styles.&Header.2 :call MakeHeader("h2")

:vmenu &Html.&Format.&Styles.&Header.3 "*x:call MakeStyle("h3")
:nmenu &Html.&Format.&Styles.&Header.3 :call MakeHeader("h3")

:vmenu &Html.&Format.&Styles.&Header.4 "*x:call MakeStyle("h4")
:nmenu &Html.&Format.&Styles.&Header.4 :call MakeHeader("h4")

:vmenu &Html.&Format.&Font.Styles.&Bold "*x:call MakeStyle("b")
:nmenu &Html.&Format.&Font.Styles.&Bold B"*de:call MakeStyle("B")

:vmenu &Html.&Format.&Font.Styles.&Italic "*x:call MakeStyle("i")
:nmenu &Html.&Format.&Font.Styles.&Italic B"*de:call MakeStyle("i")

:vmenu &Html.&Format.&Font.Styles.&Big "*x:call MakeStyle("Big")
:nmenu &Html.&Format.&Font.Styles.&Big B"*de:call MakeStyle("Big")


:vmenu &Html.&Format.&Font.Styles.&Typewriter "*x:call MakeStyle("TT")
:nmenu &Html.&Format.&Font.Styles.&Typewriter B"*de:call MakeStyle("TT")


:vmenu &Html.&Format.&Font.Styles.&Small "*x:call MakeStyle("Small")
:nmenu &Html.&Format.&Font.Styles.&Small B"*de:call MakeStyle("Small")


:vmenu &Html.&Format.&Font.Styles.&Strike "*x:call MakeStyle("Strike")
:nmenu &Html.&Format.&Font.Styles.&Strike B"*de:call MakeStyle("Strike")


:vmenu &Html.&Format.&Font.Styles.&Underlined "*x:call MakeStyle("U")
:nmenu &Html.&Format.&Font.Styles.&Underlined B"*de:call MakeStyle("U")


:vmenu &Html.&Format.&Font.Size.&Absolute "*x:call MakeStyle2("<font size=3>","</font>")
:nmenu &Html.&Format.&Font.Size.&Absolute B"*de:call MakeStyle2("<font size=3>","</font>")

:vmenu &Html.&Format.&Font.Size.&Relative "*x:call MakeStyle2("<font size=+1>","</font>")
:nmenu &Html.&Format.&Font.Size.&Relative B"*de:call MakeStyle2("<font size=+1>","</font>")


