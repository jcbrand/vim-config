" ==================================================================
" Changes:      By njj, between curly brackets { }
" File:         ~/.vim/contrib/macros/html.vim
" Availability: This file is available {in its original form} from
"               <URL:http://www.avalon.net/~drenze/>
" Purpose:      Key mappings for HTML-editing
" Author:       Doug Renze (drenze@avalon.net)
"               modified by Ives Aerts (ives@sonytel.be)
"               incorporating mappings by Sven Guckes (guckes@vim.org)
"               (guckes@math.fu-berlin.de)
"               <URL:http://www.math.fu-berlin.de/~guckes/>
"               { Further modified by Jean Jordaan 
"                 (rgo_anas@rgo.sun.ac.za) } 
"               990815: Incorporating changes by Eric Agnew
"               <agnew@outlook.net>
" Comments:     In the following, the authorship should generally 
"               be attributed as follows: 
"       	    The Comment Tag
"                   imap _cm <!--  --><Esc>Bhi      <--Doug Renze
"                   vmap _cm xi<!--  --><Esc>3hP    <--Ives Aerts
"                   iab  Ycom <!--  --><ESC>hhhhi   <--Sven / Jean
"                   vmap ,com "zdi<-- <C-R>z --><ESC>?<-- <C-M>eeb
"               Please send comments to me { us! } - email preferred!
" Last update:  990815 12:21:01
"               
" For other comments and info, see comments throughout.
" ==================================================================
"
" { I am attempting to bring these macros into conformance with
"   HTML 4.0 -- all existing attributes which have not been included
"   are deprecated by the HTML 4.0 standard, mostly in favour of CSS.
"   By adding the (4.0) to tags, I do not mean to imply that they 
"   were introduced by the 4.0 specification; only that they are 
"   included in that specification. }
"
" HTML Macros
"
"	I designed this set of HTML macros mainly for my personal use.
"	They're based on the markup tags in the back of _Web_Weaving_
"	by Tilton, et. al.  Actually, they're taken almost verbatim
"	from the back of _Web_Weaving_ by Tilton, et. al.  If you've
"	read the book, you'll recognize the organization--by letter,
"	then alphabetically within that letter.  They're also noted
"	if they're 3.0 or Netscape-specific, as well as if they're
"	header-specific...all per _Web_Weaving_.
"
"	I had to comment some of the macros out so that they would
"	all load.  I primarily commented out the 3.0 macros, because
"	they're not widely-supported yet.  Comment and uncomment to
"	your heart's content.
"
"	These macros may be freely copied and modified.  If you
"	find them useful, I'd appreciate hearing about it!
"
"	Peace - doug
"	drenze@avalon.net
"
" Edit this file
  nmap ,ha :e$vim/macros/html.vim<C-M>
" Done editing this file
  nmap ,hb :w<C-M>:so%<C-M>:bd<C-M>
"
" General Markup Tags
"
"	The Comment Tag
  imap _cm <!--  --><Esc>Bhi
  vmap _cm xi<!--  --><Esc>3hP
  iab  Ycom <!--  --><ESC>hhhhi
  vmap ,com "zdi<-- <C-R>z --><ESC>?<-- <C-M>eeb
"
"   ATTRIBUTE GROUPS
"       %coreattrs
  iab  Ycore id="" <CR><Tab>class="" <CR><Tab>style="" <CR><Tab>title="" <CR><Tab>
"       %i18n
  iab  Yi18n lang="" <CR><Tab>dir="ltr\\|rtl"<CR>
"       %events
  iab  Yevents onclick="" <CR><Tab>ondblclick="" <CR><Tab>onmousedown="" <CR><Tab>onmouseup="" <CR><Tab>onmouseover="" <CR><Tab>onmousemove="" <CR><Tab>onmouseout="" <CR><Tab>onkeypress="" <CR><Tab>onkeydown="" <CR><Tab>onkeyup="" <CR><Tab>  
"       %cellhalign
  iab  Yhalign align="(left\|center\|right\|justify\|char)" <CR><Tab>char="" <CR><Tab>charoff=""<CR>
"       %cellvalign
  iab  Yvalign align="(left\|center\|right\|justify\|char)" <CR><Tab>
"
"	A
"		A HREF (anchor hyperlink)
  imap _ah          <A HREF=""></A><Esc>?"<CR>i
  vmap _ah          xi<A HREF="XXX"><Esc>pa</A><Esc>?"XXX"<CR>l3s
  iab  Yhref        <a href=""></a><ESC>?""<CR>a
  iab  Yanchor    <a core i18n events charset="" <CR><Tab>type="" <CR><Tab>name="" <CR><Tab>href="" <CR><Tab>hreflang="" <CR><Tab>target="" <CR><Tab>rel="" <CR><Tab>rev="" <CR><Tab>accesskey="" <CR><Tab>shape="" <CR><Tab>coords="" <CR><Tab>tabindex="" <CR><Tab>onfocus="" <CR><Tab>onblur=""></a><Esc>?<a core<CR>w
  vmap ,href        "zdi<a href=""><C-R>z</a><ESC>F"i
"            Insert/make reference link to overview list (short"cut")
  iab  Ycut  <a href="#"<C-I>></a><ESC>F#a
  vmap ,cut  "zdi<a href="#<C-R>z"<C-I>><C-R>z</a><ESC>2F>
"            Insert/make reference link with complete URL
" iab  Ylink <a href=""<CR><C-I>></a><ESC>?""<CR>a
  vmap ,link "zdi<a href="<C-R>z"<C-M><C-I>><C-R>z</a><ESC>2F>
"            Insert/make mailto link
  iab  Ymail <a href="mailto:"></a><ESC>?:<CR>a
  vmap ,mail "zdi<a href="mailto:<C-R>z"><C-R>z</a><ESC>2F>
" 
"		A NAME (named anchor)
  imap _an <A NAME=""></A><Esc>?"<CR>i
  vmap _an xi<A NAME="XXX"><Esc>pa</A><Esc>0?\"XXX\"?s+3<CR>v2h
  iab  Yname <a name=""></a><ESC>?""<CR>a
  vmap ,name "zdi<a name="<C-R>z"<C-M><C-I>><C-R>z</a><ESC>2F>
