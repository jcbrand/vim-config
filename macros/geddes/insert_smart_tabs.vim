
There are many different arguments about tabs and stuff.  My personal
preference is a choice of tabbing that is independent of anybody's viewing
settings.  Unfortunately this would require using all spaces, forcing your
personal tab setting on the viewer or only to use tabs at the beginning of
the line.  I'd like to see MSVC do that automagicly.  I'd also like to see
Vim do that.

I know that there isn't a setting that allows this .. but *clickety-click*

imap <tab> <c-r>=InsertSmartInsideTab()<cr>
fun! InsertSmartInsideTab()
  if strpart(getline('.'),0,col('.')-1) =~'^\s*$'
    return "\<Tab>"
  endif
  if exists("b:insidetabs")
    let sts=b:insidetabs
  else
    let sts=&sts
    if sts==0
      let sts=&sw
    endif
  endif
  let sp=(virtcol('.') % sts)
  if sp==0
    let sp=sts
  endif
  return strpart("                  ",0,1+sts-sp)
endfun

There is now.

This little script does the following
	- if you are currently before the first non-space character, it lets
vim insert that tab using the current <tab> settings (ts,sw,sts,sta,et).
	- if your are after a non-space character, it inserts _spaces_
according to the variable b:insidetabs or &sw or &ts, depending on settings.
The current limitation is that the effective inside tab width has to be <
about 18 (which is the number of spaces in the 'strpart' expression ) - this
should be enough :)

If you use expandtabs then this will allow you a different tab setting for
"internal tabs". 
If you use &ts==&sw, this will allow you to read any code at any tab setting
(comments after variables , &c will still line up 'cause they use spaces).

<Rant-bit>
The only kind of setting it probably won't help is something which vim
handles quite well -  &ts != &sw  or &ts != &sts.  This kind of setting
requires 
the '&ts=8' and only 8  (or 4.. or whatever) mentality.  It does not allow
for flexibility of tabstop settings (say between viewing formats -  screen
vs printer &c).
</Rant-bit>

Share and enjoy.

//.ichael G.
