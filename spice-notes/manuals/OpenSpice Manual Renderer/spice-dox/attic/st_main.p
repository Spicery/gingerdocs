include system;
include lists;
include properties;
include fileio;
include useful;
include ragbag;

include st_tokens;
include st_mean;
include st_parse;

define procedure defWrapper( name, endName, action ) as
    [name,      consMeaning( name, `strong`, `FxendF`, endName, 0, action )],
    [endName,   consMeaning( endName, `strong`, `endF`, name, 0, oops )]
enddefine;

define procedure defWeakWrapper( name, endName, action ) as
    [name,      consMeaning( name, `weak`, `FxendF`, endName, 0, action )],
    [endName,   consMeaning( endName, `weak`, `endF`, name, 0, oops )]
enddefine;

define procedure defSimple( name, action ) as
    [name,      consMeaning( name, `strong`, `F`, absent, 0, action )]
enddefine;

define procedure defSimpleWrapper( name, wrapper ) as
    val endName = consWord(# "end".explode, name.explode #);
    defWrapper( name, endName, evalWrap(% wrapper %) )
enddefine;

define procedure defSimpleNoParaWrapper( name, wrapper ) as
    val endName = consWord(# "end".explode, name.explode #);
    defWeakWrapper( name, endName, evalNoParaWrap(% wrapper %) )
enddefine;

define procedure defOperator( name, rank, proc ) as
    [name,  consMeaning( name, `strong`, `plain`, [], rank, evalOp(% name, proc %) )]
enddefine;

define procedure evalOp( x, name, proc ) as
    [x.dl -> (val L, val R)] @erase;
    '(', L.evalItem, name, R.evalItem, ')'
enddefine;

define procedure defInfix( name, level, action ) as
    [name, consMeaning( name, `weak`, `xFx`, [], level, action )]
enddefine;

define procedure defPrefix( name, action ) as
    [name, consMeaning( name, `weak`, `Fx`, [], 20, action )]
enddefine;

define procedure evalLinkto( x ) as
    [x.dl -> (val L, val R)] @erase;
    L.evalItem, " (", R.evalItem, ")"
enddefine;

define procedure evalLabel( x ) as
    consString
        (#
        "\\label{".explode,
        x.front.meanArg.front.explode,
        "}".explode
        #) @literal
enddefine;

define procedure evalRef( x ) as
    [x.dl -> (val L, val R)] @erase;
    consString
        (#
        "\\ref={".explode,
        L.meanArg.front.explode,
        "}".explode
        #) @literal,
    R.evalItem
enddefine;

define procedure evalBrackets( x ) as
    x @appList evalItem
enddefine;

define procedure evalN( x ) as
    "\\\\ \n" @literal
enddefine;

define procedure evalT( x ) as
    " \\> " @literal
enddefine;

define procedure evalBoxes( x ) as
    x @appList evalItem
enddefine;

val wordTable = newProperty
    (
    [
        defInfix( `linkto`, 20, evalLinkto );
        defPrefix( `label`, evalLabel );
        defInfix( `ref`, 20, evalRef );
;;;        defWeakWrapper( `\(`, `\)`, evalVisibleBrackets );
;;;        defWeakWrapper( `\[`, `\]`, evalVisibleBoxes );
;;;
        defSimpleNoParaWrapper( `asis`, `pre` );
        defWrapper( `part`, `endpart`, evalPart ),
        defWrapper( `indented`, `endindented`, evalIndented ),
        defWrapper( `title`, `endtitle`, evalTitle ),
        defWrapper( `chapter`, `endchapter`, evalChapter ),
        defWrapper( `appendix`, `endappendix`, evalAppendix ),
        defWrapper( `section`, `endsection`, evalSection ),
        defWrapper( `passage`, `endpassage`, evalPassage ),
        defWrapper( `fragment`, `endfragment`, evalFragment ),
        defWrapper( `list`, `endlist`, evalList ),
        defWrapper( `syntax`, `endsyntax`, evalSyntax ),
        defWrapper( `issue`, `endissue`, evalIssue ),
        defWrapper( `row`, `endrow`, evalRow ),
        defWrapper( `spice`, `endspice`, evalSpice ),
        defWrapper( `table`, `endtable`, evalTable ),
        defSimple( `allsyntax`, evalAllSyntax ),
        defSimple( `allissues`, evalAllIssues ),
        defSimple( `n`, evalN ),
        defSimple( `t`, evalT ),
        defSimple( `contents`, evalContents ),
        [`$`,       consMeaning( `$`, `daft`, `$`, absent, 0, oops )]
    ],
    1000,
    absent,
    `perm`
    );

define procedure [resolve] evalWord( w ) as
    w.dl
enddefine;

define procedure asNormal( w ) as
    consMeaning( w, `weak`, `x`, [w], 0, evalWord )
enddefine;

define procedure [resolve] sysLookupWord( w ) as
    val m = w.wordTable;
    if m == absent then w.asNormal ->> w.wordTable else m endif
    ;;; -> val it; [`look up`, w, `gets`, it].reportln; it
enddefine;

define recordkey Context as
    conNumbering
    conProperties
enddefine;

val theContext = consContext
    (
        {0, 0, 0, 0, 0, 0},
        newProperty( [], 100, absent, `perm` )
    );

define procedure isNumbering( stuff ) as
    0 < stuff.length and '0' <= stuff?1 and stuff?1 <= '9'
enddefine;

define procedure splitTitle( stuff ) as
    val x = stuff.meanArg.front;
    if x.isNumbering then
        var i = 1;
        loop search
            if i <= x.length and (x?i == '.' or ('0' <= x?i and x?i <= '9')) then
                i + 1 -> i, search again
            else
                (x @leftpart i-1, x @rightpart i -> stuff.meanArg.front, stuff)
            endif
        endloop
    else
        ("", stuff)
    endif
enddefine;

define procedure nextNumber( depth, leading ) as
    val v = theContext.conNumbering;
    if leading.length > 0 then
        leading
    else
        for i from depth + 1 to v.length do 0 -> v!i endfor;
        v!depth + 1 -> v!depth;
        consString
            (#
            var gap = "";
            for i from 1 to depth do
                gap @printOn identfn, "." -> gap, v!i @printOn identfn
            endfor
            #)
    endif
enddefine;

var contentsList = [];

define procedure displayContents() as
;;;     for c in_list contentsList.rev do
;;;         if c.left <= 3 then
;;;             "<br>",
;;;             if c.left == 2 then " SPACE; " endif,
;;;             if c.left == 3 then " SPACE;SPACE;" endif,
;;;             c.right
;;;         endif
;;;     endfor
enddefine;

define procedure evalContents( x ) as
    displayContents
enddefine;

define procedure evalWrap( x, wrapper ) as
    catStrings(# "<", wrapper, ">" #),
    x @evalItemParaList,
    catStrings(# "</", wrapper, ">" #)
enddefine;

define procedure evalNoParaWrap( x, wrapper ) as
    catStrings(# "<", wrapper, ">" #),
    x @appList evalItem,
    catStrings(# "</", wrapper, ">" #)
enddefine;

var savedTitle = false;

define procedure evalTitle( x ) as
    x @mapList evalItem -> savedTitle;
    ;;; "<h1>", savedTitle.dl, "</h1>"
enddefine;

define procedure delayedTitle() as
    if savedTitle then "\\title{" @literal, savedTitle.dl, "}\n" @literal endif
enddefine;

define procedure catStrings( n ) as
    val args = n.consList;
    consString(# args @appList printOn(% identfn %) #)
enddefine;

val headerStrings =
    {
    consCouple( "\\chapter{", "}\n" ),
    consCouple( "\\section{", "}\n" ),
    consCouple( "\\subsection{", "}\n" ),
    consCouple( "\\subsubsection{", "}\n" ),
    consCouple( "\\paragraph{", "}\n" ),
    consCouple( "\\subparagraph", "}\n" ),
    };

define procedure doHeaded( x, level, command ) as
    val loc = `here`.genSym;
    x.front.splitTitle -> (val numeric, val title);
    ;;; val header = catStrings(# level @nextNumber numeric, space, title.evalItem #);
    val header = title.evalItem;
    [level | contentsList] -> contentsList;
    "\\" @literal, command, "{" @literal, header, "}\n" @literal,
    x.tl @evalItemParaList
enddefine;

var inAppendix = false;

define procedure setAppendix() as
    unless inAppendix do
        "\\appendix\n" @literal, true -> inAppendix
    endunless
enddefine;

define procedure evalAppendix( x ) as
    setAppendix, x @doHeaded (1, "chapter")
enddefine;

define procedure evalChapter( x ) as
    x @doHeaded (1, "chapter")
enddefine;

define procedure evalSection( x ) as
    x @doHeaded (2, "section")
enddefine;

define procedure evalPassage( x ) as
    x @doHeaded (3, "subsection")
enddefine;

define procedure evalFragment( x ) as
    x @doHeaded (4, "subsubsection")
enddefine;

define procedure evalIndented( x ) as
    "\\begin{quote}" @literal, x @appList evalItem, "\\end{quote}" @literal
enddefine;

define procedure evalPart( x ) as
    "\\part{" @literal, x.hd.evalItem, "}\n" @literal,
    x.tl @appList evalItem, "\n\n"
enddefine;

define procedure evalList( elems ) as
    "\\begin{itemize}" @literal,
    for x in_list elems do "\\item " @literal, x.evalItem, "\n\n" endfor,
    "\\end{itemize}" @literal
enddefine;

define procedure evalSpice( blocks ) as
    var gap = "";
    "\\begin{quote}\n" @literal,
    "\\begin{verbatim}\n" @literal,
    for x in_list blocks do
        gap, "\n" -> gap, [x.evalItem] @mapList literal
    endfor,
    "\\end{verbatim}\n" @literal,
    "\\end{quote}\n" @literal
enddefine;

var theseIssues = [];

define procedure evalIssue( x ) as
    [
    "\n\n",
    "{\\bf " @literal, x.front @evalItemPara, "}" @literal,
    x.back @evalItemParaList,
    ""
    ] -> val thisIssue;
    thisIssue @consPair theseIssues -> theseIssues;
    thisIssue.dl
enddefine;

define procedure evalAllIssues( x ) as
    theseIssues.rev @appList dl
enddefine;

var syntaxDefs = [];
var syntaxCount = 0;

define procedure evalAllSyntax( x ) as
    syntaxDefs.rev @appList dl
enddefine;

define procedure argLength( x ) as
    if x == absent or x == [] then 0 else x.front.length endif
enddefine;

define procedure addItemLength( n, x ) as
    n + x.length
enddefine;

define procedure xxmeanArg( x ) as
    val a = x.meanArg;
    if a.null then
        mishap(# "argh! it has a null arg!", x #)
    endif;
    a
enddefine;

define procedure startsWith( items, word ) as
    if items.null then false
    elseif word.isList then items.hd.xxmeanArg.front @member word
    else items.hd.xxmeanArg.front == word
    endif
enddefine;

define procedure parseItem( items ) as
    if items @startsWith `\(` then
        items.back.parseAlts -> (val it, items);
        it, items.back
    elseif items @startsWith `\[` then
        items.back.parseAlts -> (val it, items);
        [`OPT`, it], items.back
    else
        items.dest
    endif
enddefine;

define procedure parseAlt( items ) as
    [`SEQ`,
        repeat
            breakif (items.null or (items @startsWith [`\| \] \)`]));
            items.parseItem -> (val it, items);
            if (items @startsWith `*`) or (items @startsWith `**`)
            or (items @startsWith `+`) or (items @startsWith `++`)
            then [`STAR`, items.hd, it], items.tl -> items
            else it
            endif
        endrepeat
    ], items
enddefine;

define procedure parseAlts( items ) as
    [`ALT`,
        repeat
            items.parseAlt -> (val alt, items);
            alt;
            breakunless (items @startsWith `\|`);
            items.tl -> items
        endrepeat
    ], items
enddefine;

define procedure evalVisibleBrackets( x ) as
    `\(`, x @showSeq ("", true), `\)`
enddefine;

define procedure evalVisibleBoxes( x ) as
    "[", x @showSeq ("", true), "]"
enddefine;

define procedure showItem( item, nested ) as
    if item.isMeaning then
        item @evalItem
    else
        val key = item.front;
        if key == `SEQ` then
            `(`, item.back @showSeq ("", true), `)`
        elseif key == `ALT` then
            `(`, showAlts( "", item, "", true), `)`
        elseif key == `STAR` then
            item.back.back.front @showItem true,
            item.back.front @showItem true @literal
        elseif key == `OPT` then
            "[", item.back.front @showItem true, "]"
        else
            mishap(# "oh dear", item #)
        endif
    endif
enddefine;

define procedure blobSum( n, x ) as
    n + x.blobLength + 1
enddefine;

define procedure blobLength( x ) as
    if x.isList then (0, x) @appList blobSum
    else x.length
    endif
enddefine;

define procedure showSeq( seq, prefix, nested ) as
    var gap = "";
    val k = seq.blobLength;
    ;;; ["blobLength", k].reportln;
    if k < 72 or nested then
        for item in_list seq do
            prefix, gap, " " -> gap, item @showItem true
        endfor
    else
        "\\begin{tabular}{l}\n" @literal,
        for item in_list seq do
            prefix, gap, " " -> gap, item @showItem nested, " \\\\ \n" @literal
        endfor,
        "\\end{tabular}\n" @literal
    endif
enddefine;

define procedure showAlts( prefix, alts, suffix, nested ) as
    var sep = "";
    if nested then
        for alt in_list alts.back do
            prefix, sep, alt.back @showSeq ("", true), suffix,
            " !| " -> sep
        endfor
    else
        for alt in_list alts.back do
            prefix, sep, alt.back @showSeq ("", nested), suffix,
            " !| " -> sep
        endfor
    endif
enddefine;

define procedure reportItems( x ) as
    " ".report;
    if x.isList then
        "[".report, x @appList reportItems, "]".report
    else
        if x.isMeaning then x.meanArg @reportItems else x.report endif
    endif
enddefine;

define procedure formRhs( items ) as
    val maxWidth = 72;
    val n = appList( 0, items, addItemLength );
    ;;; [`length =`, n].reportln;
    ;;; "-- item sequence -------------------------------------------".reportln;
    ;;; items.reportItems, [].reportln;
    items.parseAlts -> (val alts, items);
    ;;; "-- parsed alternatives ------------------------------------".reportln;
    ;;; alts.reportItems, [].reportln;
    ;;; [`addItemLength=`, n].reportln;
    showAlts ("\\hspace*{3mm}{\\tt " @literal, alts, "} \\\\ \n" @literal, false)
enddefine;

define procedure evalSyntax( x ) as
    syntaxCount + 1 ->> syntaxCount -> val count;
    val thisDef =
        [
        "\\begin{tabular}{l}\n" @literal,
        "{\\bf " @literal,
            `def`, consString(# count @printOn identfn, '.' #), " ",
            x.front.evalItem, " ::= ",
        "}" @literal,
        "\\\\ \n" @literal,
        x.back.formRhs,
        "\\end{tabular}\n\n" @literal
        ];
    thisDef @consPair syntaxDefs -> syntaxDefs;
    thisDef.dl
enddefine;

define procedure evalAlt( x ) as
    "\n\nZZZ" @literal
enddefine;

define procedure evalRow( L ) as
    L @mapList evalItem
enddefine;

define procedure evalTable( L ) as
    "\\begin{tabular}" @literal,
    "{|" @literal, repeat L.hd.length times "l" endrepeat, "|}" @literal, "\n",
    for row in_list L @mapList evalItem do
        var sep = "";
        for item in_list row do
            sep, item, " &" @literal -> sep
        endfor,
        "\\\\ \n" @literal
    endfor,
    "\\end{tabular}\n" @literal
enddefine;

define procedure evalItemPara( x ) as
    "\n\n", x.evalItem
enddefine;

define procedure evalItemParaList( xL ) as
    ;;; when should paragraphs breaks be inserted?
    ;;; -- between successive strings, I think. So ...
    var pending = [];
    repeat until xL.null do
        xL.dest -> (val this, xL);
        if this.meanAction == evalString then
            if this.meanTitle == `paraString` then
                "\n\n", pending.rev @appList evalItem, this.evalItem, "";
                [] -> pending
            else
                this @consPair pending -> pending
            endif
        else
            if this.meanStrength == `strong` then
                "\n\n", pending.rev @appList evalItem, this.evalItem, "";
                [] -> pending
            else
                this @consPair pending -> pending
            endif
        endif
    endrepeat;
    unless pending.null do
        "\n\n", pending.rev @appList evalItem, ""
    endunless;
enddefine;

define procedure evalItem( item ) as
    (item.meanAction)( item.meanArg )
enddefine;

var inSuper = false;
var inSub = false;
var inBold = false;
var inCode = false;
var inItalics = false;
var inMaths = false;

var really = false;

;;; convert characters for output, keeping track of various settings

define procedure literal( x ) as
    print(% x %)
enddefine;

define procedure texLiteral( ch ) as
    if ch == '_' then       '\\'.charout, ch.charout
    elseif ch == '{' then   '\\'.charout, ch.charout
    elseif ch == '}' then   '\\'.charout, ch.charout
    elseif ch == '#' then   '\\'.charout, ch.charout
    elseif ch == '%' then   '\\'.charout, ch.charout
    elseif ch == '$' then   '\\'.charout, ch.charout
    elseif ch == '&' then   '\\'.charout, ch.charout
    elseif ch == '[' then   "{[}".print
    elseif ch == ']' then   "{]}".print
    elseif ch == '^' then
        unless inMaths do '$'.charout endunless;
        "^\\wedge".print;
        unless inMaths do '$'.charout endunless;
    elseif ch == '\\' then
        unless inMaths do '$'.charout endunless;
        "\\setminus".print;
        unless inMaths do '$'.charout endunless;
    elseif ch == '<' then
        unless inMaths do '$'.charout endunless;
        "<".print;
        unless inMaths do '$'.charout endunless;
    elseif ch == '>' then
        unless inMaths do '$'.charout endunless;
        ">".print;
        unless inMaths do '$'.charout endunless;
    elseif ch == '|' then
        unless inMaths do '$'.charout endunless;
        "\\mid".print;
        unless inMaths do '$'.charout endunless;
    else
        ch.charout
    endif
enddefine;

define procedure texOutput( ch ) as
    if really then
        ch.texLiteral;
        false -> really
    else
        if ch == '!' then
            true -> really
        elseif ch == '_' then
            if inBold then "}".print; false -> inBold
            else "{\\bf ".print; true -> inBold
            endif
        elseif ch == '*' then
            if inItalics then "}".print; false -> inItalics
            else "{\\em ".print; true -> inItalics
            endif
        elseif ch == '~' then
            if inSub then "$".print; false -> inSub
            else "$_ ".print; true -> inSub
            endif
        elseif ch == '^' then
            if inSuper then "$".print; false -> inSuper
            else "$^ ".print; true -> inSuper
            endif
        elseif ch == '|' then
            if inCode then "}".print; false -> inCode
            else "{\\tt ".print; true -> inCode
            endif
        else
            ch.texLiteral
        endif
    endif
enddefine;

define procedure printItem( item ) as
    if item.isList then item @appList printItem
    elseif item.isProcedure then [item()] @appList printItem
    else item @printOn texOutput
    endif
enddefine;

define procedure tokenise( r, width ) as
    val mode = consCouple( 0, absent );
    [
        "\\documentclass{report}\n" @literal,
        "\\setlength{\\parindent}{0in}\n" @literal,
        "\\setlength{\\parskip}{2mm}\n" @literal,
        delayedTitle,
        "\\author{Chris Dollin}\n" @literal,
        "\\begin{document}\n" @literal,
        "\\maketitle\n" @literal,
        "\\tableofcontents\n" @literal,
        r @parseRepeatedly (mode, width) @erase @appList evalItemPara,
        "\\end{document}\n" @literal
    ] @appList printItem
enddefine;

define procedure handleFile( arg ) as
    sysLookupWord -> lookupWord;
    val r = arg.charsFromFile;
    r @tokenise widestWidth
enddefine;

define procedure handleSet( arg ) as
    ;;; do nothing, today.
enddefine;

define procedure main( n ) as
    val args = n.consList;
    var action = handleFile;
    for arg in_list args do
        ;;; ["-- doing", arg].reportln;
        if arg = "-file" then handleFile -> action
        elseif arg = "-set" then handleSet -> action
        else arg @action
        endif
    endfor
enddefine;
