" buffoptions.vim  : Per-Buffer options/maps/menus
" Michael Geddes<michaelg@netspace.net.au>


" Push options onto a stack - this sets the new value and remembers the old values
" The list is a series of "variable", "value" pairs.
" 'variable' can also be of the form '[nvoic]*map <LHS>' 
"    eg 'vmap <f4>'
" or of the form '[anvoic]*menu <LHS>' 
"   eg 'vmenu Tools.Test' or 'vmenu 100.100 Tools.Test'
"


fun! PushOption( ... )
	if !exists("b:optionStack") 
	  let b:optionStack=''
	endif
	let c=1
	let sep='|'
	while c < a:0
	  exe 'let option=a:'.c
	  let ax='^\(i\=abbr\(ev\)\=\)\s\+'
	  let mx='^!\=\([nvoic]*\)map\s\+'
	  let menx='^!\=\([anvoic]*\)menu\s\+'
	  if option =~ mx
		let modes=substitute(matchstr(option,mx),mx,'\1','')
		if option[0] == '!'
		  let nore='nore'
		else
		  let nore=''
		endif
		let option=substitute(option,mx,'','')
		let ma=0
		while ma < strlen(modes)
		  let rhs=maparg(option,modes[ma])
		  if rhs==""
			let b:optionStack=modes[ma].'unmap '.option.sep.b:optionStack
		  else
			let b:optionStack=modes[ma].'map '.option.' '.rhs.sep.b:optionStack
		  endif
		  exe 'let nrhs=a:'.(c+1)
		  exe modes[ma].nore.'map '.option.' '.nrhs
		  let ma=ma+1
		endwhile
	  elseif option =~ ax
		" At the moment we can't silently get the old abbreviation, and it will
		" be a rare thing for it to be needed
		let lhs=substitute(option,ax,'','')
		let b:optionStack='iuna '.lhs.sep.b:optionStack
		exe 'let rhs=a:'.(c+1)
		exe 'iabbr '.lhs.' '.rhs
	  elseif option =~ menx
		" We can't silently get the old menus, which is a problem at the moment.
		let modes=substitute(matchstr(option,menx),menx,'\1','')
		if option[0] == '!'
		  let nore='nore'
		else
		  let nore=''
		endif
		let option=substitute(option,menx,'','')
		let ma=0
		while ma < strlen(modes)
"		  let rhs=menuarg(option,modes[ma])  " Don't have this :(
"		  if rhs==""
		    let b:optionStack=modes[ma].'unmenu '.option.sep.b:optionStack
"		  else
"		    let b:optionStack=modes[ma].'menu '.option.' '.rhs.sep.b:optionStack
"		  endif
		  exe 'let nrhs=a:'.(c+1)
		  exe modes[ma].nore.'menu '.option.' '.nrhs
		  let ma=ma+1
		endwhile
	  else
		" try not to remember any of the per-buffer options
		if option !~ '\<\(ts\|sw\|tabstop\|shiftwidth\|softtabstop\|sts\)\>'
		  exe 'let curval=&'.option
		  let b:optionStack='let &'.option."='".curval."'".sep.b:optionStack
		endif
		exe 'let &'.option.'=a:'.(c+1)
	  endif
	  let c=c+2
	  if b:optionStack!='' 
		 let sep='|'
	  endif
	endwhile
endfun

" Restore the options pushed onto the stack
fun! RestoreOptions()
  if exists("b:optionStack")
	exe b:optionStack
	let b:optionStack=''
  endif
endfun

"Effectively Create some Buffer Enter and Leave FileType autocommands.
" Append "Enter" and "Leave" to the filetype to get the autocommand
aug MRGEnterLeave
au!
au BufEnter * exe "do FileType ".&filetype."Enter"
au BufLeave * exe "do FileType ".&filetype."Leave"
aug END