"
"		ABBR (abbreviation) (4.0)
  imap _ab <ABBR></ABBR><Esc>bhhi
  vmap _ab xi<ABBR></ABBR><Esc>8hP
  iab  Yabbr <ABBR core i18n events ></ABBR><Esc>?core<CR>
"
"		ACRONYM (3.0) (4.0: Replaced by ABBR)
" imap _ac <ACRONYM></ACRONYM><Esc>bhhi
" vmap _ac xi<ACRONYM></ACRONYM><Esc>9hP
"
"		ADDRESS (information on author) (4.0)
  imap _ad <ADDRESS></ADDRESS><Esc>bhhi
  vmap _ad xi<ADDRESS><CR></ADDRESS><Esc>P
  imap Yaddress <ADDRESS core i18n events ></ADDRESS><Esc>?core<CR>
"
"       APPLET (Java applet) (4.0: Deprecated in favor of the OBJECT element)
  imap Yapplet <APPLET core codebase ="" <CR><Tab>archive ="" <CR><Tab>code="" <CR><Tab>object ="" <CR><Tab>alt ="" <CR><Tab>name="" <CR><Tab>width ="" <CR><Tab>height ="" <CR><Tab>align="" <CR><Tab>hspace ="" <CR><Tab>vspace =""></APPLET><Esc>?core<CR>
"
"       AREA (4.0)
  imap Yarea <AREA core i18n events shape="" <CR><Tab>coords="" <CR><Tab>href ="" <CR><Tab>target ="" <CR><Tab>nohref="" <CR><Tab>alt="" <CR><Tab>tabindex ="" <CR><Tab>accesskey ="" <CR><Tab>onfocus ="" <CR><Tab>onblur =""></AREA><Esc>?core<CR>
"
"		AU (author) (3.0) (4.0: Replaced by ADDR)
"  imap _au <AU></AU><Esc>bhhi
"  vmap _au xi<AU></AU><Esc>4hP
"	
"	B
"		B (bold) (4.0)
  imap _bo <B></B><Esc>hhhi
  vmap _bo xi<B></B><Esc>3hP
  iab  Yb   <b></b><ESC>T>i 
" vmap ,b   c<b><c-r>"</b><esc>F>
" Eric Agnew: 
  vmap  ,b  c<b></b><C-O>F<<C-R>"<ESC>
  imap Ybold <b core i18n events></b><Esc>?core<CR>
"
"		BANNER (3.0)
" imap _ba <BANNER></BANNER><Esc>bhhi
"
"		BASE (head) (4.0)
  imap _bh <BASE href="" target=""><Esc>?""<CR>
  iab  Ybase <BASE href="" target=""><Esc>?""<CR>
"
"		BASEFONT (Netscape) (4.0: Deprecated)
" imap _bf <BASEFONT SIZE=><Esc>i
"
"       BDO (Overriding the i18n bidirectional algorithm) (4.0)
  iab  Ybdo <BDO core lang="" <CR><Tab>dir=""></BDO><Esc>?core<CR>
"
"		BIG (3.0) (4.0: Deprecated in favour of CSS)
" imap _bi <BIG></BIG><Esc>bhhi
  vmap _bi xi<BIG></BIG><Esc>5hP
  iab  Ybig <BIG core i18n events></BIG><Esc>?core<CR>
"
"		BLOCKQUOTE
  imap _bl <BLOCKQUOTE><CR></BLOCKQUOTE><Esc>O
  vmap _bl xi<BLOCKQUOTE cite=""></BLOCKQUOTE><Esc>?><C-M>p
  iab  Ybl  <BLOCKQUOTE></BLOCKQUOTE><ESC>T>i
  iab  Yblockquote <BLOCKQUOTE core i18n events cite=""></BLOCKQUOTE><ESC>T>i
" 
"		BODY (4.0: Colours & images deprecated in favour of CSS)
  imap _bd <BODY><CR></BODY><Esc>O
  vmap _bd xi<BODY><CR></BODY><Esc>P
  iab  Ybody <BODY core i18n events onload="" <CR><Tab>onunload=""><CR></BODY><Esc>?core<CR>
"
"		BQ (blockquote) (3.0)
"imap _bq <BQ></BQ><Esc>bhhi
"
"		BR (line break)
" imap Ybr <br>
  imap _br <br>
  iab  Ybreak <BR core><Esc>?core<CR>
"
"       BUTTON (button) (4.0)
  iab  Ybutton <BUTTON core i18n events name ="" <CR><Tab>value ="" <CR><Tab>type="button\|submit\|reset"<CR> disabled ="" <CR><Tab>tabindex="" <CR><Tab>accesskey ="" <CR><Tab>onfocus ="" <CR><Tab>onblur =""><CR></BUTTON><Esc>?core<CR>
"
"	C
"		CAPTION (3.0) (4.0: Align deprecated)
  imap _ca <CAPTION></CAPTION><Esc>bhhi
  vmap _ca xi<CAPTION></CAPTION><Esc>9hP
  iab  Ycaption <CAPTION core i18n events></CAPTION><Esc>?core<CR>
"
"		CENTER (Netscape) (4.0: Deprecated)
  imap _ce <CENTER></CENTER><Esc>bhhi
  iab  Ycen <center></center><ESC>T>i
  vmap ,ce  "zdi<center><C-M><C-R>z<C-M></center><ESC>T>i
"
"		CITE
  imap _ci <CITE></CITE><Esc>bhhi
  vmap _ci xi<CITE></CITE><Esc>6hP
  iab  Ycite <CITE core i18n events></CITE><Esc>?core<CR>
"
"		CODE
  imap _co <CODE></CODE><Esc>bhhi
  vmap _co xi<CODE></CODE><Esc>6hP
  iab  Ycode <CODE core i18n events></CODE><Esc>?core<CR>
  vmap ,cod "zdi<CODE><C-M><C-R>z<C-M></CODE><C-M><ESC>T>i
"
"       COL (table column) (4.0)
  iab  Ycol <COL core i18n events repeat="" <CR><Tab>width="" <CR><Tab>align=""><Esc>?core<CR>
"
"       COLGROUP (table column group) (4.0)
  iab Ycolgroup <COLGROUP core i18n events span="" <CR><Tab>width=""></COLGROUP><Esc>?core<CR>
