;;; -- @ syntax -----------------------------------------------


;;; EXCERPT FROM REF * POPCOMPILE ....

/*
        The prec argument is a  value specifying the limit for  operator
        precedences in this  expression; for efficiency  reasons, it  is
        supplied not in the normal identprops format, but in the form in
        which precedences are actually represented internally. If idprec
        is a normal identprops  precedence, then the corresponding  prec
        value is the positive integer given by

                prec = intof(abs(idprec) * 20)
                            + (if idprec > 0 then 1 else 0 endif)

        (E.g. an idprec of 4  will give a prec  of 81, whereas -4  would
        give 80.) Since an identprops precedence can range between -12.7
        and 12.7,  the normal  range for  prec  is 2  - 255;  any  value
        greater than 255 is  guaranteed to include  all operators in  an
        expression.
*/

;;; 10 needs pop11_comp_prec_expr( 201, false )
;;; 8.5 needs pop11_comp_prec_expr( 171, false )

define syntax 8.5 @;
    pop_expr_inst( pop_expr_item );
    pop11_FLUSHED -> pop_expr_inst;
    lvars operator = readitem();
    if operator == termin then
        mishap( 'Unexpected end of input after "@" operator', [] )
    elseif operator == "(" then
        dlocal pop_new_lvar_list;
        lvars x = sysNEW_LVAR();
        pop11_comp_expr_to( ")" ) -> _;
        sysPOP( x );
        pop11_comp_prec_expr( 171, false ).erase;
        sysCALL( x );
    else
        pop11_comp_prec_expr( 171, false ).erase;
        sysCALL( operator )
    endif
enddefine;

;;; -- absent -------------------------------------------------

defclass lconstant Absent {};
constant absent = consAbsent();

;;; ;;; -- Couple -------------------------------------------------
;;;
;;; defclass Couple {
;;;     left,
;;;     right
;;; };


;;; -- ModeState ----------------------------------------------


defclass ModeState {
    modeStateQuasiQuoting,
    modeStateWidth
};

define newModeState();
    consModeState( 0, absent )
enddefine;

define isQuasiQuoting( m );
    m.modeStateQuasiQuoting == 0
enddefine;

define enterQuasiQuoting( m );
    m.modeStateQuasiQuoting + 1 -> m.modeStateQuasiQuoting
enddefine;

;;; -- pepperLength -------------------------------------------

define class_pepperLength =
    newanyproperty(
        [
            [ ^string_key ^datalength ]
            [ ^pair_key ^length ]
            [ ^nil_key ^length ]
            [ ^word_key ^length ]
        ], 8, 1, false,
        false, false, "perm",
        procedure( x );
            mishap( x, 1, 'Trying to call pepperLength on this' )
        endprocedure,
        false
    )
enddefine;

define pepperLength( x );
    class_pepperLength( x.datakey )( x )
enddefine;


;;; -- Meanings -----------------------------------------------

define oops( x );
    mishap( x, 1, 'oops' )
enddefine;

defclass Meaning {
    meanTitle,
    meanStrength,
    meanStyle,
    meanArg,
    meanRank,
    meanAction
};

define sigmaLength( n, x );
    x.pepperLength + n
enddefine;

define lengthMeaning( m );
    lvars A = m.meanArg;
    lvars L = A.pepperLength;
    ( L, A ) @applist sigmaLength
enddefine;

lengthMeaning -> class_pepperLength( Meaning_key );

define makeWrapper( t, operands );
    consMeaning( t.meanTitle, "strong", "made", operands, 0, t.meanAction )
enddefine;

define evalString( w );
    w @applist identfn
enddefine;

define formString( s, endsWithNewline );
    lvars title = if endsWithNewline then "paraString" else "inString" endif;
    consMeaning( title, "weak", "x", [^s], 0, evalString )
enddefine;

define formTermin();
    consMeaning( termin, "weak", "endF", absent, 0, oops(% termin %) )
enddefine;


;;; -- Tokenization -------------------------------------------

