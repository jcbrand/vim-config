" Make sure the '<' flag is not included in 'cpoptions', otherwise <CR> would
" not be recognized.  See ":help 'cpoptions'".
"
let cpo_save = &cpo
let &cpo = ""
"
" ===================================================================
" CSS menu. Jean Jordaan (rgo_anas@rgo.sun.ac.za)
" ===================================================================
"
" NOTE: this menu is based on Cascading Style Sheets, level 1 
" (W3C Recommendation 17 Dec 1996), which can be found at 
" http://www.w3.org/pub/WWW/TR/REC-CSS1
"
"  This menu system inserts all CSS1 properties and units.
"  It is arranged according to the following structure
"  (sticking with the specification):
"
"      Font properties
"        'font-family'
"        'font-style'
"        'font-variant'
"        'font-weight'
"        'font-size'
"        'font'
"      Color and background properties
"        'color'
"        'background-color'
"        'background-image'
"        'background-repeat'
"        'background-attachment'
"        'background-position'
"        'background'
"      Text properties
"        'word-spacing'
"        'letter-spacing'
"        'text-decoration'
"        'vertical-align'
"        'text-transform'
"        'text-align'
"        'text-indent'
"        'line-height'
"      Box properties
"        'margin-top'
"        'margin-right'
"        'margin-bottom'
"        'margin-left'
"        'margin'
"        'padding-top'
"        'padding-right'
"        'padding-bottom'
"        'padding-left'
"        'padding'
"        'border-top-width'
"        'border-right-width'
"        'border-bottom-width'
"        'border-left-width'
"        'border-width'
"        'border-color'
"        'border-style'
"        'border-top'
"        'border-right'
"        'border-bottom'
"        'border-left'
"        'border'
"        'width'
"        'height'
"        'float'
"        'clear'
"      Classification properties
"        'display'
"        'white-space'
"        'list-style-type'
"        'list-style-image'
"        'list-style-position'
"        'list-style'
"      Units
"        Length units
"        Percentage units
"      Anchor pseudo-classes
"      Typographical pseudo-elements
"        'first-line'
"        'first-letter'
"
" ===================================================================
"
"      Font properties
"        'font-family'
  35amenu CSS.Font\ properties.Font-family.Serif        "='font-family: [[<family-name> \| Serif],]* [<family-name> \| Serif] '<CR>P?[[<<CR>
  35amenu CSS.Font\ properties.Font-family.Sans-serif   "='font-family: [[<family-name> \| Sans-serif],]* [<family-name> \| Sans-serif] '<CR>P?[[<<CR>
  35amenu CSS.Font\ properties.Font-family.Cursive      "='font-family: [[<family-name> \| Cursive],]* [<family-name> \| Cursive] '<CR>P?[[<<CR>
  35amenu CSS.Font\ properties.Font-family.Fantasy      "='font-family: [[<family-name> \| Fantasy],]* [<family-name> \| Fantasy] '<CR>P?[[<<CR>
  35amenu CSS.Font\ properties.Font-family.Monospace    "='font-family: [[<family-name> \| Monospace],]* [<family-name> \| Monospace] '<CR>P?[[<<CR>
"        'font-style'
  35amenu CSS.Font\ properties.Font-style.Normal         "='font-style: normal '<CR>P
  35amenu CSS.Font\ properties.Font-style.Italic         "='font-style: italic '<CR>P
  35amenu CSS.Font\ properties.Font-style.Oblique        "='font-style: oblique '<CR>P
"        'font-variant'
  35amenu CSS.Font\ properties.Font-variant.Normal       "='font-variant: normal '<CR>P
  35amenu CSS.Font\ properties.Font-variant.Small-caps   "='font-variant: small-caps '<CR>P
"        'font-weight'
  35amenu CSS.Font\ properties.Font-weight.Normal        "='font-weight: normal '<CR>P
  35amenu CSS.Font\ properties.Font-weight.Bold          "='font-weight: bold '<CR>P
  35amenu CSS.Font\ properties.Font-weight.Bolder        "='font-weight: bolder '<CR>P
  35amenu CSS.Font\ properties.Font-weight.Lighter       "='font-weight: lighter '<CR>P
  35amenu CSS.Font\ properties.Font-weight.100           "='font-weight: 100 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.200           "='font-weight: 200 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.300           "='font-weight: 300 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.400           "='font-weight: 400 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.500           "='font-weight: 500 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.600           "='font-weight: 600 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.700           "='font-weight: 700 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.800           "='font-weight: 800 '<CR>P
  35amenu CSS.Font\ properties.Font-weight.900           "='font-weight: 900 '<CR>P