" This is a little trick to allow mappings defined for a particular file within
" the file. The lines recognized are : 
"<comment>vimexe:"option1","value","nmap map2","value2
" where the arguments are the same as for PushOption.
" 
"vimexe:"nmap <c-cr>",":echo 'hi'<cr>"
"vimexe:"nmap <m-p>",":echo 'hi ther'<cr>"

"aug MyOpts
"au!
"au FileType vimEnter call GetOptionsFromFile('"')
"au FileType vimLeave call RestoreOptions() 
"aug END

fun! GetOptionsFromFile(com)
  if !exists("b:VIMEXE")
	let mx='^'.a:com.'vimexe:\s*\(.*\)$'
	let x=''
	let i=1
	while i<10
	  let cur=getline(i)
	  if cur =~ mx 
		let x=x.'call PushOption('.substitute(getline(i),mx,'\1','').")\|"
	  endif
	  let i=i+1
	endwhile
	let b:VIMEXE=x	
  endif
  exe b:VIMEXE
endfun 

" And now for an example of how to use it:
"
"aug specialEdit
"au!
"au FileType sgmlEnter call PushOption("keywordprg","/bin/htmlkey")
"au FileType cEnter call PushOption("breakat",". )&|",  "complete",".,k/usr/dict,]",  "nmap <c-enter>","<esc>o","amenu 10.100 Tools.Compile\\ C",":make<cr>" )
"
"au FileType sgmlLeave,cLeave  call RestoreOptions()
"aug END

" This allows you to source a file and have the maps (and menus?) be entered into
" a per-filetype list.  The file also gets sourced without the maps... so any
" functions get loaded.

" Usage: call ReadFileTypeMap('txt',$home.'/vim/txtmappings.vim')
" This will cause the mappings for ~/vim/txtmappings.vim to be available in
" file of FileType 'txt'.

if has("unix")
  fun! ExeNoMaps( filename)
	let tname=tempname()
	call system('grep -v "^[ 	]*[oanvi]*map" '.a:filename.'|grep -v "^[ 	]*[nvia]*menu" |tee '.tname.'')
	exe "so ".tname
	call delete(tname)
  endfun

  fun! FileText( filename)
	return system('cat '.a:filename)
  endfun

elseif has("win32") || has("dos32")

  fun! ExeNoMaps( filename )
	let tname=tempname()
	call system('findstr /V/R "^[ 	]*[oanvi]*map" '.a:filename.'|findstr/V/R "^[ 	]*[nvia]*menu" |tee '.tname.'')
	exe "so ".tname
	call delete(tname)
  endfun

  fun! FileText( filename)
	return system('type '.a:filename)
  endfun

else
  call confirm("Unknown system\nNeeds to be defined in buffoptions.vim.", "OK")
endif



fun! ReadFileTypeMap( filetype, filename )
  if !filereadable(a:filename)
	  return "NO"
  endif
  aug FileTypeMap
  exe "au! FileType ".a:filetype."Enter"
  exe "au! FileType ".a:filetype."Leave call RestoreOptions()"

  let filetext=FileText(a:filename)."\n"
  " The '\n' here guarantees the loop below will terminate.

  let mx='^\s*\([onvia]*\)\(map\|menu\)\s\+\(\S*\)\s\+\(.\{-}\)\s*$'

  let callcode=""

  while(filetext!="")
	let index=match(filetext,"\n")
	let curbit=strpart(filetext,0,index)
	let filetext=strpart(filetext,index+1,65535)
	if curbit=~mx
	  let mapt = substitute(curbit,mx,'\1','')
	  let mapa = substitute(curbit,mx,'\2 \3','')
	  let mapb = substitute(curbit,mx,'\4','')
	  if mapt==''
		let mapt='nvo'
	  endif
	  exe 'au FileType '.a:filetype."Enter call PushOption(\"".escape(mapt.mapa,'\"')."\",\"".escape(mapb,'\"')."\")"
	endif
  endwhile
  aug END
  call ExeNoMaps(a:filename)
  return "YES"
endfun
if 0
let filename =$home.'/vim/findtxt.vim'
echo filename
call ReadFileTypeMap('fred',filename)
endif
	

