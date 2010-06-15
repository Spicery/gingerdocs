section $-latex => renderToLatex;

define isListOfMeaning( x );
    returnunless( x.islist )( false );
    lvars i;
    for i in x do
        returnunless( i.isMeaning )( false )
    endfor;
    true;
enddefine;

vars procedure ( literal, evalItem );

define evalString( w );
    w @applist identfn
enddefine;

define evalWord( w );
    w.dl
enddefine;

define evalOp( x, name, proc );
    lvars ( L, R ) = x.dest.hd;
    `(`, L.evalItem, name, R.evalItem, `)`
enddefine;

define evalLinkTo( x );
    lvars ( L, R ) = x.dest.hd;
    L.evalItem, ' (', R.evalItem, ')'
enddefine;

define evalLabel( x );
    consstring(#|
        '\\label{'.explode,
        x.front.meaningArg.front.explode,
        '}'.explode
    |#) @literal
enddefine;

define evalRef( x );
    lvars ( L, R ) = x.dest.hd;
    consstring(#|
        '\\ref={'.explode,
        L.meaningArg.front.explode,
        '}'.explode
    |#) @literal,
    R.evalItem
enddefine;

define evalBrackets( x );
    x @applist evalItem
enddefine;

define evalN( x );
    '\\\\ \n' @literal
enddefine;

define evalT( x );
    ' \\> ' @literal
enddefine;

define evalBoxes( x );
    x @applist evalItem
enddefine;

define isNumbering( stuff );
    check stuff : string;
    0 < stuff.datalength and isnumbercode( subscrs( 1, stuff ) )
enddefine;

;;;
;;; Not too sure what leftpart & rightpart are meant to do - but it
;;; looks like a string slicing operation.  Check back with Chris whether
;;; I have guessed correctly.
;;;

define leftpart( str, n );
    consstring(#|
        lvars i;
        for i from 1 to n - 1 do
            subscrs( i, str )
        endfor
    |#)
enddefine;

define rightpart( str, n );
    consstring(#|
        lvars i;
        for i from n + 1 to str.datalength do
            subscrs( i, str )
        endfor
    |#)
enddefine;

define splitDocTitle( stuff );
    lvars x = stuff.meaningArg.front;
    check x : string;
    if x.isNumbering then
        lvars i = 1;
        while i <= x.datalength do
            lvars ch = subscrs( i, x );
            quitunless( ch == `.` or ch.isnumbercode );
            i + 1 -> i
        endwhile;
        ( x @leftpart i-1, x @rightpart i -> stuff.meaningArg.front, stuff )
    else
        ('', stuff)
    endif
enddefine;


;;; define nextNumber( depth, leading );
;;;     mishap( 'This is never called', [] );
;;;     lvars v = theContext.conNumbering;
;;;     if leading.pepperLength > 0 then
;;;         leading
;;;     else
;;;         lvars i;
;;;         for i from depth + 1 to v.pepperLength do
;;;             0 -> subscrv( i, v )
;;;         endfor;
;;;         subscrv( depth, v ) + 1 -> subscrs( depth, v );
;;;         consstring(#|
;;;             lvars gap = '';
;;;             for i from 1 to depth do
;;;                 gap @printOn identfn, '.' -> gap, subscrs( i, v) @printOn identfn
;;;             endfor
;;;         |#)
;;;     endif
;;; enddefine;

vars contentsList = [];

define displayContents();
;;;     for c in_list contentsList.rev do
;;;         if c.left <= 3 then
;;;             "<br>",
;;;             if c.left == 2 then " SPACE; " endif,
;;;             if c.left == 3 then " SPACE;SPACE;" endif,
;;;             c.right
;;;         endif
;;;     endfor
enddefine;

define evalContents( x );
    displayContents
enddefine;

define catStrings( n );
    lvars L = conslist( n );
    consstring(#| applist( L, explode ) |#)
enddefine;

vars procedure ( evalItemParaList );

define evalWrap( x, wrapper );
    catStrings(#| '<', wrapper, '>' |#),
    x @evalItemParaList,
    catStrings(#| '</', wrapper, '>' |#)
enddefine;

define evalNoParaWrap( x, wrapper );
    catStrings(#| '<', wrapper, '>' |#),
    x @applist evalItem,
    catStrings(#| '</', wrapper, '>' |#)
enddefine;

vars savedDocTitle = false;

define evalDocTitle( x );
    x @maplist evalItem -> savedDocTitle;
    ;;; "<h1>", savedDocTitle.dl, "</h1>"
enddefine;

define delayedDocTitle();
    if savedDocTitle then
        '\\title{' @literal,
        savedDocTitle.dl;
        '}\n' @literal;
    endif
enddefine;

define doHeaded( x, level, command );
    lvars loc = "here".gensym;
    lvars ( numeric, title ) = x.front.splitDocTitle;
    ;;; val header = catStrings(# level @nextNumber numeric, space, title.evalItem #);
    lvars header = title.evalItem;
    [ ^level ^^contentsList] -> contentsList;
    '\\' @literal, command, '{' @literal, header, '}\n' @literal,
    x.tl @evalItemParaList
enddefine;

vars inAppendix = false;

define setAppendix();
    unless inAppendix do
        '\\appendix\n' @literal, true -> inAppendix
    endunless
enddefine;

define evalAppendix( x );
    setAppendix, x @doHeaded (1, 'chapter')
enddefine;

define evalChapter( x );
    x @doHeaded (1, 'chapter')
enddefine;

define evalSection( x );
    x @doHeaded (2, 'section')
enddefine;

define evalPassage( x );
    x @doHeaded (3, 'subsection')
enddefine;

define evalFragment( x );
    x @doHeaded (4, 'subsubsection')
enddefine;

define evalIndented( x );
    '\\begin{quote}' @literal,
    x @applist evalItem,
    '\\end{quote}' @literal
enddefine;

define evalPart( x );
    '\\part{' @literal,
    x.hd.evalItem,
    '}\n' @literal,
    x.tl @applist evalItem, '\n\n'
enddefine;

define evalList( elems );
    '\\begin{itemize}' @literal,
    lvars x;
    for x in elems do '\\item ' @literal, x.evalItem, '\n\n' endfor,
    '\\end{itemize}' @literal
enddefine;

define evalSpice( blocks );
    lvars gap = '';
    '\\begin{quote}\n' @literal,
    '\\begin{verbatim}\n' @literal,
    lvars x;
    for x in blocks do
        gap, '\n' -> gap, [%x.evalItem%] @maplist literal
    endfor,
    '\\end{verbatim}\n' @literal,
    '\\end{quote}\n' @literal
enddefine;

vars theseIssues = [];

vars procedure ( evalItemPara );

define evalIssue( x );
    lvars thisIssue;
    [%
        '\n\n',
        '{\\bf ' @literal, x.front @evalItemPara, '}' @literal,
        x.back @evalItemParaList,
        ''
    %] -> thisIssue;
    thisIssue @conspair theseIssues -> theseIssues;
    thisIssue.dl
enddefine;

define evalAllIssues( x );
    theseIssues.rev @applist dl
enddefine;

vars syntaxDefs = [];
vars syntaxCount = 0;

define evalAllSyntax( x );
    syntaxDefs.rev @applist dl
enddefine;

define xxmeanArg( x );
    lvars a = x.meaningArg;
    if a.null then
        mishap( x, 1, 'argh! it has a null arg!' )
    endif;
    a
enddefine;

define startsWith( items, word );
    if items.null then false
    elseif word.islist then items.hd.xxmeanArg.front @member word
    else items.hd.xxmeanArg.front == word
    endif
enddefine;

vars procedure ( parseAlts );

define parseItem( items );
    lvars it;
    if items @startsWith "(" then
        items.back.parseAlts -> ( it, items );
        it, items.back
    elseif items @startsWith "[" then
        items.back.parseAlts -> ( it, items );
        [% "OPT", it %], items.back
    else
        items.dest
    endif
enddefine;

define parseAlt( items );
    lconstant toks = conslist(#| "|", "]", ")" |#);
    [%"SEQ",
        repeat
            quitif( items.null or ( items @startsWith toks ) );
            lvars it;
            items.parseItem -> ( it, items );
            if ( items @startsWith "*" ) or ( items @startsWith "**" )
            or ( items @startsWith "+" ) or ( items @startsWith "++" )
            then [% "STAR", items.hd, it %], items.tl -> items
            else it
            endif
        endrepeat
    %], items
enddefine;

define parseAlts( items );
    [%"ALT",
        repeat
            lvars alt;
            items.parseAlt -> ( alt, items );
            alt;
            quitunless( items @startsWith "|" );
            items.tl -> items
        endrepeat
    %], items
enddefine;

vars procedure ( showSeq, showAlts );

define evalVisibleBrackets( x );
    "(", x @showSeq ('', true), ")"
enddefine;

define evalVisibleBoxes( x );
    '[', x @showSeq ('', true), ']'
enddefine;

define showItem( item, nested );
    if item.isMeaning then
        item @evalItem
    else
        lvars key = item.front;
        if key == "SEQ" then
            "(", item.back @showSeq ('', true), ")"
        elseif key == "ALT" then
            "(", showAlts( '', item, '', true), ")"
        elseif key == "STAR" then
            item.back.back.front @showItem true,
            item.back.front @showItem true @literal
        elseif key == "OPT" then
            '[', item.back.front @showItem true, ']'
        else
            mishap( item, 1, 'oh dear' )
        endif
    endif
enddefine;

define blobLength( x );

    define lconstant blobSum( n, x );
        n + x.blobLength + 1
    enddefine;

    if x.islist then
        ( 0, x ) @applist blobSum
    elseif x.isMeaning then
        x.lengthMeaning
    elseif x.isword then
        x.datalength
    else
        mishap( 'Blob length not defined for this', [ ^x % x.dataword %] )
    endif
enddefine;


define showSeq( seq, prefix, nested );
    lvars gap = '';
    lvars k = seq.blobLength;
    ;;; ["blobLength", k].reportln;
    if k < 72 or nested then
        lvars item;
        for item in_list seq do
            prefix, gap, ' ' -> gap, item @showItem true
        endfor
    else
        '\\begin{tabular}{l}\n' @literal,
        lvars item;
        for item in_list seq do
            prefix, gap, ' ' -> gap, item @showItem nested, ' \\\\ \n' @literal
        endfor,
        '\\end{tabular}\n' @literal
    endif
enddefine;

define showAlts( prefix, alts, suffix, nested );
    lvars sep = '';
    if nested then
        lvars alt;
        for alt in_list alts.back do
            prefix, sep, alt.back @showSeq ('', true), suffix,
            ' !| ' -> sep
        endfor
    else
        lvars alt;
        for alt in_list alts.back do
            prefix, sep, alt.back @showSeq ('', nested), suffix,
            ' !| ' -> sep
        endfor
    endif
enddefine;

vars procedure ( report );

define reportItems( x );
    ' '.report;
    if x.islist then
        '['.report, x @applist reportItems, ']'.report
    else
        if x.isMeaning then x.meaningArg @reportItems else x.report endif
    endif
enddefine;

define formRhs( items );
    check items.isListOfMeaning;

    define lconstant addItemLength( n, x );
        n + x.lengthMeaning
    enddefine;

    lvars maxWidth = 72;
    lvars n = applist( 0, items, addItemLength );

    ;;; [`pepperLength =`, n].reportln;
    ;;; "-- item sequence -------------------------------------------".reportln;
    ;;; items.reportItems, [].reportln;

    lvars alts;
    items.parseAlts -> (alts, items);

    ;;; "-- parsed alternatives ------------------------------------".reportln;
    ;;; alts.reportItems, [].reportln;
    ;;; [`addItemLength=`, n].reportln;

    showAlts (
        '\\hspace*{3mm}{\\tt ' @literal,
        alts,
        '} \\\\ \n' @literal,
        false
    )
enddefine;

define evalSyntax( x );
    lvars count = syntaxCount + 1 ->> syntaxCount;
    lvars thisDef = (
        [%
            '\\begin{tabular}{l}\n' @literal,
            '{\\bf ' @literal,
                "def", consstring(#| count @printOn identfn, `.` |#), ' ',
                x.front.evalItem, ' ::= ',
            '}' @literal,
            '\\\\ \n' @literal,
            x.back.formRhs,
            '\\end{tabular}\n\n' @literal
        %]
    );
    thisDef @conspair syntaxDefs -> syntaxDefs;
    thisDef.dl
enddefine;

define evalRow( L );
    L @maplist evalItem
enddefine;

define evalTable( L );
    '\\begin{tabular}' @literal,
    '{|' @literal, repeat L.hd.lengthMeaning times 'l' endrepeat, '|}' @literal, '\n',
    lvars row;
    for row in L @maplist evalItem do
        lvars sep = '';
        lvars item;
        for item in_list row do
            sep, item, ' &' @literal -> sep
        endfor,
        '\\\\ \n' @literal
    endfor,
    '\\end{tabular}\n' @literal
enddefine;

define evalItemPara( x );
    '\n\n', x.evalItem
enddefine;

define evalItemParaList( xL );
    ;;; when should paragraphs breaks be inserted?
    ;;; -- between successive strings, I think. So ...
    lvars pending = [];
    until xL.null do
        lvars this;
        xL.dest -> ( this, xL );
        if this.meaningStrength == "strong" then
            '\n\n', pending.rev @applist evalItem, this.evalItem, '';
            [] -> pending
        else
            this @conspair pending -> pending
        endif
    enduntil;
    unless pending.null do
        '\n\n', pending.rev @applist evalItem, ''
    endunless;
enddefine;



;;; -- texOutput ----------------------------------------------

vars procedure theTexOutput;

defclass TexOutput {
    really,
    inSuper,
    inSub,
    inBold,
    inCode,
    inItalics,
    inMaths
};

define newTexOutput();
    consTexOutput(
        false,
        false,
        false,
        false,
        false,
        false,
        false
    )
enddefine;

;;; vars inSuper = false;
;;; vars inSub = false;
;;; vars inBold = false;
;;; vars inCode = false;
;;; vars inItalics = false;
;;; vars inMaths = false;
;;;
;;; vars really = false;

;;; convert characters for output, keeping track of various settings


define texLiteral( ch, this );
    if ch == `_` then       `\\`.outputSink, ch.outputSink
    elseif ch == `{` then   `\\`.outputSink, ch.outputSink
    elseif ch == `}` then   `\\`.outputSink, ch.outputSink
    elseif ch == `#` then   `\\`.outputSink, ch.outputSink
    elseif ch == `%` then   `\\`.outputSink, ch.outputSink
    elseif ch == `$` then   `\\`.outputSink, ch.outputSink
    elseif ch == `&` then   `\\`.outputSink, ch.outputSink
    elseif ch == `[` then   '{[}'.print
    elseif ch == `]` then   '{]}'.print
    elseif ch == `^` then
        unless this.inMaths do `$`.outputSink endunless;
        '^\\wedge'.print;
        unless this.inMaths do `$`.outputSink endunless;
    elseif ch == `\\` then
        unless this.inMaths do `$`.outputSink endunless;
        '\\setminus'.print;
        unless this.inMaths do `$`.outputSink endunless;
    elseif ch == `<` then
        unless this.inMaths do `$`.outputSink endunless;
        '<'.print;
        unless this.inMaths do `$`.outputSink endunless;
    elseif ch == `>` then
        unless this.inMaths do `$`.outputSink endunless;
        '>'.print;
        unless this.inMaths do `$`.outputSink endunless;
    elseif ch == `|` then
        unless this.inMaths do `$`.outputSink endunless;
        '\\mid'.print;
        unless this.inMaths do `$`.outputSink endunless;
    else
        ch.outputSink
    endif
enddefine;

define texOutput( ch, this );
    if this.really then
        texLiteral( ch, this );
        false -> this.really
    else
        if ch == `!` then
            true -> this.really
        elseif ch == `_` then
            if this.inBold then '}'.print; false -> this.inBold
            else '{\\bf '.print; true -> this.inBold
            endif
        elseif ch == `*` then
            if this.inItalics then '}'.print; false -> this.inItalics
            else '{\\em '.print; true -> this.inItalics
            endif
        elseif ch == `~` then
            if this.inSub then '$'.print; false -> this.inSub
            else '$_ '.print; true -> this.inSub
            endif
        elseif ch == `^` then
            if this.inSuper then '$'.print; false -> this.inSuper
            else '$^ '.print; true -> this.inSuper
            endif
        elseif ch == `|` then
            if this.inCode then '}'.print; false -> this.inCode
            else '{\\tt '.print; true -> this.inCode
            endif
        else
            texLiteral( ch, this );
        endif
    endif
enddefine;

define printItem( item );
    if item.islist then item @applist printItem
    elseif item.isprocedure then [% item() %] @applist printItem
    else item @printOn theTexOutput
    endif
enddefine;

define literal( x );
    print(% x %)
enddefine;


;;; -- latexTable: maps from Actions to Procedures ------------

define latexTable =
    newproperty(
        [
            [ String ^evalString ]
            [ Word ^evalWord ]
            [ LinkTo ^evalLinkTo ]
            [ Label ^evalLabel ]
            [ Ref ^evalRef ]
            [ Part ^evalPart ]
            [ Indented ^evalIndented ]
            [ DocTitle ^evalDocTitle ]
            [ Chapter ^evalChapter ]
            [ Appendix ^evalAppendix ]
            [ Section ^evalSection ]
            [ Passage ^evalPassage ]
            [ Fragment ^evalFragment ]
            [ List ^evalList ]
            [ Syntax ^evalSyntax ]
            [ Issue ^evalIssue ]
            [ Row ^evalRow ]
            [ Spice ^evalSpice ]
            [ Table ^evalTable ]
            [ AllSyntax ^evalAllSyntax ]
            [ AllIssues ^evalAllIssues ]
            [ N ^evalN ]
            [ T ^evalT ]
            [ Contents ^evalContents ]
        ].dup.length,
        false,
        "perm"
    )
enddefine;

;;; -----------------------------------------------------------

define evalItem( item );
    lvars p = item.meaningAction.latexTable;
    if p.isprocedure then
        p( item.meaningArg )
    else
        mishap( 'No LATEX meaning', [ ^item ^p ] )
    endif
enddefine;


;;; -- renderToLatex: the exported function -------------------


define renderToLatex( L );
    dlocal syntaxDefs = [];
    dlocal syntaxCount = 0;
    dlocal theTexOutput = texOutput(% newTexOutput() %);
    [%
        '\\documentclass{report}\n' @literal,
        '\\setlength{\\parindent}{0in}\n' @literal,
        '\\setlength{\\parskip}{2mm}\n' @literal,
        delayedDocTitle,
        '\\author{Chris Dollin}\n' @literal,
        '\\begin{document}\n' @literal,
        '\\maketitle\n' @literal,
        '\\tableofcontents\n' @literal,
        applist( L, evalItemPara ),
        '\\end{document}\n' @literal
    %] @applist printItem
enddefine;

;;; -----------------------------------------------------------

endsection;