"        'font-size'
  35amenu CSS.Font\ properties.Font-size.Absolute.xx-small  "='font-size: xx-small '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.x-small   "='font-size: x-small  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.small     "='font-size: small  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.medium    "='font-size: medium  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.large     "='font-size: large  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.x-large   "='font-size: x-large  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Absolute.xx-large  "='font-size: xx-large '<CR>P
  35amenu CSS.Font\ properties.Font-size.Relative.Larger    "='font-size: larger '<CR>P
  35amenu CSS.Font\ properties.Font-size.Relative.Smaller   "='font-size: smaller '<CR>P
  35amenu CSS.Font\ properties.Font-size.Length             "='font-size:  '<CR>P
  35amenu CSS.Font\ properties.Font-size.Percentage         "='font-size: % '<CR>P
"        'font'
  35amenu CSS.Font\ properties.Font.normal      "='normal '<CR>P
  35amenu CSS.Font\ properties.Font.italic      "='italic '<CR>P
  35amenu CSS.Font\ properties.Font.oblique     "='oblique '<CR>P
  35amenu CSS.Font\ properties.Font.normal      "='normal '<CR>P
  35amenu CSS.Font\ properties.Font.small-caps  "='small-caps '<CR>P
  35amenu CSS.Font\ properties.Font.normal      "='normal '<CR>P
  35amenu CSS.Font\ properties.Font.bold        "='bold '<CR>P
  35amenu CSS.Font\ properties.Font.bolder      "='bolder '<CR>P
  35amenu CSS.Font\ properties.Font.lighter     "='lighter '<CR>P
  35amenu CSS.Font\ properties.Font.100         "='100 '<CR>P
  35amenu CSS.Font\ properties.Font.200         "='200 '<CR>P
  35amenu CSS.Font\ properties.Font.300         "='300 '<CR>P
  35amenu CSS.Font\ properties.Font.400         "='400'<CR>P
  35amenu CSS.Font\ properties.Font.500         "='500 '<CR>P
  35amenu CSS.Font\ properties.Font.600         "='600 '<CR>P
  35amenu CSS.Font\ properties.Font.700         "='700 '<CR>P
  35amenu CSS.Font\ properties.Font.800         "='800 '<CR>P
  35amenu CSS.Font\ properties.Font.900         "='900 '<CR>P
  35amenu CSS.Font\ properties.Font.xx-small    "='xx-small '<CR>P
  35amenu CSS.Font\ properties.Font.x-small     "='x-small '<CR>P
  35amenu CSS.Font\ properties.Font.small       "='small '<CR>P
  35amenu CSS.Font\ properties.Font.medium      "='medium '<CR>P
  35amenu CSS.Font\ properties.Font.large       "='large '<CR>P
  35amenu CSS.Font\ properties.Font.x-large     "='x-large '<CR>P
  35amenu CSS.Font\ properties.Font.xx-large    "='xx-large '<CR>P
  35amenu CSS.Font\ properties.Font.larger      "='larger '<CR>P
  35amenu CSS.Font\ properties.Font.smaller     "='smaller '<CR>P
  35amenu CSS.Font\ properties.Font.serif       "='serif '<CR>P
  35amenu CSS.Font\ properties.Font.sans-serif  "='sans-serif '<CR>P
  35amenu CSS.Font\ properties.Font.cursive     "='cursive '<CR>P
  35amenu CSS.Font\ properties.Font.fantasy     "='fantasy '<CR>P
  35amenu CSS.Font\ properties.Font.monospace   "='monospace '<CR>P
"
"      Color and background properties
"        'color'
  35amenu CSS.Color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Color.keywords.black     "='black '<CR>P 
  35amenu CSS.Color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Color.keywords.green     "='green '<CR>P 
  35amenu CSS.Color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Color.keywords.red       "='red '<CR>P 
  35amenu CSS.Color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Color.keywords.white     "='white '<CR>P 
  35amenu CSS.Color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'background-color'
  35amenu CSS.Background\ Properties.Background-color.keywords.aqua      "='background-color: aqua '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.black     "='background-color: black '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.blue      "='background-color: blue '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.fuchsia   "='background-color: fuchsia '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.gray      "='background-color: gray '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.green     "='background-color: green '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.lime      "='background-color: lime '<CR>P
  35amenu CSS.Background\ Properties.Background-color.keywords.maroon    "='background-color: maroon '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.navy      "='background-color: navy '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.olive     "='background-color: olive '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.purple    "='background-color: purple '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.red       "='background-color: red '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.silver    "='background-color: silver '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.teal      "='background-color: teal '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.white     "='background-color: white '<CR>P 
  35amenu CSS.Background\ Properties.Background-color.keywords.yellow    "='background-color: yellow '<CR>P
  35amenu CSS.Background\ Properties.Background-color.RGB.Hex                     "='background-color: # '<CR>P
  35amenu CSS.Background\ Properties.Background-color.RGB.Integer                 "='background-color: rgb( , , ) '<CR>P
  35amenu CSS.Background\ Properties.Background-color.RGB.Percentage              "='background-color: rgb( %, %, %) '<CR>P
  35amenu CSS.Background\ Properties.Background-color.Transparent                 "='background-color: transparent '<CR>P