constant CHAR_plain = 0;
constant CHAR_digit = 1;
constant CHAR_letter = 2;
constant CHAR_simple = 3;
constant CHAR_sign = 4;
constant CHAR_termin = 5;
constant CHAR_slash = 6;
constant CHAR_layout = 7;
constant CHAR_dollar = 8;

define setType( charType, chars, table );
    lvars i;
    for i from 1 to chars.datalength do
        charType -> subscrs( subscrs( i, chars ), table )
    endfor
enddefine;

constant answer = consstring(#| repeat 256 times CHAR_plain endrepeat |#);

vars charTable = (
    lblock
        setType( CHAR_digit, '0123456789', answer );
        setType( CHAR_simple, '(){}[];', answer );
        setType( CHAR_layout, '\n\t\s', answer );
        setType( CHAR_slash, '\\', answer );
        setType( CHAR_dollar, '$', answer );
        setType( CHAR_sign, '!@#~%^&*+-=|:<>?/', answer );
        setType( CHAR_letter, 'abcdefghijklmnopqrstuvwxyz', answer );
        setType( CHAR_letter, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', answer );
        answer
    endlblock
);


define peekCh( procedure r );
    r() ->> r()
enddefine;

define eatString( procedure r, ch );
    consstring(#|
        ch;
        repeat
            lvars newCh = r();
            lvars nextCh = newCh == termin and termin or r.peekCh;
            quitif(
                newCh == termin or
                ( newCh == `\\` and nextCh /== `\\` ) or
                ( newCh == `\n` and nextCh == `\n` )
            );
            if newCh == `\\` and nextCh == `\\` then `\\`, r() @erase
            else newCh
            endif;
        endrepeat;
        newCh -> r();
    |#) @formString (newCh == '\n')
enddefine;

define cantExtend( ch, chType );
    lvars newType = subscrs( ch, charTable );
    not(
        newType == chType or
        ( chType == CHAR_letter and newType == CHAR_digit )
    )
enddefine;

define nextToken( procedure r, mode, lookupWord );
    repeat
        lvars ch = r();
        quitunless( ch == ` ` or ch == `\n` or ch == `\t` );
    endrepeat;
    if ch == termin then
        formTermin()
    elseif ch == `\\` then
        lvars nextCh = r();
        if `a` <= nextCh and nextCh <= `z` then
            consword(#|
                nextCh;
                repeat
                    lvars newCh = r();
                    quitunless( `a` <= newCh and newCh <= `z` );
                    newCh
                endrepeat
            |#) @lookupWord, newCh -> r()
        elseif nextCh == `\\` then
            r @eatString nextCh
        else
            consword(#| nextCh |#) @lookupWord
        endif;
    elseif mode.isQuasiQuoting then
        r @eatString ch
    elseif ch == `\"` then
        consstring(#|
            ch,
            repeat
                lvars newCh = r();
                quitif( newCh == termin or newCh == ch or newCh == `\n` );
                newCh
            endrepeat,
            ch
        |#) @formString false
    else
        lvars chType = subscrs( ch, charTable );
        if chType == CHAR_simple then
            consword(#| ch |#)
        else
            consword(#|
                ch;
                repeat
                    lvars newCh = r();
                    quitif( newCh == termin or ( newCh @cantExtend chType ) );
                    newCh
                endrepeat
            |#), newCh -> r()
        endif @lookupWord
    endif
enddefine;



;;; -- Parser -------------------------------------------------

constant widestWidth = 200;

vars procedure ( lookupWord );

define makeNiladic( F );
    ( F.meanTitle, "daft", "opApplied", [], 0, F.meanAction ) @consMeaning
enddefine;

define makeMonadic( L, F );
    ( F.meanTitle, "daft", "opApplied", [L], 0, F.meanAction ) @consMeaning
enddefine;

define makeMonadicWrapped( Ls, F );
    ( F.meanTitle, "daft", "opApplied", Ls, 0, F.meanAction ) @consMeaning
enddefine;

define makeDyadic( L, R, F );
    ( F.meanTitle, "daft", "opApplied", [L, R], 0, F.meanAction ) @consMeaning
enddefine;

define getToken( r, mode );
    r @nextToken (mode, lookupWord)
enddefine;

define advance( r, mode );
    r @getToken mode, r
enddefine;

vars unwrappers = [];

vars procedure ( parseStuff, parseRepeatedly );

define parseOperand( it, r, mode, width ) -> ( answer, token );
    lvars s = it.meanStyle;
    lvars rank = it.meanRank;
;;;    [`parse operand starting`, s].reportln;
    if s == "Fx" and rank <= width then
        lvars ( R, newNext ) = r @advance mode @parseStuff (mode, rank - 1);
        R @makeMonadic it, newNext
    elseif s == "FxendF" then
        dlocal unwrappers = [^(it.meanArg) ^^unwrappers];
        lvars oldLevel = mode.modeStateQuasiQuoting;
        lvars ( X, closer ) = r @parseRepeatedly (mode, widestWidth);
        X @makeMonadicWrapped it;
        oldLevel -> mode.modeStateQuasiQuoting;
        if closer.meanTitle = it.meanArg then
            ;;; good; advance to the next token ...
            r @getToken mode
        else
            ;;; ah. we have a random closer.
            if closer.meanTitle @member unwrappers then
                ;;; someone missed out *our* closer! Complain & deliver it.
                warning( 'missing closer', [% it.meanArg, "got", closer %] );
                closer
            else
                ;;; this one is lonely. Discard it.
                warning( 'unexpected closer', [% closer, 'nested in', unwrappers %] );
                r @getToken mode
            endif
        endif
    elseif s == "x" then
        it, r @getToken mode
    elseif s == "F" then
        it @makeNiladic, r @getToken mode
    elseif s == "$" then
        mode.enterQuasiQuoting;
        r @advance mode @parseOperand (mode, width)
    else
        mishap( 'what sort of starter is this?', [^it] )
    endif -> ( answer, token )
enddefine;

define parseStuff( this, r, mode, width );
    lvars ( L, next ) = (this, r) @parseOperand (mode, width);
    ;;; [`parse stuff has`, L, `with next`, next.meanStyle,`=`, next].reportln;
    repeat
        lvars s = next.meanStyle;
        lvars rank = next.meanRank;
        quitunless( s == "xF" or s == "xFx" ) and ( rank <= width );
        if s == "xF" then
            ;;; [`-- that is postfix`].reportln;
            L @makeMonadic next -> L, r @getToken mode -> next
        else
            ;;; [`-- that is infix`].reportln;
            lvars ( R, newNext ) = r @advance mode @parseStuff (mode, rank - 1);
            (L, R) @makeDyadic next -> L, newNext -> next
        endif
    endrepeat;
    ;;; [`parse stuff returns`, L, `with next`, next].reportln;
    L, next
enddefine;


define parseRepeatedly( r, mode, width );
    lvars this = r @getToken mode;
    [%until this.meanStyle == "endF" do
        (this, r) @parseStuff (mode, width) -> this
    enduntil%],
    ;;; [`parse repeatedly ends with`, this].reportln;
    this
enddefine;


;;; -- Main ---------------------------------------------------

vars procedure ( evalWrap, evalNoParaWrap, evalOp, evalItem, literal );

define defWrapper( name, endName, action );
    [%name,      consMeaning( name, "strong", "FxendF", endName, 0, action )%],
    [%endName,   consMeaning( endName, "strong", "endF", name, 0, oops )%]
enddefine;

define defWeakWrapper( name, endName, action );
    [%name,      consMeaning( name, "weak", "FxendF", endName, 0, action )%],
    [%endName,   consMeaning( endName, "weak", "endF", name, 0, oops )%]
enddefine;

define defSimple( name, action );
    [%name,      consMeaning( name, "strong", "F", absent, 0, action )%]
enddefine;

define defSimpleWrapper( name, wrapper );
    lvars endName = consword(#| 'end'.explode, name.explode |#);
    defWrapper( name, endName, evalWrap(% wrapper %) )
enddefine;

define defSimpleNoParaWrapper( name, wrapper );
    lvars  endName = consword(#| 'end'.explode, name.explode |#);
    defWeakWrapper( name, endName, evalNoParaWrap(% wrapper %) )
enddefine;

define defOperator( name, rank, proc );
    [%name,  consMeaning( name, "strong", "plain", [], rank, evalOp(% name, proc %) )%]
enddefine;

define evalOp( x, name, proc );
    lvars ( L, R ) = x.dest.hd;
    `(`, L.evalItem, name, R.evalItem, `)`
enddefine;

define defInfix( name, level, action );
    [% name, consMeaning( name, "weak", "xFx", [], level, action ) %]
enddefine;

define defPrefix( name, action );
    [%name, consMeaning( name, "weak", "Fx", [], 20, action )%]
enddefine;

define evalLinkto( x );
    lvars ( L, R ) = x.dest.hd;
    L.evalItem, ' (', R.evalItem, ')'
enddefine;

define evalLabel( x );
    consstring(#|
        '\\label{'.explode,
        x.front.meanArg.front.explode,
        '}'.explode
    |#) @literal
enddefine;

define evalRef( x );
    lvars ( L, R ) = x.dest.hd;
    consstring(#|
        '\\ref={'.explode,
        L.meanArg.front.explode,
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

defclass Context {
    conNumbering,
    conProperties
};

vars theContext = (
    consContext(
        {0, 0, 0, 0, 0, 0},
        newproperty( [], 100, absent, "perm" )
    )
);

define isNumbering( stuff );
    0 < stuff.pepperLength and
    lblock
        lvars ch = subscrs( 1, stuff );
        `0` <= ch and ch <= `9`
    endlblock
enddefine;

;;; Not too sure what leftpart & rightpart are meant to do - but it
;;; looks like a string slicing operation.
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

define splitTitle( stuff );
    lvars x = stuff.meanArg.front;
    if x.isNumbering then
        lvars i = 1;
        while i <= x.pepperLength do
            lvars ch = subscrs( i, x );
            quitunless( ch == `.` or ch.isnumbercode );
            i + 1 -> i
        endwhile;
        ( x @leftpart i-1, x @rightpart i -> stuff.meanArg.front, stuff )
    else
        ('', stuff)
    endif
enddefine;

define printOn( x, consumer );
    dlvars procedure consumer;
    dlvars procedure previous = cucharout;

    define dlocal cucharout( ch );
        dlocal cucharout = previous;
        consumer( ch )
    enddefine;

    pr( x )
enddefine;

define nextNumber( depth, leading );
    lvars v = theContext.conNumbering;
    if leading.pepperLength > 0 then
        leading
    else
        lvars i;
        for i from depth + 1 to v.pepperLength do
            0 -> subscrs( i, v )
        endfor;
        subscrs( depth, v ) + 1 -> subscrs( depth, v );
        consstring(#|
            lvars gap = '';
            for i from 1 to depth do
                gap @printOn identfn, '.' -> gap, subscrs( i, v) @printOn identfn
            endfor
        |#)
    endif
enddefine;

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

vars savedTitle = false;

define evalTitle( x );
    x @maplist evalItem -> savedTitle;
    ;;; "<h1>", savedTitle.dl, "</h1>"
enddefine;

define delayedTitle();
    if savedTitle then
        '\\title{' @literal,
        savedTitle.dl;
        '}\n' @literal;
    endif
enddefine;

;;; vars headerStrings = (
;;;     {%
;;;         consCouple( '\\chapter{', '}\n' ),
;;;         consCouple( '\\section{', '}\n' ),
;;;         consCouple( '\\subsection{', '}\n' ),
;;;         consCouple( '\\subsubsection{', '}\n' ),
;;;         consCouple( '\\paragraph{', '}\n' ),
;;;         consCouple( '\\subparagraph', '}\n' ),
;;;     %}
;;; );

define doHeaded( x, level, command );
    lvars loc = "here".gensym;
    lvars ( numeric, title ) = x.front.splitTitle;
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

define argLength( x );
    if x == absent or x == [] then 0 else x.front.pepperLength endif
enddefine;

define addItemLength( n, x );
    n + x.pepperLength
enddefine;

define xxmeanArg( x );
    lvars a = x.meanArg;
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

vars procedure ( blobSum );

define blobLength( x );
    if x.islist then (0, x) @applist blobSum
    else x.pepperLength
    endif
enddefine;

define blobSum( n, x );
    n + x.blobLength + 1
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
        '\n\n\\begin{tabular}{l}\n' @literal,
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
        if x.isMeaning then x.meanArg @reportItems else x.report endif
    endif
enddefine;

define formRhs( items );
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
            '\n\n\\begin{tabular}{l}\n' @literal,
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

define evalAlt( x );
    '\n\nZZZ' @literal
enddefine;

define evalRow( L );
    L @maplist evalItem
enddefine;

define evalTable( L );
    '\n\n\\begin{tabular}' @literal,
    '{|' @literal, repeat L.hd.pepperLength times 'l' endrepeat, '|}' @literal, '\n',
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
        if this.meanAction == evalString then
            if this.meanTitle == "paraString" then
                '\n\n', pending.rev @applist evalItem, this.evalItem, '';
                [] -> pending
            else
                this @conspair pending -> pending
            endif
        else
            if this.meanStrength == "strong" then
                '\n\n', pending.rev @applist evalItem, this.evalItem, '';
                [] -> pending
            else
                this @conspair pending -> pending
            endif
        endif
    enduntil;
    unless pending.null do
        '\n\n', pending.rev @applist evalItem, ''
    endunless;
enddefine;

define evalItem( item );
    (item.meanAction)( item.meanArg )
enddefine;

vars inSuper = false;
vars inSub = false;
vars inBold = false;
vars inCode = false;
vars inItalics = false;
vars inMaths = false;

vars really = false;

;;; convert characters for output, keeping track of various settings

define print =
    pr
enddefine;

define literal( x );
    print(% x %)
enddefine;

define texLiteral( ch );
    if ch == `_` then       `\\`.cucharout, ch.cucharout
    elseif ch == `{` then   `\\`.cucharout, ch.cucharout
    elseif ch == `}` then   `\\`.cucharout, ch.cucharout
    elseif ch == `#` then   `\\`.cucharout, ch.cucharout
    elseif ch == `%` then   `\\`.cucharout, ch.cucharout
    elseif ch == `$` then   `\\`.cucharout, ch.cucharout
    elseif ch == `&` then   `\\`.cucharout, ch.cucharout
    elseif ch == `[` then   '{[}'.print
    elseif ch == `]` then   '{]}'.print
    elseif ch == `^` then
        unless inMaths do `$`.cucharout endunless;
        '^\\wedge'.print;
        unless inMaths do `$`.cucharout endunless;
    elseif ch == `\\` then
        unless inMaths do `$`.cucharout endunless;
        '\\setminus'.print;
        unless inMaths do `$`.cucharout endunless;
    elseif ch == `<` then
        unless inMaths do `$`.cucharout endunless;
        '<'.print;
        unless inMaths do `$`.cucharout endunless;
    elseif ch == `>` then
        unless inMaths do `$`.cucharout endunless;
        '>'.print;
        unless inMaths do `$`.cucharout endunless;
    elseif ch == `|` then
        unless inMaths do `$`.cucharout endunless;
        '\\mid'.print;
        unless inMaths do `$`.cucharout endunless;
    else
        ch.cucharout
    endif
enddefine;

define texOutput( ch );
    if really then
        ch.texLiteral;
        false -> really
    else
        if ch == `!` then
            true -> really
        elseif ch == `_` then
            if inBold then '}'.print; false -> inBold
            else '{\\bf '.print; true -> inBold
            endif
        elseif ch == `*` then
            if inItalics then '}'.print; false -> inItalics
            else '{\\em '.print; true -> inItalics
            endif
        elseif ch == `~` then
            if inSub then '$'.print; false -> inSub
            else '$_ '.print; true -> inSub
            endif
        elseif ch == `^` then
            if inSuper then '$'.print; false -> inSuper
            else '$^ '.print; true -> inSuper
            endif
        elseif ch == `|` then
            if inCode then '}'.print; false -> inCode
            else '{\\tt '.print; true -> inCode
            endif
        else
            ch.texLiteral
        endif
    endif
enddefine;

define printItem( item );
    if item.islist then item @applist printItem
    elseif item.isprocedure then [% item() %] @applist printItem
    else item @printOn texOutput
    endif
enddefine;

vars procedure ( sysLookupWord );

define tokenise( r, width );
    lvars mode = newModeState();
    [%
        '\\documentclass{report}\n' @literal,
        '\\setlength{\\parindent}{0in}\n' @literal,
        '\\setlength{\\parskip}{2mm}\n' @literal,
        delayedTitle,
        '\\author{Chris Dollin}\n' @literal,
        '\\begin{document}\n' @literal,
        '\\maketitle\n' @literal,
        '\\tableofcontents\n' @literal,
        r @parseRepeatedly (mode, width) @erase @applist evalItemPara,
        '\\end{document}\n' @literal
    %] @applist printItem
enddefine;


define wordTable =
    newanyproperty(
        [%
            defInfix( "linkto", 20, evalLinkto );
            defPrefix( "label", evalLabel );
            defInfix( "ref", 20, evalRef );
    ;;;        defWeakWrapper( "\(", "\)", evalVisibleBrackets );
    ;;;        defWeakWrapper( "\[%", "\%]", evalVisibleBoxes );
    ;;;
            defSimpleNoParaWrapper( "asis", "pre" );
            defWrapper( "part", "endpart", evalPart ),
            defWrapper( "indented", "endindented", evalIndented ),
            defWrapper( "title", "endtitle", evalTitle ),
            defWrapper( "chapter", "endchapter", evalChapter ),
            defWrapper( "appendix", "endappendix", evalAppendix ),
            defWrapper( "section", "endsection", evalSection ),
            defWrapper( "passage", "endpassage", evalPassage ),
            defWrapper( "fragment", "endfragment", evalFragment ),
            defWrapper( "list", "endlist", evalList ),
            defWrapper( "syntax", "endsyntax", evalSyntax ),
            defWrapper( "issue", "endissue", evalIssue ),
            defWrapper( "row", "endrow", evalRow ),
            defWrapper( "spice", "endspice", evalSpice ),
            defWrapper( "table", "endtable", evalTable ),
            defSimple( "allsyntax", evalAllSyntax ),
            defSimple( "allissues", evalAllIssues ),
            defSimple( "n", evalN ),
            defSimple( "t", evalT ),
            defSimple( "contents", evalContents ),
            [%"$",       consMeaning( "$", "daft", "$", absent, 0, oops )%]
        %].dup.length, 1, false,
        false, false, "perm",
        absent, false
    )
enddefine;

define evalWord( w );
    w.dl
enddefine;

define asNormal( w );
    consMeaning( w, "weak", "x", [^w], 0, evalWord )
enddefine;

define lookupWord( w );
    lvars m = w.wordTable;
    if m == absent then w.asNormal ->> w.wordTable else m endif
    ;;; -> val it; [`look up`, w, `gets`, it].reportln; it
enddefine;

define charsFromFile( fname );
    fname.discin.newpushable
enddefine;

define handleFile( arg );
    lvars r = arg.charsFromFile;
    r @tokenise widestWidth
enddefine;

define handleSet( arg );
    ;;; do nothing, today.
enddefine;

define main( n );
    lvars args = n.conslist;
    lvars action = handleFile;
    lvars arg;
    for arg in args do
        ;;; ['-- doing', arg].reportln;
        if arg = '-file' then handleFile -> action
        elseif arg = '-set' then handleSet -> action
        else arg @action
        endif
    endfor
enddefine;



;;; -----------------------------------------------------------
