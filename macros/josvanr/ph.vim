" *ph.vim*                                                         
"                                                                  
" SUMMARY:                                                         
"                                                                  
"     A simple html parser for vim. Define your own tags, and embed
"     vim functions in html documents.                             
"                                                                  
" SYNTAX:                                                          
"                                                                  
"     In your html files, you can use the following constructs:    
"                                                                  
"         Import the file 'myfile' into the html document:         
"                                                                  
"             <import|myfile>                                      
"                                                                  
"         Execute a vim command during parsing, eg <&let a=1>:     
"                                                                  
"             <&vimcommand>                                        
"                                                                  
"         Embed the value of a vim variable:                       
"                                                                  
"             #vimvar#                                             
"                                                                  
"         Use your own tag to call a vim fuction, with two arguments
"                                                                  
"             <mytag|arg1|arg2>                                    
"                                                                  
"         Define a new tag like this:                              
"                                                                  
"             <new|mytag>                                          
"             Content                                              
"             <tags>                                               
"             <&let file="myfile"                                  
"             <import|#file#>                                      
"             First argument: #a:2#                                
"             </new>                                               
"                                                                  
"         The <new|mytag> tag, causes a new vim function           
"         TAGmytag(...) to be defined, which is executed whenever  
"         the parser encounters the tag <mytag>. The function      
"         returns the content and tags that are put inside the     
"         <new></new> tag-pair.                                    
"                                                                  
"         The arguments arg1, arg2 etc passed to mytag, can be     
"         accessed using #a:2#, #a:3# etc. All vim variables       
"         accessed via ## inside the <new></new> tag-pair are local
"         to the function. Use #g:thevar# to access a global       
"         funtion. All constructs shown above, can also be used    
"         inside a new tag.                                        
"                                                                  
" PARSING:                                                         
"                                                                  
"     After writing your html document, it has to be parsed, to    
"     produce a valid html file. To do this, make a vim script, eg 
"     'go.vim' like this:                                          
"                                                                  
"       cd ~/www/src                                               
"                                                                  
"       let basedir="/root/www/"                                   
"       let base="file:/root/www/index.html"                       
"       let dir="1/"                                               
"       let file="index.html"|so ~/ph.vim                          
"                                                                  
"     In this file,                                                
"                                                                  
"         ~/www/src is the directory where the source html files   
"         are located,                                             
"                                                                  
"         basedir is the physical root directory, on your local    
"         harddisk, where the root of the site should be put,      
"                                                                  
"         base is the 'base' url of your site,                     
"                                                                  
"         dir is the directory, relative to basedir, where the     
"         output html files will be put,                           
"                                                                  
"         file, is the source file, where you put your own tags    
"                                                                  
"     The last line of the script invokes the parser. Add lines    
"     like that, to parse more files. When the parser is started,  
"     it produces a file 'index.html' in the directory basedir/dir.
"                                                                  
" TODO: 
" 
"    * Put the main routine in a function, maybe to enable recursive
"      calling.
"
"    * Allow making the meaning of tags dependent of their parent
"      tag. Ie <li> inside a <ul></ul> pair can be assigned a 
"      different meaning than <li> inside a <ol></ol> pair.



so ~/array.vim

let rmline=":gs?^[^\n.]*\n??"
let escq=":gs?\"?\\\\\"?"
let escqn=":gs?\"?\\\\\"?:gs?\n?\\\\n?"
let escn=":gs?\n?\\\\n?"
let rmnn=":gs?\\\\n\\\\n?\\\\n?"
let svq=":gs?#\\([^#.]*\\)#?\".\\1.\"?"
let svqg=":gs?#\\([^#.]*\\)#?\".g:\\1.\"?"
let sarg=":gs?|?\",\"?"
let rmnew=":gs?let s=s.\"</new>.*$??"
let rmlastn=":gs?\\\\n\\([^\\\\n.]*\\)$?\\1?"

fu! NextTag(sn,q,modify)
  let g:n=match(g:s,"<")
  let g:pretag=fnamemodify(strpart(g:s,0,g:n),a:modify)
  let g:s=strpart(g:s,g:n,strlen(g:s))
  let g:n=match(g:s,">")
  let g:thetag=fnamemodify(strpart(g:s,0,g:n+1),a:modify)
  if a:q=="quote"
    let sn=a:sn."let s=s.\"".g:pretag."\"\n"
  else
    exe "let g:thetag=\"".g:thetag."\""
    exe "let g:pretag=\"".g:pretag."\""
    let sn=a:sn.g:pretag
  end
  let g:a=strpart(g:thetag,1,strlen(g:thetag)-2)
  let g:tagarr=ArrGetItems(g:a,"|")
  let g:tag=ArrGet(g:tagarr,0)
  let g:arg1=ArrGet(g:tagarr,1)
  let g:s=strpart(g:s,g:n+1,strlen(g:s))
  return sn
endf

fu! Source(ss)
  let @a=a:ss|let bufc=bufnr("%")|w!|1sp _buf|norm ggVGd"aP
  w!|so _buf|bd!|exe "b".bufc
endf

w!
let htmlout=basedir.dir.file
let htmlin=basedir."src/".file
exe "e! ".htmlout
let s=system("cat  ".htmlin)|let sn=""

let n=1|wh n>-1
  let sn=NextTag(sn,"",escq.svqg)  
  if tag=="new"
    let s=fnamemodify(s,rmline)
    let ss="fu! TAG".fnamemodify(arg1,":gs?/?end?")."(...)\nlet s=\"\"\n"
    let tag=""|wh tag!="/new"
      let ss=NextTag(ss,"quote",escqn.rmnn.svq)
      if tag=="import"
        let s=system("cat '".arg1."'").fnamemodify(s,rmline)
      elseif strpart(tag,0,1)=="&"
        let s=fnamemodify(s,rmline)
        exe "let ss=ss.\"".strpart(tag,1,strlen(tag))."\".\"\n\""
      else
        let f="TAG".fnamemodify(tag,":gs?/?end?")
        if exists("*".f)
          let s=fnamemodify(s,rmline)
          let ss=ss."let s=s.".f."(\"".fnamemodify(a,sarg)."\")\n"
        else
          let ss=ss."let s=s.\"".thetag."\"\n"
        end
      end
    endwh
    let s=fnamemodify(s,rmline)
    let ss=fnamemodify(ss,rmnew.rmlastn)."return s\nendf"
    call Source(ss)
  elseif tag=="import"
    let s=system("cat '".arg1."'").fnamemodify(s,rmline)
  elseif strpart(tag,0,1)=="&"
    exe strpart(tag,1,strlen(tag))
    let s=fnamemodify(s,rmline)
  else
    let f="TAG".fnamemodify(tag,":gs?/?end?")
    if exists("*".f)
      exe "let sr=".f."(\"".fnamemodify(g:a,sarg)."\")"
      let s=sr.s
    else
      let sn=sn.thetag
    end
  end
endwh

let ch=&ch|let &ch=5
exe "e ".htmlout|norm ggVGd
let @a=sn|norm "aP
w!
let &ch=ch