"        'background-image'
  35amenu CSS.Background\ Properties.Background-image.Url     "='background-image: url(http://) '<CR>P
  35amenu CSS.Background\ Properties.Background-image.None    "='background-image: none '<CR>P
"        'background-repeat'
  35amenu CSS.Background\ Properties.Background-repeat.repeat      "='background-repeat: repeat '<CR>P
  35amenu CSS.Background\ Properties.Background-repeat.repeat-x    "='background-repeat: repeat-x '<CR>P
  35amenu CSS.Background\ Properties.Background-repeat.repeat-y    "='background-repeat: repeat-y '<CR>P
  35amenu CSS.Background\ Properties.Background-repeat.no-repeat   "='background-repeat: no-repeat '<CR>P
"        'background-attachment'
  35amenu CSS.Background\ Properties.Background-attachment.Scroll  "='background-attachment: scroll '<CR>P
  35amenu CSS.Background\ Properties.Background-attachment.Fixed   "='background-attachment: fixed '<CR>P
"        'background-position'
  35amenu CSS.Background\ Properties.Background-position.Percentage    "='background-position: % % '<CR>P
  35amenu CSS.Background\ Properties.Background-position.Length        "='background-position:  '<CR>P
  35amenu CSS.Background\ Properties.Background-position.Keyword       "='background-position: top center bottom left center right '<CR>P
"        'background'
  35amenu CSS.Background\ Properties.Background.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.black     "='black '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.green     "='green '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.lime      "='lime '<CR>P
  35amenu CSS.Background\ Properties.Background.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.red       "='red '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.white     "='white '<CR>P 
  35amenu CSS.Background\ Properties.Background.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Background\ Properties.Background.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Background\ Properties.Background.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Background\ Properties.Background.RGB.Percentage              "='rgb( %, %, %) '<CR>P
  35amenu CSS.Background\ Properties.Background.Transparent                 "='transparent '<CR>P
"        ''
  35amenu CSS.Background\ Properties.Background.Url     "='url(http://) '<CR>P
  35amenu CSS.Background\ Properties.Background.None    "='none '<CR>P
"        ''
  35amenu CSS.Background\ Properties.Background.repeat      "='repeat '<CR>P
  35amenu CSS.Background\ Properties.Background.repeat-x    "='repeat-x '<CR>P
  35amenu CSS.Background\ Properties.Background.repeat-y    "='repeat-y '<CR>P
  35amenu CSS.Background\ Properties.Background.no-repeat   "='no-repeat '<CR>P
"        ''
  35amenu CSS.Background\ Properties.Background.Scroll  "='scroll '<CR>P
  35amenu CSS.Background\ Properties.Background.Fixed   "='fixed '<CR>P
"        ''
  35amenu CSS.Background\ Properties.Background.Percentage "='% % '<CR>P
  35amenu CSS.Background\ Properties.Background.Length     "=' '<CR>P
  35amenu CSS.Background\ Properties.Background.Keyword    "='top center bottom left center right '<CR>P
"
"      Text properties
"        'word-spacing'
  35amenu CSS.Text\ properties.Word-spacing.Normal     "='word-spacing: normal '<CR>P
  35amenu CSS.Text\ properties.Word-spacing.Length     "='word-spacing:  '<CR>P
"        'letter-spacing'
  35amenu CSS.Text\ properties.Letter-spacing.Normal    "='letter-spacing: normal '<CR>P
  35amenu CSS.Text\ properties.Letter-spacing.Length    "='letter-spacing:  '<CR>P
