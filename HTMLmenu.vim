" Make sure the '<' flag is not included in 'cpoptions', otherwise <CR> would
" not be recognized.  See ":help 'cpoptions'".
let cpo_save = &cpo
let &cpo = ""
"
" ===================================================================
" HTML menu
" ===================================================================
"
" NOTE: this menu makes use of mappings defined in html.vimrc
"
"			Insert link to stylesheet
30nmenu HTML.CSS.Insert\ Link			0i<C-I><link rel=stylesheet href=".css" type="text/css"><C-M><ESC>?href="<C-M>t.a
"
"			Insert enviroment <b></b>
30nmenu HTML.Insert\ Environment.Bold\ \ \ \ \ \|\ \ \ <Yb>\ (insert)           iYb<C-]>
30vmenu HTML.Insert\ Environment.Bold\ \ \ \ \ \|\ \ \ <,b>\ (visual)           ,b
"
"           Insert environment <blockquote></blockquote>
30nmenu HTML.Insert\ Environment.BlockQuote\ \ \ \ \ \|\ \ \ <Ybl>\ (insert)    iYbl<C-]>
30vmenu HTML.Insert\ Environment.BlockQuote\ \ \ \ \ \|\ \ \ (visual)			"zdi<blockquote><C-R>z</blockquote><ESC>F>
"
"           Insert Environment <center></center>
30nmenu HTML.Insert\ Environment.Center\			<center></center><ESC>T>i
30vmenu HTML.Insert\ Environment.Center\ \ \ \ \ \|\ \ \ <,ce>\ (visual)        ,ce
"
"           {Insert\ Environment <!-- --> (comments)}
30nmenu HTML.Insert\ Environment.Comment\ \ \ \ \ \|\ \ \ <Ycom>\ (insert)      iYcom<C-]>
30vmenu HTML.Insert\ Environment.Comment\ \ \ \ \ \|\ \ \ <,com>\ (visual)      ,com
" vmap ,com "zdi<C-M><--<C-M><C-R>z<C-M>--><C-M><ESC>?<--<C-M>ea	"{This puts the hightlighted text on a line of its own, as a comment}
"
"           Insert\ Environment <code></code>
30nmenu HTML.Insert\ Environment.Code\ \ \ \ \ \|\ \ \ <Ycod>\ (insert)         iYcod<C-]>
30vmenu HTML.Insert\ Environment.Code\ \ \ \ \ \|\ \ \ <,cod>\ (visual)         ,cod
"
"           Insert\ Environment <i></i>
30nmenu HTML.Insert\ Environment.Italics\ \ \ \ \ \|\ \ \ <Yi>\ (insert)        iYi<C-]>
30vmenu HTML.Insert\ Environment.Italics\ \ \ \ \ \|\ \ \ <,i>\ (visual)        ,i
"
"           Insert\ Environment <pre></pre>
30nmenu HTML.Insert\ Environment.Preformatted\ \ \ \ \ \|\ \ \ <Ypre>\ (insert) iYpre<C-]>
30vmenu HTML.Insert\ Environment.Preformatted\ \ \ \ \ \|\ \ \ <,pre>\ (visual) ,pre
"
"           Insert\ Environment <tt></tt>
30nmenu HTML.Insert\ Environment.Teletype\ \ \ \ \ \|\ \ \ <Ytt>\ (insert)      iYtt<C-]>
30vmenu HTML.Insert\ Environment.Teletype\ \ \ \ \ \|\ \ \ <,tt>\ (visual)      ,tt
"
"           Insert\ Environment <xmp></xmp>
30nmenu HTML.Insert\ Environment.Example\ \ \ \ \ \|\ \ \ <Yxmp>\ (insert)      iYxmp<C-]>
30vmenu HTML.Insert\ Environment.Example\ \ \ \ \ \|\ \ \ <,xmp>\ (visual)      ,xmp
"
" HTML - Insert Header Lines (h1 to h6)
"  
30nmenu HTML.Heading.1\ <Yh1>\ (insert)                                         iYh1<C-]>
30vmenu HTML.Heading.1\ <,h1>\ (visual)                                        ,h1
30nmenu HTML.Heading.2\ <Yh2>\ (insert)                                         iYh2<C-]>
30vmenu HTML.Heading.2\ <,h2>\ (visual)                                        ,h2
30nmenu HTML.Heading.3\ <Yh3>\ (insert)                                         iYh3<C-]>
30vmenu HTML.Heading.3\ <,h3>\ (visual)                                        ,h3
30nmenu HTML.Heading.4\ <Yh4>\ (insert)                                         iYh4<C-]>
30vmenu HTML.Heading.4\ <,h4>\ (visual)                                        ,h4
30nmenu HTML.Heading.5\ <Yh5>\ (insert)                                         iYh5<C-]>
30vmenu HTML.Heading.5\ <,h5>\ (visual)                                        ,h5
30nmenu HTML.Heading.6\ <Yh6>\ (insert)                                         iYh6<C-]>
30vmenu HTML.Heading.6\ <,h6>\ (visual)                                        ,h6
"
" HTML - Inserting Lists
"
"           Insert "ordered list" with one list element
30nmenu HTML.List.Ordered\ \ \ \ \ \|\ \ \ <Yol>\ (insert)                      iYol<C-]>
"           Insert "unordered list" with one list element
30nmenu HTML.List.Unordered\ \ \ \ \ \|\ \ \ <Yul>\ (insert)                    iYul<C-]>
"           Insert "description list" with one list element
"   iab Ydl <dl><CR><dt><CR><dd><CR><p><CR></dl><CR><ESC>4kA
30nmenu HTML.List.Description\ \ \ \ \ \|\ \ \ <Ydl>\ (insert)                  iYdl<C-]>
"
" HTML - Inserting List Items
"
"           Insert "list" item (for both ordered and unordered list)
30nmenu HTML.List.Item\ \ \ \ \ \|\ \ \ <Yli>\ (insert)                         iYli<C-]>
"           Insert "description list" item
30nmenu HTML.List.DescItem\ \ \ \ \ \|\ \ \ <Ydt>\ (insert)                     iYdt<C-]>
"
" HTML - Inserting Links
"
"            Insert/make reference link
30nmenu HTML.Link.Reference\ \ \ \ \ \|\ \ \ <Yhref>\ (insert)                  iYhref<C-]>
30vmenu HTML.Link.Reference\ \ \ \ \ \|\ \ \ <,href>\ (visual)                 ,href
"
"            Insert/make reference link to overview list (short"cut")
30nmenu HTML.Link.Overview\ \ \ \ \ \|\ \ \ <Ycut>\ (insert)                    iYcut<C-]>
30vmenu HTML.Link.Overview\ \ \ \ \ \|\ \ \ <,cut>\ (visual)                   ,cut
"
"            Insert/make name tag
30nmenu HTML.Link.Name\ \ \ \ \ \|\ \ \ <Yname>\ (insert)                       iYname<C-]>
30vmenu HTML.Link.Name\ \ \ \ \ \|\ \ \ <,name>\ (visual)                      ,name
"
"            Insert/make link to image
30nmenu HTML.Link.Image\ \ \ \ \ \|\ \ \ <Yimg>\ (insert)                       iYimg<C-]>
"
"            Insert/make mailto link
30nmenu HTML.Link.Mailto\ \ \ \ \ \|\ \ \ <Ymail>\ (insert)                     iYmail<C-]>
30vmenu HTML.Link.Mailto\ \ \ \ \ \|\ \ \ <,mail>\ (visual)                    ,mail
"
"            Insert/make link to newsgroup
30nmenu HTML.Link.Newsgroup\ \ \ \ \ \|\ \ \ <Ynews>\ (insert)                  iYnews<C-]>
30vmenu HTML.Link.Newsgroup\ \ \ \ \ \|\ \ \ <,news>\ (visual)                 ,news
"
"      Ypage Insert page description with a possible link and text
30nmenu HTML.Link.PageDesc\ \ \ \ \ \|\ \ \ <Ypage>\ (insert)                   iYpage<C-]>
"
" Restore the previous value of 'cpoptions'.
let &cpo = cpo_save
unlet cpo_save
