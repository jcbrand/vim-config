nmap ,e   :call ExplInitiate(0)<cr>
nmap ,s   :call ExplInitiate(1)<cr>
nmap *w   :w | :py ftp_save()<cr>

function! ExplInitiate(split, ...)
  if (expand("%:p:t")=="_fileFTPExplorer.tmp")
    echo "Already in file explorer"
  else
    let g:oldCh=&ch
	let &ch=2
    if ((&modified==1) || (a:split==1))
      sp /_fileFTPExplorer.tmp
      let b:splitWindow=1
    else
      e /_fileFTPExplorer.tmp
      let b:splitWindow=0
    endif
  endif
  " =================================
  " BE SURE THE PATH BELOW IS CORRECT
  " =================================
  pyfile /usr/share/vim/macros/ftpExplorer/ftpExplorer.py

  if ( exists('g:pwd'))
    exe "py doit('" .g:pwd. "')"
  else
    py doit()
  endif

  call Colorize()
endfunction

function! GetFileName()
  let g:selection=getline(".")
  if (match(g:selection,"/$")!=-1)
    "IT IS A DIR
    py showHelp()
    exe "py ftp_dir( pwd + '/" . g:selection ."')"
  else
    "IT IS A FILE
	let g:lastfile=g:selection
	exe "py lastfile = '" .g:lastfile. "'"
    exe "py ftp_retr('" .g:selection. "')"
  endif
  return g:selection
  endfunction

function! Colorize()
	syn	match browseHelp "^|.*|$"
	syn match browseDir  "^.*/$"
	syn match browsePWD  "^\ /.*"
	hi link browseHelp PreProc
	hi link browseDir  Directory
	hi link browsePWD  Statement

	endfunction

function! ShowLast()
  py showHelp()
  endfunction

augroup ftpExplorer
  au!
  au BufEnter _fileFTPExplorer.tmp nm <cr> :call GetFileName()<cr>
  au BufLeave _fileFTPExplorer.tmp nun <cr>
  au BufEnter _fileFTPExplorer.tmp let oldSwap=&swapfile | set noswapfile
  au BufLeave _fileFTPExplorer.tmp let &swapfile=oldSwap