"
"		CREDIT (3.0) (Not in 4.0)
  imap _cr <CREDIT></CREDIT><Esc>bhhi
  vmap _cr xi<CREDIT></CREDIT><Esc>8hP
"
"	D
"		DD (definition for definition list)
  imap _dd <DD></DD><Esc>bhhi
  iab  Ydd <DD core i18n events></DD><Esc>?core<CR>
"
"		DEL (deleted text) (3.0)
  imap _de <DEL></DEL><Esc>bhhi
  vmap _de xi<DEL></DEL><Esc>5hP
  iab  Ydel <DEL core i18n events cite="" <CR><Tab>datetime=""></DEL><Esc>?core<CR>
"
"		DFN (defining instance) (3.0)
  imap _df <DFN></DFN><Esc>bhhi
  vmap _df xi<DFN></DFN><Esc>5hP
  iab  Ydfn <DFN core i18n events ></DFN><Esc>?core<CR>
"
"		DIR (directory list) (3.0) (4.0: Deprecated)
  imap _di <DIR><CR></DIR><Esc>O	
  vmap _di xi<DIR><CR></DIR><Esc>P
"
"		DIV (document division) (3.0)
  imap _dv <DIV></DIV><Esc>bhhi
  vmap _dv xi<DIV></DIV><Esc>5hP
  iab  Ydiv <DIV core i18n events charset ="" <CR><Tab>type ="" <CR><Tab>href="" <CR><Tab>hreflang ="" <CR><Tab>target ="" <CR><Tab>rel ="" <CR><Tab>rev ="" <CR><Tab>media =""></div><Esc>?core<CR>
"
"		DL (definition list)
  imap _dl <DL><CR></DL><Esc>O	
  vmap _dl xi<DL><CR></DL><Esc>P
  iab Ydl <DL core i18n events ><CR><CR><DT><CR><DD><CR><P><CR><CR></dl><CR><ESC>5kA
"
"		DT (term for definition list)
  imap _dt <DT></DT><Esc>bhhi
  iab Ydt <DT core i18n events ><CR><DD><CR><P><CR><ESC>kA
  iab Ydp <DT core i18n events ><CR><DD><C-M><P><C-M><ESC>kkkA 
"	
"	E
"		EM (emphasize)
  imap _em <EM></EM><Esc>bhhi
  vmap _em xi<EM></EM><Esc>4hP
  iab  Yem <EM core i18n events ></EM>
"	
"	F
"	    FIELDSET (form control group) (4.0)
  iab Yfieldset <FIELDSET core i18n events ></FIELDSET><Esc>?core<CR>
"	
"		FIG (figure) (3.0) (Not in 4.0)
  imap _fi <FIG SRC=""></FIG><Esc>?"<CR>i
  vmap _fi xi<FIG SRC="XXX"><Esc>pa</FIG><Esc>0?\"XXX\"?s+3<CR>v2h
"
"		FN (footnote) (3.0) (Not in 4.0)
  imap _fn <FN></FN><Esc>bhhi
  vmap _fn xi<FN></FN><Esc>4hP
"
"		FONT (Netscape) (4.0: Deprecated)
  imap _fo <FONT size=></font><Esc>bhhhi
  vmap _fo xi<FONT size="XXX"><Esc>pa</font><Esc>0?\"XXX\"?s+3<CR>v2h
"	
"	    FORM (interactive form) (4.0)
  iab  Yform <FORM core i18n events  action="" <CR><Tab>method ="" <CR><Tab>enctype ="" <CR><Tab>onsubmit ="" <CR><Tab>onreset ="" <CR><Tab>target ="" <CR><Tab>accept-charset=""></FORM><Esc>?core<CR>
"	
"	    FRAME (subwindow) (4.0)
  iab  Yframe <FRAME core longdesc ="" <CR><Tab>name ="" <CR><Tab>src ="" <CR><Tab>frameborder="(1\|0)" <CR><Tab>marginwidth ="" <CR><Tab>marginheight ="" <CR><Tab>noresize <CR><Tab>scrolling="(yes\|no\|auto)"><Esc>?core<CR>
"	
"	    FRAMESET (window subdivision) (4.0)
  iab  Yframeset <FRAMESET core rows ="" <CR><Tab>cols="" <CR><Tab>onload ="" <CR><Tab>onunload =""></FRAMESET><Esc>?core<CR>
            
"	
"	
"	H
"		H1...H6 (headers, level 1-6)
  imap _h1 <H1></H1><Esc>bhhi
  imap _h2 <H2></H2><Esc>bhhi
  imap _h3 <H3></H3><Esc>bhhi
  imap _h4 <H4></H4><Esc>bhhi
  imap _h5 <H5></H5><Esc>bhhi
  imap _h6 <H6></H6><Esc>bhhi
"
  vmap _h1 xi<H1><CR></H1><Esc>P
  vmap _h2 xi<H2><CR></H2><Esc>P
  vmap _h3 xi<H3><CR></H3><Esc>P
  vmap _h4 xi<H4><CR></H4><Esc>P
  vmap _h5 xi<H5><CR></H5><Esc>P
  vmap _h6 xi<H6><CR></H6><Esc>P
"
  iab  Yh1 <h1></h1><ESC>T>i
  iab  Yh2 <h2></h2><ESC>T>i
  iab  Yh3 <h3></h3><ESC>T>i
  iab  Yh4 <h4></h4><ESC>T>i
  iab  Yh5 <h5></h5><ESC>T>i
  iab  Yh6 <h6></h6><ESC>T>i
"
  vmap ,h1 "zdi<h1><C-R>z</h1><ESC>2F>
  vmap ,h2 "zdi<h2><C-R>z</h2><ESC>2F>
  vmap ,h3 "zdi<h3><C-R>z</h3><ESC>2F>
  vmap ,h4 "zdi<h4><C-R>z</h4><ESC>2F>
  vmap ,h5 "zdi<h5><C-R>z</h5><ESC>2F>
  vmap ,h6 "zdi<h6><C-R>z</h6><ESC>2F>
"
"		HEAD (document head) (4.0)
  imap _he <HEAD><CR></HEAD><Esc>O
  vmap _he xi<HEAD><CR></HEAD><Esc>P
  iab  Yhead <HEAD i18n profile=""><CR></HEAD><Esc>O