"        'text-decoration'
  35amenu CSS.Text\ properties.Text-decoration.none         "='text-decoration: none '<CR>P 
  35amenu CSS.Text\ properties.Text-decoration.underline    "='text-decoration: underline '<CR>P
  35amenu CSS.Text\ properties.Text-decoration.overline     "='text-decoration: overline '<CR>P
  35amenu CSS.Text\ properties.Text-decoration.line         "='text-decoration: line '<CR>P-through
  35amenu CSS.Text\ properties.Text-decoration.blink        "='text-decoration: blink '<CR>P
"        'vertical-align'
  35amenu CSS.Text\ properties.Vertical-align.baseline     "='vertical-align: baseline '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.sub          "='vertical-align: sub '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.super        "='vertical-align: super '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.top          "='vertical-align: top '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.text         "='vertical-align: text '<CR>P-top 
  35amenu CSS.Text\ properties.Vertical-align.middle       "='vertical-align: middle '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.bottom       "='vertical-align: bottom '<CR>P 
  35amenu CSS.Text\ properties.Vertical-align.text         "='vertical-align: text '<CR>P-bottom 
  35amenu CSS.Text\ properties.Vertical-align.percentage   "='vertical-align: % '<CR>P 
"        'text-transform'
  35amenu CSS.Text\ properties.Text-transform.capitalize    "='text-transform: capitalize '<CR>P 
  35amenu CSS.Text\ properties.Text-transform.uppercase     "='text-transform: uppercase '<CR>P 
  35amenu CSS.Text\ properties.Text-transform.lowercase     "='text-transform: lowercase '<CR>P 
  35amenu CSS.Text\ properties.Text-transform.none          "='text-transform: none '<CR>P
"        'text-align'
  35amenu CSS.Text\ properties.Text-align.left        "='text-align: left '<CR>P 
  35amenu CSS.Text\ properties.Text-align.right        "='text-align: right '<CR>P 
  35amenu CSS.Text\ properties.Text-align.center        "='text-align: center '<CR>P 
  35amenu CSS.Text\ properties.Text-align.justify        "='text-align: justify '<CR>P
"        'text-indent'
  35amenu CSS.Text\ properties.Text-indent        "='text-indent: % '<CR>P
"        'line-height'
  35amenu CSS.Text\ properties.line-height.normal        "='line-height: normal '<CR>P 
  35amenu CSS.Text\ properties.line-height.<number>        "='line-height: <number> '<CR>P 
  35amenu CSS.Text\ properties.line-height.<length>        "='line-height: <length> '<CR>P 
  35amenu CSS.Text\ properties.line-height.<percentage>        "='line-height: <percentage> '<CR>P
"
"      Box properties
"        'margin-top'
  35amenu CSS.Box\ properties.margin-top.<length>      "='margin-top:  '<CR>P 
  35amenu CSS.Box\ properties.margin-top.<percentage>  "='margin-top: % '<CR>P 
  35amenu CSS.Box\ properties.margin-top.auto          "='margin-top: auto '<CR>P
"        'margin-right'
  35amenu CSS.Box\ properties.margin-right.<length>      "='margin-right:  '<CR>P 
  35amenu CSS.Box\ properties.margin-right.<percentage>  "='margin-right: % '<CR>P 
  35amenu CSS.Box\ properties.margin-right.auto          "='margin-right: auto '<CR>P
"        'margin-bottom'
  35amenu CSS.Box\ properties.margin-bottom.<length>      "='margin-bottom:  '<CR>P 
  35amenu CSS.Box\ properties.margin-bottom.<percentage>  "='margin-bottom: % '<CR>P 
  35amenu CSS.Box\ properties.margin-bottom.auto          "='margin-bottom: auto '<CR>P
"        'margin-left'
  35amenu CSS.Box\ properties.margin-left.<length>      "='margin-left:  '<CR>P 
  35amenu CSS.Box\ properties.margin-left.<percentage>  "='margin-left: % '<CR>P 
  35amenu CSS.Box\ properties.margin-left.auto          "='margin-left: auto '<CR>P
"        'margin'
  35amenu CSS.Box\ properties.margin    "='margin: top right bottom left '<CR>P 
"        'padding-top'
  35amenu CSS.Box\ properties.padding-top.<length>      "='padding-top:  '<CR>P 
  35amenu CSS.Box\ properties.padding-top.<percentage>  "='padding-top: % '<CR>P 
"        'padding-right'
  35amenu CSS.Box\ properties.padding-right.<length>      "='padding-right:  '<CR>P 
  35amenu CSS.Box\ properties.padding-right.<percentage>  "='padding-right: % '<CR>P 
