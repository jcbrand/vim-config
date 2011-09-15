" Vim syntax file
" Language:  browse
" Last change: Sun Feb 20 2000

"Remove any old syntax stuff hanging around
syn clear

syn match helpSynopsis          "^\".*"
syn match browseDirectory       "[^\"].*/$"

if !exists("did_explorer_syntax_inits")
  let did_explorer_syntax_inits = 1
  hi link helpSynopsis          Comment
  hi link browseDirectory       Directory
endif

let b:current_syntax = "browser"