"
"		HR (horizontal rule)
  imap _hr <HR WIDTH="75%">
  imap  Yhor <HR core events ><Esc>?core<CR>
"
"		HTML (document root element) (3.0) (4.0)
" imap _ht <HTML><CR></HTML><Esc>O
  iab  Yhtml <HTML lang="" <CR><Tab>dir=""><CR></HTML><Esc>?lang<CR>
"	
"	I
"		I (italic text style) (4.0)
  imap _it <I></I><Esc>hhhi
  vmap _it xi<I></I><Esc>3hP
  iab  Yi   <I core i18n events ></I><Esc>?core<CR>
  vmap ,i   "zdi<I><C-R>z</I><ESC>T>
"
"       IFRAME (inline subwindow) (4.0)
  iab Yiframe <IFRAME core longdesc ="" <CR><Tab>name ="" <CR><Tab>src ="" <CR><Tab>frameborder="(1\|0)" <CR><Tab>marginwidth ="" <CR><Tab>marginheight ="" <CR><Tab>scrolling="(yes\|no\|auto)" <CR><Tab>align ="" <CR><Tab>height ="" <CR><Tab>width =""><CR></IFRAME><Esc>?core<CR>
"
"		IMG (image tag) (4.0)
  imap _im <IMG SRC="" ALT=""><Esc>?""<CR>na
  vmap _im xi<IMG SRC="XXX" alt="<Esc>pa"><Esc>0?\"XXX\"?s+3<CR>v2h
" iab  Yimg  <img alt="[picture: title]"<C-M>   align=<C-M>     src=""></a><ESC>?""<CR>a
  iab  Yimg <IMg core i18n events src ="" <CR><Tab>alt ="" <CR><Tab>longdesc ="" <CR><Tab>height ="" <CR><Tab>width ="" <CR><Tab>align="" <CR><Tab>border ="" <CR><Tab>hspace ="" <CR><Tab>vspace ="" <CR><Tab>usemap ="" <CR><Tab>ismap =""><Esc>?core<CR> "
"       INPUT (form control) (4.0)
  iab  Yinput <INPUT core i18n events type ="(text\|password\|checkbox\|radio\|submit\|reset\|file\|hidden\|image\|button)" <CR><Tab>name ="" <CR><Tab>value ="" <CR><Tab>checked (checked) ="" <CR><Tab>disabled (disabled) ="" <CR><Tab>readonly (readonly) ="" <CR><Tab>size ="" <CR><Tab>maxlength ="" <CR><Tab>src ="" <CR><Tab>alt ="" <CR><Tab>usemap ="" <CR><Tab>align ="" <CR><Tab>tabindex ="" <CR><Tab>accesskey ="" <CR><Tab>onfocus ="" <CR><Tab>onblur ="" <CR><Tab>onselect ="" <CR><Tab>onchange ="" <CR><Tab>accept =""><Esc>?core<CR>
"  
"		INS (inserted text) (3.0) (4.0)
  iab _in <<<C-V>/INS><Esc>?<<aINS>
  vmap _in xi<INS<C-V>></INS><Esc>5hP
  iab  Yins <INS core i18n events cite="" <CR><Tab>datetime=""></INS><Esc>?core<CR>
"
"		ISINDEX (4.0: Deprecated in favour of INPUT)
  imap _ii <ISINDEX>
"
"	K
"		KBD (keyboard = text to be entered by the user) (4.0)
  imap _kb <KBD></KBD><Esc>bhhi
  vmap _kb xi<KBD></KBD><Esc>5hP
  iab  Ykbd <KBD core i18n events><CR></KBD><Esc>?core<CR> 
"
"	L
"       LABEL (form field label text) (4.0)
  iab  Ylabel <LABEL core i18n events for ="" <CR><Tab>accesskey ="" <CR><Tab>onfocus ="" <CR><Tab>onblur =""><CR></LABEL><Esc>?core<CR>
"
"		LANG (language context) (3.0) (Not in 4.0)
  imap _la <LANG lang=""></LANG><Esc>?"<CR>i
  vmap _la xi<LANG lang="XXX"><Esc>pa</LANG><Esc>0?\"XXX\"?s+3<CR>v2h
"
"       LEGEND (fieldset legend) (4.0)
  iab  Ylegend <LEGEND core i18n events align="" <CR><Tab>accesskey=""><CR></LEGEND><Esc>?core<CR>
"
"		LI (list item)
  imap _li <LI>
  iab  Yli <li>
"
"		LINK (within head: a media-independent link) (4.0)
  imap _lk <LINK HREF=""><Esc>hi
  iab  Ylink <LINK core i18n events charset ="" <CR><Tab>href ="" <CR><Tab>hreflang ="" <CR><Tab>type ="" <CR><Tab>rel ="" <CR><Tab>rev ="" <CR><Tab>media ="" <CR><Tab>target =""><Esc>?core<CR>
"
"		LH (list header)
  imap _lh <LH></LH><Esc>bhhi
  vmap _lh xi<LH></LH><Esc>4hP
"
"	M
"       MAP (client-side image map) (4.0)
   iab  Ymap <MAP core i18n events name=""><CR></MAP><Esc>?core<CR>
"
"		MENU (4.0: Deprecated in favour of UL)
  imap _mu <MENU><CR></MENU><Esc>O	
  vmap _mu xi<MENU><CR></MENU><Esc>P
"
"		META (head)
  imap _me <META NAME="" CONTENT=""><Esc>?""<CR>??<CR>a
"
"	N
"		NOBR (no break) (Netscape)
"imap _nb <NOBR></NOBR><Esc>bhhi
"
"       NOFRAMES (alternate content container for non frame-based rendering) (4.0)
  iab Ynoframes <NOFRAMES core i18n events><CR></NOFRAMES><Esc>?core<CR>
"
"       NOSCRIPT (alternate content container for non frame-based rendering) (4.0)
  iab Ynoscript <NOSCRIPT core i18n events><CR></NOsCRIPT><Esc>?core<CR>
"
"		NOTE (3.0) (Not in 4.0)
"imap _no <NOTE></NOTE><Esc>bhhi
  vmap _no xi<NOTE></NOTE><Esc>6hP