"        'padding-bottom'
  35amenu CSS.Box\ properties.padding-bottom.<length>      "='padding-bottom:  '<CR>P 
  35amenu CSS.Box\ properties.padding-bottom.<percentage>  "='padding-bottom: % '<CR>P 
"        'padding-left'
  35amenu CSS.Box\ properties.padding-left.<length>      "='padding-left:  '<CR>P 
  35amenu CSS.Box\ properties.padding-left.<percentage>  "='padding-left: % '<CR>P 
"        'padding'
  35amenu CSS.Box\ properties.margin    "='margin: top right bottom left '<CR>P 
"        'border-top-width'
  35amenu CSS.Box\ properties.border-top-width.thin        "='border-top-width: thin '<CR>P 
  35amenu CSS.Box\ properties.border-top-width.medium        "='border-top-width: medium '<CR>P 
  35amenu CSS.Box\ properties.border-top-width.thick        "='border-top-width: thick '<CR>P 
  35amenu CSS.Box\ properties.border-top-width.<length>        "='border-top-width: <length> '<CR>P
"        'border-right-width'
  35amenu CSS.Box\ properties.border-right-width.thin        "='border-right-width: thin '<CR>P 
  35amenu CSS.Box\ properties.border-right-width.medium        "='border-right-width: medium '<CR>P 
  35amenu CSS.Box\ properties.border-right-width.thick        "='border-right-width: thick '<CR>P 
  35amenu CSS.Box\ properties.border-right-width.<length>        "='border-right-width: <length> '<CR>P
"        'border-bottom-width'
  35amenu CSS.Box\ properties.border-bottom-width.thin        "='border-bottom-width: thin '<CR>P 
  35amenu CSS.Box\ properties.border-bottom-width.medium        "='border-bottom-width: medium '<CR>P 
  35amenu CSS.Box\ properties.border-bottom-width.thick        "='border-bottom-width: thick '<CR>P 
  35amenu CSS.Box\ properties.border-bottom-width.<length>        "='border-bottom-width: <length> '<CR>P
"        'border-left-width'
  35amenu CSS.Box\ properties.border-left-width.thin        "='border-left-width: thin '<CR>P 
  35amenu CSS.Box\ properties.border-left-width.medium        "='border-left-width: medium '<CR>P 
  35amenu CSS.Box\ properties.border-left-width.thick        "='border-left-width: thick '<CR>P 
  35amenu CSS.Box\ properties.border-left-width.<length>        "='border-left-width: <length> '<CR>P
"        'border-width'
  35amenu CSS.Box\ properties.border-width.thin        "='border-width: thin '<CR>P 
  35amenu CSS.Box\ properties.border-width.medium        "='border-width: medium '<CR>P 
  35amenu CSS.Box\ properties.border-width.thick        "='border-width: thick '<CR>P 
  35amenu CSS.Box\ properties.border-width.<length>        "='border-width: <length> '<CR>P
"        'border-color'
  35amenu CSS.Box\ properties.border-color.keywords.aqua      "='border-color: aqua '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.black     "='border-color: black '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.blue      "='border-color: blue '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.fuchsia   "='border-color: fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.gray      "='border-color: gray '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.green     "='border-color: green '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.lime      "='border-color: lime '<CR>P
  35amenu CSS.Box\ properties.border-color.keywords.maroon    "='border-color: maroon '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.navy      "='border-color: navy '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.olive     "='border-color: olive '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.purple    "='border-color: purple '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.red       "='border-color: red '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.silver    "='border-color: silver '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.teal      "='border-color: teal '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.white     "='border-color: white '<CR>P 
  35amenu CSS.Box\ properties.border-color.keywords.yellow    "='border-color: yellow '<CR>P
  35amenu CSS.Box\ properties.border-color.RGB.Hex                     "='border-color: # '<CR>P
  35amenu CSS.Box\ properties.border-color.RGB.Integer                 "='border-color: rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border-color.RGB.Percentage              "='border-color: rgb( %, %, %) '<CR>P
  35amenu CSS.Box\ properties.border-color.Transparent                 "='border-color: transparent '<CR>P
"        'border-style'
  35amenu CSS.Box\ properties.border-style.none        "='border-style: none '<CR>P 
  35amenu CSS.Box\ properties.border-style.dotted        "='border-style: dotted '<CR>P 
  35amenu CSS.Box\ properties.border-style.dashed        "='border-style: dashed '<CR>P 
  35amenu CSS.Box\ properties.border-style.solid        "='border-style: solid '<CR>P 
  35amenu CSS.Box\ properties.border-style.double        "='border-style: double '<CR>P 
  35amenu CSS.Box\ properties.border-style.groove        "='border-style: groove '<CR>P 
  35amenu CSS.Box\ properties.border-style.ridge        "='border-style: ridge '<CR>P 
  35amenu CSS.Box\ properties.border-style.inset        "='border-style: inset '<CR>P 
  35amenu CSS.Box\ properties.border-style.outset        "='border-style: outset '<CR>P
