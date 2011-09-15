" **comments.vim**                                                           
"                                                                            
" Commenting sections of code or text.                                       
"                                                                            
" FUNCTIONS:                                                                 
"                                                                            
"    call ToggleCommentLn(width,line)                                         
"                                                                            
" Toggle the comment on the given line number, use given width for      
" second comment sign. Comment string types are automatically set for   
" several filetypes, eg "<!--" and "-->" for .html and .htm files.                   
"                                                                            
"  MAPS:                                                                      
"                                                                            
"     s     Toggle the comment on the current line, and go down one line.                             
"                                                                          
" EXAMPLE:                                                              
"                                                                            
"      Consecutive pressing s tree times with the cursor on the first        
"      line of the lines                                                     
"                                                                            
"          test line in a vim file                                           
"          another one which                                                 
"          " the last one is already commented                       "       
"                                                                            
"       results in                                                           
"                                                                            
"          " test line in a vim file                                 "       
"          " another one which                                       "       
"          the last one is already commented                                 
"                                                                            
"                                                                            
" NOTES:                                                                     
"                                                                            
"   * For adding a second comment string, spaces have to be appended         
"     at the end of the line. Therefore, when uncommenting, all spaces       
"     are removed at the end of the line.                                    
"                                                                            
"   * When the width of a line to be commented exceeds tw+cmo+cmc,           
"     the line is commented anyway, the second comment string is just        
"     put after the line.                                                    
"                                                                            
"   * For formatting a commented paragraph, uncomment it first, then         
"     use gq, then comment it again. Eg: type vipsvipgqvips                  
"                                                                            
" --------------------------------------------------------------------------
map s :call ToggleCommentLn(&tw+cmo+cso,line("."))<cr>j
" -------------------------------------------------------------------------- "
if !exists("_comments_vim_sourced")
let _comments_vim_sourced=1
" -------------------------------------------------------------------------- "
let comments_margin=4

aug comm
  au!
  au bufenter * let cso="  "|let csc=""|let cpo="  "|let cpc=""|let cmo=1|let cmc=0
  au bufenter *vimrc*,*.vim,vim* let cso="\""|let csc=""|let cpo="\\\""|let cpc=""|let cmo=1|let cmc=0
  au bufenter *.c,*.h,*.cpp,*.cc let cso="/*"|let csc="*/"|let cpo="/\\*"|let cpc="\\*/"|let cmo=1|let cmc=1
  au bufenter *.cc,*.h,*.cpp let cso="//"|let csc=""|let cpo="//"|let cpc=""|let cmo=1|let cmc=0
  au bufenter *.tex,*.sty let cso="%"|let csc=""|let cpo="%"|let cpc="%"|let cmo=1|let cmc=0
  au bufenter *.html,*.htm let cso="<!--"|let csc="-->"|let cpo="<!--"|let cpc="-->"|let cmo=1|let cmc=1
  au bufenter *.pl,*.pm let cso="#"|let csc=""|let cpo="#"|let cpc=""|let cmo=1|let cmc=0
aug END

fu! ToggleCommentLn(wh,ln)
  let str=getline(a:ln)
  if g:cso!=""
    if match(strpart(str,0,g:comments_margin),g:cpo)>=0
      let str=fnamemodify(str,":gs?^ *".g:cpo." \\=??")
      if g:cpc!=""
        let g:a=str
        let str=fnamemodify(g:a,":gs? *".g:cpc." *$??")
      end
      call setline(a:ln,str)
    else
      let npad=a:wh-strlen(str)-g:cmo-g:cmc
      call setline(a:ln,g:cso.StrNTimesChar(" ",g:cmo).str.StrNTimesChar(" ",npad).StrNTimesChar(" ",g:cmc).g:csc)
    endif
  end
endf

" Old stuff, obsolete:
augroup comments
au!
au bufenter * let commentlinestyle="-"
au bufenter *.html let commentlinestyle="="
au bufenter *.c,*.cc,*.cpp,*.h let commentlinestyle="*"
au bufenter *.tex let commentlinestyle="%"
au bufenter _vimrc*,*.vim let commentlinestyle="-"

" Comment strings
au bufenter * let commentstringopen="> "
au bufenter * let commentstringclose=""
au bufenter *.vim,_vimrc* let commentstringopen="\" "
au bufenter *.vim,_vimrc* let commentstringclose=""
au bufenter *.tex let commentstringopen="% "
au bufenter *.tex let commentstringclose=""
au bufenter *.c,*.h let commentstringopen="/\* "
au bufenter *.c,*.h let commentstringclose=" \*/"
au bufenter *.cc,*.cpp let commentstringopen="// "
au bufenter *.cc,*.cpp let commentstringclose=""
au bufenter *.html,*.htm let commentstringopen="<!-- "
au bufenter *.html,*.htm let commentstringclose=" -->"

au bufenter *.c,*.html,_vimrc*,*.vim let linewidth=commentwidth-strlen(commentstringopen)-strlen(commentstringclose)-1
augroup END
" --------------------------------------------------------------------------- "
endif
" --------------------------------------------------------------------------- "