"
"	O
"       OBJECT (generic embedded object) (4.0)
  imap _ob <OBJECT codebase="" code="" name="" archive="" object="" width="" height=""></OBJECT>insertmarks
  iab  Yobject <OBJECT core i18n events declare<CR> classid ="" <CR><Tab>codebase ="" <CR><Tab>data ="" <CR><Tab>type ="" <CR><Tab>codetype ="" <CR><Tab>archive ="" <CR><Tab>standby ="" <CR><Tab>height ="" <CR><Tab>width ="" <CR><Tab>align ="" <CR><Tab>border ="" <CR><Tab>hspace ="" <CR><Tab>vspace ="" <CR><Tab>usemap ="" <CR><Tab>shapes="" <CR><Tab>export ="" <CR><Tab>name ="" <CR><Tab>tabindex =""><CR></OBJECT><Esc>?core<CR>
"
"		OL (ordered list) (3.0)
  imap _ol <OL><CR></OL><Esc>O	
  vmap _ol xi<OL><CR></OL><Esc>P
  iab  Yol <OL core i18n events ><CR><LI><CR></OL><Esc>?core<CR>
"
"       OPTGROUP (option group) (4.0)
  iab  Yoptgroup <OPTGROUP core i18n events <CR><Tab>disabled <CR><Tab>label=""><cr></OPTGROUP><Esc>?core<CR>
"
"       OPTION (selectable choice) (4.0)
  iab  Yoption <OPTION core i18n events selected ="" <CR><Tab>disabled="" <CR><Tab>label="" <CR><Tab>value =""><CR></OPTION><Esc>?core<CR>
"
"		OVERLAY (figure overlay image) (3.0) (Not in 4.0)
"imap _ov <OVERLAY SRC=""><Esc>hi
"
"	P
"		P (paragraph) (4.0)
  imap _pp <P><CR></P><Esc>O
  vmap _pp xi<P><CR></P><Esc>P
  iab  Ypar <P core i18n events ></P><ESC>T>i
  vmap ,par "zdi<P><C-M><C-R>z<C-M></P><C-M><ESC>?><C-M>
"
"       PARAM (named property value) (4.0)
  imap _pa <PARAM name="" value="" valuetype="" type=""></PARAM>insertmarks
  iab  Yparam <PARAM id ="" <CR><Tab>name ="" <CR><Tab>value="" <CR><Tab>valuetype="(DATA\|REF\|OBJECT)" <CR><Tab>type =""><Esc>?PARAM<CR>