"        'border-top'
"        ''
  35amenu CSS.Box\ properties.border-top.thin        "='thin '<CR>P 
  35amenu CSS.Box\ properties.border-top.medium        "='medium '<CR>P 
  35amenu CSS.Box\ properties.border-top.thick        "='thick '<CR>P 
  35amenu CSS.Box\ properties.border-top.<length>        "= '<length>'<CR>P
"        ''
  35amenu CSS.Box\ properties.border-top.none        "='none '<CR>P 
  35amenu CSS.Box\ properties.border-top.dotted        "='dotted '<CR>P 
  35amenu CSS.Box\ properties.border-top.dashed        "='dashed '<CR>P 
  35amenu CSS.Box\ properties.border-top.solid        "='solid '<CR>P 
  35amenu CSS.Box\ properties.border-top.double        "='double '<CR>P 
  35amenu CSS.Box\ properties.border-top.groove        "='groove '<CR>P 
  35amenu CSS.Box\ properties.border-top.ridge        "='ridge '<CR>P 
  35amenu CSS.Box\ properties.border-top.inset        "='inset '<CR>P 
  35amenu CSS.Box\ properties.border-top.outset        "='outset '<CR>P
"        ''
  35amenu CSS.Box\ properties.border-top.color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.black     "='black '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.green     "='green '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Box\ properties.border-top.color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.red       "='red '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.white     "='white '<CR>P 
  35amenu CSS.Box\ properties.border-top.color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Box\ properties.border-top.color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Box\ properties.border-top.color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border-top.color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'border-right'
"        ''
  35amenu CSS.Box\ properties.border-right.thin        "='thin '<CR>P 
  35amenu CSS.Box\ properties.border-right.medium        "='medium '<CR>P 
  35amenu CSS.Box\ properties.border-right.thick        "='thick '<CR>P 
  35amenu CSS.Box\ properties.border-right.<length>        "= '<length>'<CR>P
"        ''
  35amenu CSS.Box\ properties.border-right.none        "='none '<CR>P 
  35amenu CSS.Box\ properties.border-right.dotted        "='dotted '<CR>P 
  35amenu CSS.Box\ properties.border-right.dashed        "='dashed '<CR>P 
  35amenu CSS.Box\ properties.border-right.solid        "='solid '<CR>P 
  35amenu CSS.Box\ properties.border-right.double        "='double '<CR>P 
  35amenu CSS.Box\ properties.border-right.groove        "='groove '<CR>P 
  35amenu CSS.Box\ properties.border-right.ridge        "='ridge '<CR>P 
  35amenu CSS.Box\ properties.border-right.inset        "='inset '<CR>P 
  35amenu CSS.Box\ properties.border-right.outset        "='outset '<CR>P
"        ''
  35amenu CSS.Box\ properties.border-right.color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.black     "='black '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.green     "='green '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Box\ properties.border-right.color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.red       "='red '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.white     "='white '<CR>P 
  35amenu CSS.Box\ properties.border-right.color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Box\ properties.border-right.color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Box\ properties.border-right.color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border-right.color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'border-bottom'
"        ''
  35amenu CSS.Box\ properties.border-bottom.thin        "='thin '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.medium        "='medium '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.thick        "='thick '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.<length>        "= '<length>'<CR>P
"        ''
  35amenu CSS.Box\ properties.border-bottom.none        "='none '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.dotted        "='dotted '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.dashed        "='dashed '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.solid        "='solid '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.double        "='double '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.groove        "='groove '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.ridge        "='ridge '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.inset        "='inset '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.outset        "='outset '<CR>P
"        ''
  35amenu CSS.Box\ properties.border-bottom.color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.black     "='black '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.green     "='green '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Box\ properties.border-bottom.color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.red       "='red '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.white     "='white '<CR>P 
  35amenu CSS.Box\ properties.border-bottom.color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Box\ properties.border-bottom.color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Box\ properties.border-bottom.color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border-bottom.color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'border-left'
