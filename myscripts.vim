if did_filetype()	" filetype already set..
    finish		" ..don't do these checks
endif
if getline(1) =~ '^## Script (Python) '
  set filetype=python
elseif getline(1) =~ '^\s*<dtml-comment>'
  source /usr/share/vim/syntax/dtml.vim
endif