"
"		PRE (preformatted text) (4.0)
  imap _pr <PRE><CR></PRE><Esc>O
  vmap _pr xi<PRE><CR></PRE><Esc>P
  iab  Ypre <PRE core i18n events <CR><Tab>width=""><CR></PRE><ESC>T>i
  vmap ,pre mz:<ESC>'<O<pre><ESC>'>o</pre><ESC>`z
"
"   Q
"		Q (short inline quotation) (3.0) (4.0)
  imap _qu <Q></Q><Esc>hhhi
  vmap _qu xi<Q></Q><Esc>3hP
  iab  Yquote <Q core i18n events cite=""></Q><Esc>?core<CR>
"
"	R
"		RANGE (3.0) (head)
"imap _ra <RANGE FROM="" UNTIL=""><Esc>Bhi
"
"	S
"		S (strike-through text style) (3.0) (4.0: Deprecated)
" imap _sk <S></S><Esc>hhhi
  vmap _sk xi<S></S><Esc>3hP
"
"		SAMP (sample program output, scripts, etc.) (4.0)
  imap _sa <SAMP></SAMP><Esc>bhhi
  vmap _sa xi<SAMP></SAMP><Esc>5hP
  iab  Ysamp <SAMP core i18n events ></SAMP><Esc>?core<CR>
"
"       SCRIPT (script statements) (4.0)
  iab  Yscript <SCRIPT charset ="" <CR><Tab>type ="" <CR><Tab>language ="" <CR><Tab>src ="" <CR><Tab>defer></SCRIPT><Esc>?core<CR>
"
"       SELECT (option selector) (4.0)
  iab  Yselect <SELECT core i18n events name ="" <CR><Tab>size ="" <CR><Tab>multiple <CR><Tab>disabled <CR><Tab>tabindex ="" <CR><Tab>onfocus ="" <CR><Tab>onblur ="" <CR><Tab>onchange =""></SELECT><Esc>?core<CR>
"
"		SMALL (small text style) (3.0) (4.0)
  iab _sm <SMALL></SMALL><Esc>bhhi
  vmap _sm xi<SMALL></SMALL><Esc>7hP
  iab  Ysmall <SMALL core i18n events ></SMALL><Esc>?core<CR>
"
"       SPAN (generic language/style container) (4.0)
  iab  Yspan <SPAN core i18n events type ="" <CR><Tab>href ="" <CR><Tab>hreflang ="" <CR><Tab>target ="" <CR><Tab>rel ="" <CR><Tab>rev="" <CR><Tab>media ="" <CR><Tab><Esc>?core<CR>
"
"		SPOT (3.0) (Not in 4.0)
" imap _sp <SPOT ID=""><Esc>i
"
"		STRONG (strong emphasis) (4.0)
  imap _st <STRONG></STRONG><Esc>bhhi
  vmap _st xi<STRONG></STRONG><Esc>8hP
  iab  Ystrong <STRONG core i18n events ></STRONG><Esc>?core<CR>
"
"		STYLE (style info) (3.0) (4.0)
" imap _sn <STYLE notation=""><CR></STYLE><Esc>k/"<CR>a
  vmap _sn xi<STYLE notation="XXX"><Esc>pa</STYLE><Esc>0?\"XXX\"?s+3<CR>v2h
  iab  Ystyle <STYLE i18n <CR><Tab>type="" <CR><Tab>media="" <CR><Tab>title=""></STYLE><Esc>?i18n<CR>
"
"		SUB (subscript) (3.0)
  imap _sb <SUB></SUB><Esc>bhhi
  vmap _sb xi<SUB></SUB><Esc>5hP
  iab  Ysub <SUB core i18n events ></SUB>
"
"		SUP (superscript) (3.0)
  imap _sp <SUP></SUP><Esc>bhhi
  vmap _sp xi<SUP></SUP><Esc>5hP
  iab  Ysup <SUP core i18n events ></SUP>
"
"	T
"		TAB (3.0)
"imap _ta <TAB>
"
"		TABLE (table main)
  vmap _tb xi<TABLE></TABLE><ESC>k$hhhhhhhi<CR><CR><ESC>kp
  imap _tb <TABLE></TABLE><Esc>k$bhhi
  iab  Ytable <TABLE core i18n events summary ="" <CR><Tab>width ="" <CR><Tab>border ="" <CR><Tab>frame ="" <CR><Tab>rules ="" <CR><Tab>cellspacing ="" <CR><Tab>cellpadding =""></TABLE><Esc>?core<CR>
"
"       TBODY (table body) (4.0)
  iab  Ytbody <TBODY core i18n events halign valign></TBODY><Esc>?core<CR>
"
"       THEAD (table header) (4.0)
  iab  Ythead <THEAD core i18n events halign valign></THEAD><Esc>?core<CR>
"
"       TFOOT (table footer) (4.0)
  iab  Ytfoot <TFOOT core i18n events halign valign></TFOOT><Esc>?core<CR>
"
"		TD (table data cell) (4.0)
  vmap _td xi<TD></TD><ESC>k$hhhhi<CR><CR><ESC>kp
  imap _td <TD></TD><Esc>k$bhhi
  iab  Ytd <TD core i18n events abbr ="" <CR><Tab>axis ="" <CR><Tab>headers ="" <CR><Tab>scope ="" <CR><Tab>nowrap <CR><Tab>bgcolor ="" <CR><Tab>rowspan ="" <CR><Tab>colspan ="" <CR><Tab>halign <CR><Tab>valign <CR><Tab>width ="" <CR><Tab>height =""><CR></TD><Esc>?core<CR>
"
"		TH (table heading) (4.0)
  imap _th <TH></TH><Esc>bhhi
  iab  Yth <TH core i18n events abbr ="" <CR><Tab>axis ="" <CR><Tab>headers ="" <CR><Tab>scope ="" <CR><Tab>nowrap <CR><Tab>bgcolor ="" <CR><Tab>rowspan ="" <CR><Tab>colspan ="" <CR><Tab>halign <CR><Tab>valign <CR><Tab>width ="" <CR><Tab>height =""><CR></TH><Esc>?core<CR>
"
"		TR (table row)
  vmap _tr xi<TR></TR><ESC>k$hhhhi<CR><CR><ESC>kp
  imap _tr <TR></TR><Esc>k$bhhi
  iab  Ytr <TR core i18n events halign valign><CR></TR><Esc>?core<CR>
"
"       TEXTAREA (multi-line text field) (4.0)
  iab  Ytextarea <TEXTAREA core i18n events name ="" <CR><Tab>rows ="" <CR><Tab>cols ="" <CR><Tab>disabled <CR><Tab>readonly <CR><Tab>tabindex ="" <CR><Tab>onfocus ="" <CR><Tab>onblur ="" <CR><Tab>onselect ="" <CR><Tab>onchange =""><CR></TEXTAREA><Esc>?core<CR>
"
"		TITLE (head: document title) (4.0)
  imap _ti <TITLE></TITLE><Esc>bhhi
  vmap _ti xi<TITLE></TITLE><Esc>2?><CR>p
"
"		TT (teletype or monospaced text style) (4.0)
  imap _tt <TT></TT><Esc>bhhi
  vmap _tt xi<TT></TT><Esc>4hP
  iab  Ytt  <TT core i18n events ></TT><ESC>T>i
  vmap ,tt  "zdi<TT><C-R>z</TT><ESC>T>i
"
"	U
"		U (underline) (4.0: Deprecated)
" imap _uu <U></U><Esc>hhhi
  vmap _uu xi<U></U><Esc>3hP
"
"		UL (unordered list)
  imap _ul <UL><CR></UL><Esc>O	
  vmap _ul xi<UL><CR></UL><Esc>k$p
  iab  Yul <UL core i18n events ><CR><LI><CR></ul><ESC>k
"
"	V
"		VAR (instance of a variable or program argument) (4.0)
  iab _va <VAR></VAR><Esc>hhhi
  vmap _va xi<VAR></VAR><Esc>3hP
  iab  Yvar <VAR core i18n events ><CR></VAR><Esc>?core<CR>
"
"	W
"		WBR (word break) (Netscape) (Not in 4.0)
" imap _wb <WBR>
"	
"	X
"       XMP (example?) (Not in 4.0)
  iab  Yxmp <xmp></xmp><ESC>T>i
  vmap ,xmp "zdi<xmp><C-M><C-R>z<C-M></xmp><C-M><ESC>T>i
"  
"	 	Special Characters
  iab _& &amp;
  iab _cp &copy;
  iab _" &quot;
  iab _< &lt;
  iab _> &gt;

" [ISO10646] Mathematical, Greek and Symbolic characters for HTML
  iab _... &hellip;
  
" [ISO10646] Special characters for HTML
  iab _ens &ensp;
  iab _ems &emsp;
  iab _ths &thinsp;
  iab _- &ndash;
  iab _-- &mdash;
  iab _lq &lsquo; 
" left single quotation mark,
  iab _rq &rsquo; 
" right single quotation mark,
  iab _ll &sbquo; 
" single low left quotation mark, 
  iab _ldq &ldquo; 
" left double quotation mark,
  iab _rdq &rdquo;
" right double quotation mark,
"	
"	
"	 Command-mode tags
"	
"		Template creation macro
"			This macro will invoke a chain of macros which
"			will create the framework of an HTML document
"			for you.
  map ;html :set ai<CR>i<!DOCTYPE HTML PUBLIC  "-//W3C//DTD HTML 3.2//EN"><CR><HTML><CR><HEAD><CR><CR><TITLE></TITLE><CR><Esc>;;T1
  map ;doc 0i<!DOCTYPE HTML PUBLIC  "-//W3C//DTD HTML 3.2//EN"><CR><Esc>
"
"	 Never manually invoke these (following) macros.  These are meant to be
"	 automagically invoked by the template-creation macro.  If you
"	 just use your own HTML template or something along those lines,
"	 you can simply delete from here to the end of the file.  Just
"	 don't try to invoke the template-creation macro after that. :-)
"	
  map ;;T1 o<CR></HEAD><Esc>;;T2
  map ;;T2 o<BODY><CR><Esc>;;T3
  map ;;T3 o<H1></H1><CR><CR><P><CR><Esc>;;T4
  map ;;T4 o</BODY><CR><Esc>;;T5
  map ;;T5 o<!-- $Id$ --><CR></HTML><CR><Esc>;;T6
  map ;;T6 1Gjjjlllllla
"
" HTML Macros for VIM's visual mode
"      These were also written for my personal use and to complement
"      the macros made by Doug Renze (drenze@avalon.net) that can be
"      found at: http://www.avalon.net/~drenze/
"      Remarks, suggestions and ideas are welcome
"
"      Ives Aerts
"      ives@sonytel.be
"
" 1) paragraph style macros
"      To use these macros, use the `V' command to select a number of lines
"      and then call the appropriate macro to change the style of those lines.
"
"	ADDRESS				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _ad xi<ADDRESS><CR></ADDRESS><Esc>P
"
"	BLOCKQUOTE			HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _bl xi<BLOCKQUOTE><CR></BLOCKQUOTE><Esc>P
"
"	BODY				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _bd xi<BODY><CR></BODY><Esc>P
"
"	CENTER				NETSCAPE            { Commented out -- I'm not using Netscape tags. }
" vmap _ce xi<CENTER><CR></CENTER><Esc>P
"
"	DIR	Directory List		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _di xi<DIR><CR></DIR><Esc>P
"
"	DL	Definition List            { Moved up to its place in the alphabet. } 
" vmap _dl xi<DL><CR></DL><Esc>P
"
"	HEADERS, LEVELS 1-6		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _h1 xi<H1><CR></H1><Esc>P
" vmap _h2 xi<H2><CR></H2><Esc>P
" vmap _h3 xi<H3><CR></H3><Esc>P
" vmap _h4 xi<H4><CR></H4><Esc>P
" vmap _h5 xi<H5><CR></H5><Esc>P
" vmap _h6 xi<H6><CR></H6><Esc>P
"
"	HEAD				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _he xi<HEAD><CR></HEAD><Esc>P
"
"	HTML				HTML 3.0
"vmap _ht xi<HTML><CR></HTML><Esc>P
"
"	MENU				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _mu xi<MENU><CR></MENU><Esc>P
"
"	OL	Ordered List		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _ol xi<OL><CR></OL><Esc>P
"
"	P	Paragraph		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _pp xi<P><CR></P><Esc>P
"
"	PRE	Preformatted Text	HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _pr xi<PRE><CR></PRE><Esc>P
"
"	TITLE				HTML 2.0	HEADER            { Moved up to its place in the alphabet. } 
" vmap _ti xi<TITLE></TITLE><Esc>P
"
"	UL	Unordered List		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _ul xi<UL><CR></UL><Esc>P
"
" 2) text style macros
"      To use these macros, use the `v' command to select a portion of text
"      and then call the approporiate macro to change the style of that text.
"
"	Comment Tag            { Moved up to its place in the alphabet. } 
" vmap _cm xi<!--  --><Esc>3hP
"
"	ABBREV	Abbreviation		HTML 3.0    { Moved up to its place in the alphabet. }
" vmap _ab xi<ABBREV></ABBREV><Esc>8hP
"
"	ACRONYM				HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _ac xi<ACRONYM></ACRONYM><Esc>9hP
"
"	AU	Author			HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _au xi<AU></AU><Esc>4hP
"
"	B	Boldfaced Text		HTML 2.0        { Moved up to its place in the alphabet. } 
"vmap _bo xi<B></B><Esc>3hP
"
"	BANNER				HTML 3.0            { Not in HTML4.0 specification. }
"vmap _ba xi<BANNER></BANNER><Esc>8hP
"
"	BIG				HTML 3.0                { Moved up to its place in the alphabet. } 
"vmap _bi xi<BIG></BIG><Esc>5hP
"
"	BQ	Blockquote		HTML 3.0            { Moved up to its place in the alphabet. } 
"vmap _bq xi<BQ></BQ><Esc>4hP
"
"	CAPTION				HTML 3.0            { Moved up to its place in the alphabet. } 
"vmap _ca xi<CAPTION></CAPTION><Esc>9hP 
"
"	CITE				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _ci xi<CITE></CITE><Esc>6hP
"
"	CODE				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _co xi<CODE></CODE><Esc>6hP
"
"	CREDIT				HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _cr xi<CREDIT></CREDIT><Esc>8hP
"
"	DEL	Deleted Text		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _de xi<DEL></DEL><Esc>5hP
"
"	DFN	Defining Instance	HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _df xi<DFN></DFN><Esc>5hP
"
"	DIV	Document Division	HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _dv xi<DIV></DIV><Esc>5hP
"
"	EM	Emphasize		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _em xi<EM></EM><Esc>4hP
"
"	FN	Footnote		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _fn xi<FN></FN><Esc>4hP
"
"	I	Italicized Text		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _it xi<I></I><Esc>3hP
"
"	INS	Inserted Text		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _in xi<INS></INS><Esc>5hP
"
"	KBD	Keyboard Text		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _kb xi<KBD></KBD><Esc>5hP
"
"	LH	List Header		HTML 2.0                { Moved up to its place in the alphabet. } 
" vmap _lh xi<LH></LH><Esc>4hP
"
"	NOBR	No Break		NETSCAPE            { Commented out -- I'm not using Netscape tags. }
" vmap _nb xi<NOBR></NOBR><Esc>6hP
"
"	NOTE				HTML 3.0                { Moved up to its place in the alphabet. } 
" vmap _no xi<NOTE></NOTE><Esc>6hP
"
"	Q	Quote			HTML 3.0                { Moved up to its place in the alphabet. } 
" vmap _qu xi<Q></Q><Esc>3hP
"
"	S	Strikethrough		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _sk xi<S></S><Esc>3hP
"
"	SAMP	Sample Text		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _sa xi<SAMP></SAMP><Esc>5hP
"
"	SMALL	Small Text		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _sm xi<SMALL></SMALL><Esc>7hP
"
"	STRONG				HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _st xi<STRONG></STRONG><Esc>8hP
"
"	SUB	Subscript		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _sb xi<SUB></SUB><Esc>5hP
"
"	SUP	Superscript		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _sp xi<SUP></SUP><Esc>5hP
"
"	TT	Teletype Text		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _tt xi<TT></TT><Esc>4hP
"
"	U	Underlined Text		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _uu xi<U></U><Esc>3hP
"
"	V	Varimaple		HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _vv xi<V></V><Esc>3hP
"
" 3) link macros
"      To use these macros, use the `v' command to select a portion of text
"      that should become the description of the link and then call the
"      appropriate macro. Then use the `c' command to fill in the destination
"      of the link.
"
"	A HREF	Anchor Hyperlink	HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _ah xi<A HREF="XXX"><Esc>pa</A><Esc>0?\"XXX\"?s+3<CR>v2h
"
"	A NAME	Named Anchor		HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _an xi<A NAME="XXX"><Esc>pa</A><Esc>0?\"XXX\"?s+3<CR>v2h
"
"	FIG	Figure			HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _fi xi<FIG SRC="XXX"><Esc>pa</FIG><Esc>0?\"XXX\"?s+3<CR>v2h
"
"	IMG	Image			HTML 2.0            { Moved up to its place in the alphabet. } 
" vmap _im xi<IMG SRC="XXX" alt="<Esc>pa"><Esc>0?\"XXX\"?s+3<CR>v2h
"
" 4) other macros
"
"	LANG	Language Context	HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _la xi<LANG LANG="XXX"><Esc>pa</LANG><Esc>0?\"XXX\"?s+3<CR>v2h
"
"	STYLE				HTML 3.0            { Moved up to its place in the alphabet. } 
" vmap _sn xi<STYLE NOTATION="XXX"><Esc>pa</STYLE><Esc>0?\"XXX\"?s+3<CR>v2h
"
"	FONT				NETSCAPE            { Commented out -- I'm not using Netscape tags. }
" vmap _fo xi<FONT SIZE="XXX"><Esc>pa</FONT><Esc>0?XXX?s+3<CR>v2h
" 
  iab e' <C-V>é
  iab e` <C-V>è
  iab e^ <C-V>ê
  iab e" <C-V>ë
  iab a^ <C-V>â
  iab a` <C-V>à
  iab a' <C-V>á
  iab i^ <C-V>î
  iab i" <C-V>ï
  iab o^ <C-V>ô
  iab o` <C-V>ò
  iab o' <C-V>ó
  iab o" <C-V>ö
  iab u" <C-V>ü
  iab u^ <C-V>û
  iab u` <C-V>ù
  iab c, <C-V>ç
  iab E' <C-V>É
  iab E` <C-V>È
  iab E^ <C-V>Ê
  iab E" <C-V>Ë
  iab A^ <C-V>Â
  iab A` <C-V>À
  iab I^ <C-V>Î
  iab I" <C-V>Ï
  iab O^ <C-V>Ô
  iab O` <C-V>Ò
  iab U" <C-V>Ü
  iab U^ <C-V>Û
  iab U` <C-V>Ù
  iab C, <C-V>Ç
  iab << <C-V>«
  iab >> <C-V>»