"        ''
  35amenu CSS.Box\ properties.border-left.thin        "='thin '<CR>P 
  35amenu CSS.Box\ properties.border-left.medium        "='medium '<CR>P 
  35amenu CSS.Box\ properties.border-left.thick        "='thick '<CR>P 
  35amenu CSS.Box\ properties.border-left.<length>        "= '<length>'<CR>P
"        ''
  35amenu CSS.Box\ properties.border-left.none        "='none '<CR>P 
  35amenu CSS.Box\ properties.border-left.dotted        "='dotted '<CR>P 
  35amenu CSS.Box\ properties.border-left.dashed        "='dashed '<CR>P 
  35amenu CSS.Box\ properties.border-left.solid        "='solid '<CR>P 
  35amenu CSS.Box\ properties.border-left.double        "='double '<CR>P 
  35amenu CSS.Box\ properties.border-left.groove        "='groove '<CR>P 
  35amenu CSS.Box\ properties.border-left.ridge        "='ridge '<CR>P 
  35amenu CSS.Box\ properties.border-left.inset        "='inset '<CR>P 
  35amenu CSS.Box\ properties.border-left.outset        "='outset '<CR>P
"        ''
  35amenu CSS.Box\ properties.border-left.color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.black     "='black '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.green     "='green '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Box\ properties.border-left.color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.red       "='red '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.white     "='white '<CR>P 
  35amenu CSS.Box\ properties.border-left.color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Box\ properties.border-left.color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Box\ properties.border-left.color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border-left.color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'border'
"        ''
  35amenu CSS.Box\ properties.border.thin        "='thin '<CR>P 
  35amenu CSS.Box\ properties.border.medium        "='medium '<CR>P 
  35amenu CSS.Box\ properties.border.thick        "='thick '<CR>P 
  35amenu CSS.Box\ properties.border.<length>        "='<length> '<CR>P
"        ''
  35amenu CSS.Box\ properties.border.none        "='none '<CR>P 
  35amenu CSS.Box\ properties.border.dotted        "='dotted '<CR>P 
  35amenu CSS.Box\ properties.border.dashed        "='dashed '<CR>P 
  35amenu CSS.Box\ properties.border.solid        "='solid '<CR>P 
  35amenu CSS.Box\ properties.border.double        "='double '<CR>P 
  35amenu CSS.Box\ properties.border.groove        "='groove '<CR>P 
  35amenu CSS.Box\ properties.border.ridge        "='ridge '<CR>P 
  35amenu CSS.Box\ properties.border.inset        "='inset '<CR>P 
  35amenu CSS.Box\ properties.border.outset        "='outset '<CR>P
"        ''
  35amenu CSS.Box\ properties.border.color.keywords.aqua      "='aqua '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.black     "='black '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.blue      "='blue '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.fuchsia   "='fuchsia '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.gray      "='gray '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.green     "='green '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.lime      "='lime '<CR>P
  35amenu CSS.Box\ properties.border.color.keywords.maroon    "='maroon '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.navy      "='navy '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.olive     "='olive '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.purple    "='purple '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.red       "='red '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.silver    "='silver '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.teal      "='teal '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.white     "='white '<CR>P 
  35amenu CSS.Box\ properties.border.color.keywords.yellow    "='yellow '<CR>P
  35amenu CSS.Box\ properties.border.color.RGB.Hex                     "='# '<CR>P
  35amenu CSS.Box\ properties.border.color.RGB.Integer                 "='rgb( , , ) '<CR>P
  35amenu CSS.Box\ properties.border.color.RGB.Percentage              "='rgb( %, %, %) '<CR>P
"        'width'
  35amenu CSS.Box\ properties.width.<length>      "='width:  '<CR>P 
  35amenu CSS.Box\ properties.width.<percentage>  "='width: % '<CR>P 
  35amenu CSS.Box\ properties.width.auto          "='width: auto '<CR>P
"        'height'
  35amenu CSS.Box\ properties.height.<length>      "='height:  '<CR>P 
  35amenu CSS.Box\ properties.height.auto          "='height: auto '<CR>P
"        'float'
  35amenu CSS.Box\ properties.float.right   "='float: right '<CR>P 
  35amenu CSS.Box\ properties.float.left    "='float: left '<CR>P 
  35amenu CSS.Box\ properties.float.none    "='float: none '<CR>P
"        'clear'
  35amenu CSS.Box\ properties.clear.none    "='clear: none '<CR>P
  35amenu CSS.Box\ properties.clear.right   "='clear: right '<CR>P 
  35amenu CSS.Box\ properties.clear.left    "='clear: left '<CR>P 
  35amenu CSS.Box\ properties.clear.both    "='clear: both '<CR>P
