" **settings.vim**
" 
" Vim Settings. Customize this file using |setup.vim|. Hit ,s and customize.
" 
" 
" Files and directories
" 
"|SETTINGS|Files|Files and directories.|%|
"|SETTINGS|Files| |%|
"|SETTINGS|Files|Write a backup file|let &backup=||0|1|
let &backup=1
"|SETTINGS|Files| |%|
"|SETTINGS|Files|  Unix|%|
"|SETTINGS|Files| |%|
if has("unix")
"|SETTINGS|Files|Temporary files directory|set dir=|
set dir=/tmp
"|SETTINGS|Files|Backup files directory|set bdir=|
set bdir=/tmp
"|SETTINGS|Files|Shell for external commands|set sh=||bash|zsh|tcsh|sh|
set sh=zsh
else
"|SETTINGS|Files| |%|
"|SETTINGS|Files|  Dos|%|
"|SETTINGS|Files| |%|
"|SETTINGS|Files|Temporary files directory |set dir=|
set dir=c:\"\tmp\test
"|SETTINGS|Files|Backup files directory |set bdir=|
set bdir=c:\tmp
"|SETTINGS|Files|Shell for external commands |set sh=|
set sh=c:\command.com
endif

" Editing
"
"|SETTINGS|Editing|Searching|%|
"|SETTINGS|Editing| |%|
"|SETTINGS|Editing|Use incremental search|let &is=|
let &is=0
"|SETTINGS|Editing|Ignore search pattern case|let &ignorecase=|
let &ignorecase=1
"|SETTINGS|Editing|Highlight search pattern|let &hlsearch=|
let &hlsearch=1
"|SETTINGS|Editing|Replace all occurrences on line|let &gdefault=|
let &gdefault=1
"|SETTINGS|Editing| |%|
"|SETTINGS|Editing|Other|%|
"|SETTINGS|Editing| |%|
"|SETTINGS|Editing|Auto indenting|let &ai=|
let &ai=1
"|SETTINGS|Editing|Expand tabs to spaces|let &expandtab=|
let &expandtab=1
"|SETTINGS|Editing|Number of spaces in a tab|let &shiftwidth=|
let &shiftwidth=2

" Apperance 
"
"|SETTINGS|Apperance|Interface apperance|%|
"|SETTINGS|Apperance| |%|
"|SETTINGS|Apperance|Show a ruler|let &ruler=|
let &ruler=1
"|SETTINGS|Apperance|Show current mode|let &showmode=|
let &showmode=1
"|SETTINGS|Apperance|Abbreviate messages|set shortmess=|
set shortmess=at
"|SETTINGS|Apperance|Command line height|set ch=|
set ch=1
"|SETTINGS|Apperance|Hide mouse when typing|let &mousehide=|
let &mousehide=0
"|SETTINGS|Apperance|Enable mouse clicking|let &mouse=||a|
let &mouse="a"
"|SETTINGS|Apperance|Use syntax highlighting (on or off)|syntax |
syntax on

" Behaviour
"
"|SETTINGS|Behaviour|Interface behaviour|%|
"|SETTINGS|Behaviour| |%|
"|SETTINGS|Behaviour|Don't behave compatible|let &compatible=|
let &compatible=0
"|SETTINGS|Behaviour|Backspace level (2=best)|let &bs=|
let &bs=2
"|SETTINGS|Behaviour|Cut'n paste behaviour|behave ||xterm|mswin|
behave xterm
"|SETTINGS|Behaviour|Don't redraw screen in macros|let &lazyredraw=|
let &lazyredraw=1
"|SETTINGS|Behaviour|Wrap lines automatically|let &wrap=|
let &wrap=0
"|SETTINGS|Behaviour| |%|
"|SETTINGS|Behaviour|Viminfo settings|%|
"|SETTINGS|Behaviour| |%|
"|SETTINGS|Behaviour|Files for which marks are remembered|let viminfo_marks=|
let viminfo_marks=120
"|SETTINGS|Behaviour|Lines remembered for each register|let viminfo_linesreg=|
let viminfo_linesreg=150
"|SETTINGS|Behaviour|Lines in command line history|let viminfo_clhist=|
let viminfo_clhist=50
"|SETTINGS|Behaviour|Lines in search pattern history|let viminfo_spatthist=|
let viminfo_spatthist=50
"|SETTINGS|Behaviour|Lines in input line history|let viminfo_inputlinehist=|
let viminfo_inputlinehist=10

let &viminfo="'".viminfo_marks
let &viminfo=&viminfo.",\"".viminfo_linesreg
let &viminfo=&viminfo.",:".viminfo_clhist
let &viminfo=&viminfo.",/".viminfo_spatthist
let &viminfo=&viminfo.",@".viminfo_inputlinehist


" Some colors
"
"|SETTINGS|Colors|Color terminal|%|
"|SETTINGS|Colors| |%|
"|SETTINGS|Colors|Normal text background|hi Normal ctermbg=||blue|black|white|grey|255|0|
hi Normal ctermbg=255
"|SETTINGS|Colors|Comment foreground|hi Comment ctermfg=||cyan|blue|green|yellow|
hi Comment ctermfg=blue
"|SETTINGS|Colors|Comment background|hi Comment ctermbg=||cyan|blue|green|yellow|255|0|
hi Comment ctermbg=255
"|SETTINGS|Colors|Comment style|hi Comment cterm=||NONE|bold|underline|reverse|
hi Comment cterm=bold
"|SETTINGS|Colors|Search pattern foreground|hi Search ctermfg=||red|yellow|white|
hi Search ctermfg=white
"|SETTINGS|Colors|Search pattern background|hi Search ctermbg=||white|black|red|
hi Search ctermbg=black
"|SETTINGS|Colors|Search pattern style|hi Search cterm=||NONE|bold|underline|reverse|
hi Search cterm=bold
"|SETTINGS|Colors|Identifier|hi Identifier ctermfg=||
hi Identifier ctermfg=red
"|SETTINGS|Colors|Identifier|hi Statement ctermfg=||
hi Statement ctermfg=red
"|SETTINGS|Colors| |%|
"|SETTINGS|Colors|Gui|%|
"|SETTINGS|Colors| |%|
"|SETTINGS|Colors|Comment foreground |hi Comment guifg=||cyan|blue|green|yellow|
hi Comment guifg=green
"|SETTINGS|Colors|Comment style |hi Comment gui=||NONE|bold|underline|reverse|
hi Comment gui=NONE
"|SETTINGS|Colors|Search pattern foreground |hi Search guifg=||red|yellow|white|
hi Search guifg=white
"|SETTINGS|Colors|Search pattern background |hi Search guibg=||white|black|red|
hi Search guibg=black
"|SETTINGS|Colors|Search pattern style |hi Search gui=||NONE|bold|underline|reverse|
hi Search gui=bold

" Obsolete, remove later.
let echoerrormessages=0
let echowarningmessages=0
let linewidth=70
let commentwidth=80