"
  iab à &agrave<C-V>;
  iab á &aacute<C-V>;
  iab À &Agrave<C-V>;
  iab ç &ccedil<C-V>;
  iab Ç &Ccedil<C-V>;
  iab é &eacute<C-V>;
  iab ê &ecirc<C-V>;
  iab è &egrave<C-V>;
  iab ë &euml<C-V>;
  iab É &Eacute<C-V>;
  iab Ê &Ecirc<C-V>;
  iab È &Egrave<C-V>;
  iab Ë &Euml<C-V>;
  iab í &iacute<C-V>;
  iab î &icirc<C-V>;
  iab Î &Icirc<C-V>;
  iab ï &iuml<C-V>;
  iab Ï &Iuml<C-V>;
  iab ô &ocirc<C-V>;
  iab Ô &ocirc<C-V>;
  iab ö &uml;<C-V>;
  iab û &ucirc<C-V>;
  iab Û &Ucirc<C-V>;
  iab ù &ugrave<C-V>;
  iab Ù &Ugrave<C-V>;
  iab ü &uuml<C-V>;
  iab Ü &Uuml<C-V>;
" 
  nmap ;entities :%s/à/<Bslash>&agrave;/eg<C-M>:%s/á/<Bslash>&aacute;/eg<C-M>:%s/À/<Bslash>&Agrave;/eg<C-M>:%s/ç/<Bslash>&ccedil;/eg<C-M>:%s/Ç/<Bslash>&Ccedil;/eg<C-M>:%s/é/<Bslash>&eacute;/eg<C-M>:%s/ê/<Bslash>&ecirc;/eg<C-M>:%s/è/<Bslash>&egrave;/eg<C-M>:%s/ë/<Bslash>&euml;/eg<C-M>:%s/É/<Bslash>&Eacute;/eg<C-M>:%s/Ê/<Bslash>&Ecirc;/eg<C-M>:%s/È/<Bslash>&Egrave;/eg<C-M>:%s/Ë/<Bslash>&Euml;/eg<C-M>:%s/í/<Bslash>&iacute;/eg<C-M>:%s/î/<Bslash>&icirc;/eg<C-M>:%s/Î/<Bslash>&Icirc;/eg<C-M>:%s/ï/<Bslash>&iuml;/eg<C-M>:%s/Ï/<Bslash>&Iuml;/eg<C-M>:%s/ó/<Bslash>&oacute;/eg<C-M>:%s/ô/<Bslash>&ocirc;/eg<C-M>:%s/Ô/<Bslash>&Ocirc;/eg<C-M>:%s/ö/<Bslash>&ouml;/eg<C-M>:%s/û/<Bslash>&ucirc;/eg<C-M>:%s/Û/<Bslash>&Ucirc;/eg<C-M>:%s/ù/<Bslash>&ugrave;/eg<C-M>:%s/Ù/<Bslash>&Ugrave;/eg<C-M>:%s/ü/<Bslash>&uuml;/eg<C-M>:%s/Ü/<Bslash>&Uuml;/eg<C-M>:%s/“/<Bslash>&quot;/eg<C-M>:%s/”/<Bslash>&quot;/eg<C-M>:%s/‘/\'/eg<C-M>:%s/’/\'/eg<C-M>
"
  abbrev (TM) <SUP><SMALL>(TM)</SMALL></SUP>