"
"      Classification properties
"        'display'
  35amenu CSS.Classification\ properties.display.block       "='display: block  '<CR>P
  35amenu CSS.Classification\ properties.display.inline      "='display: inline  '<CR>P
  35amenu CSS.Classification\ properties.display.list-item   "='display: list-item  '<CR>P
  35amenu CSS.Classification\ properties.display.none        "='display: none '<CR>P
"        'white-space'
  35amenu CSS.Classification\ properties.white-space.normal  "='white-space: normal  '<CR>P
  35amenu CSS.Classification\ properties.white-space.pre     "='white-space: pre  '<CR>P
  35amenu CSS.Classification\ properties.white-space.nowrap  "='white-space: nowrap '<CR>P
"        'list-style-type'
  35amenu CSS.Classification\ properties.list-style-type.disc        "='list-style-type: disc '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.circle      "='list-style-type: circle '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.square      "='list-style-type: square '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.decimal     "='list-style-type: decimal '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.lower-roman "='list-style-type: lower-roman '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.upper-roman "='list-style-type: upper-roman '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.lower-alpha "='list-style-type: lower-alpha '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.upper-alpha "='list-style-type: upper-alpha '<CR>P
  35amenu CSS.Classification\ properties.list-style-type.none        "='list-style-type: none '<CR>P
"        'list-style-image'
  35amenu CSS.Classification\ properties.list-style-image.none     "='list-style-image: none '<CR>P
  35amenu CSS.Classification\ properties.list-style-image.<url>     "='list-style-image: url(http://) '<CR>P
"        'list-style-position\'
  35amenu CSS.Classification\ properties.list-style-position.inside     "='list-style-position: inside  '<CR>P
  35amenu CSS.Classification\ properties.list-style-position.outside    "='list-style-position: outside '<CR>P
"        'list-style'
"        ''
  35amenu CSS.Classification\ properties.list-style.disc        "='disc '<CR>P
  35amenu CSS.Classification\ properties.list-style.circle      "='circle '<CR>P
  35amenu CSS.Classification\ properties.list-style.square      "='square '<CR>P
  35amenu CSS.Classification\ properties.list-style.decimal     "='decimal '<CR>P
  35amenu CSS.Classification\ properties.list-style.lower-roman "='lower-roman '<CR>P
  35amenu CSS.Classification\ properties.list-style.upper-roman "='upper-roman '<CR>P
  35amenu CSS.Classification\ properties.list-style.lower-alpha "='lower-alpha '<CR>P
  35amenu CSS.Classification\ properties.list-style.upper-alpha "='upper-alpha '<CR>P
  35amenu CSS.Classification\ properties.list-style.none        "='none '<CR>P
"        ''
  35amenu CSS.Classification\ properties.list-style.none        "='none '<CR>P
  35amenu CSS.Classification\ properties.list-style.<url>       "='url(http://) '<CR>P
"        ''
  35amenu CSS.Classification\ properties.list-style.inside      "='inside  '<CR>P
  35amenu CSS.Classification\ properties.list-style.outside     "='outside '<CR>P
"
"      Units
"        Length units
  35amenu CSS.Units.Absolute.inches         "='in '<CR>P
  35amenu CSS.Units.Absolute.centimeters    "='cm '<CR>P
  35amenu CSS.Units.Absolute.millimeters    "='mm '<CR>P
  35amenu CSS.Units.Absolute.points         "='pt '<CR>P
  35amenu CSS.Units.Absolute.picas          "='pc '<CR>P
  35amenu CSS.Units.Relative.ems            "='em '<CR>P
  35amenu CSS.Units.Relative.x-height       "='ex '<CR>P
  35amenu CSS.Units.Relative.pixels         "='px '<CR>P
"        Percentage units
  35amenu CSS.Units.Percentage              "='% '<CR>P
"
"      Anchor pseudo-classes
  35amenu CSS.Anchor\ pseudo-classes.unvisited\ link    "='A:link '<CR>P
  35amenu CSS.Anchor\ pseudo-classes.visited\ links     "='A:visited '<CR>P
  35amenu CSS.Anchor\ pseudo-classes.active\ links      "='A:active '<CR>P
"
"      Typographical pseudo-elements
  35amenu CSS.Typographical\ pseudo-elements.first-line     "=':first-line '<CR>P
  35amenu CSS.Typographical\ pseudo-elements.first-letter   "=':first-letter '<CR>P
"
" Restore the previous value of 'cpoptions'.
let &cpo = cpo_save
unlet cpo_save
