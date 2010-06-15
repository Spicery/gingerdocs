;;; -- Syntactic Properties -----------------------------------
;;;
;;; The SynProps record defines the syntactic properties
;;; associated with tokens.
;;;     strength            block-level flag    "strong", "weak", undef
;;;     child strength      permitted children  general predicate
;;;     style               fixity              "x", "F", "Fx", "xF", "xFx", "FxendF" or "endF"
;;;     opening bracket }   pair of words that act as brackets for outfix syntax
;;;     closing bracket }
;;;     rank                precedence level
;;;     action              element name
;;;

defclass SynProps {
    synPropsStyle,
    synPropsOpeningBracketAux,
    synPropsClosingBracketAux,
    synPropsRank,
    synPropsKernel
};

define newAnySynProps( style, opener, closer, rank, kernel );
    lvars is_brackets = ( style == "FxendF" or style == "endF" );
    if opener then
        unless is_brackets then
            mishap( 'Invalid opener', [ ^opener ] )
        endunless
    endif;
    if closer then
        unless is_brackets then
            mishap( 'Invalid closer', [ ^closer ] )
        endunless
    endif;
    unless rank.isinteger do
        mishap( 'Invalid rank', [ ^rank ] )
    endunless;
    unless lmember( style, [ F x Fx xFx $ FxendF endF ] ) do
        mishap( 'Invalid style', [ ^style ] )
    endunless;
    unless kernel.isKernel do
        mishap( 'Invalid kernel', [ ^kernel ] )
    endunless;
    consSynProps( style, opener, closer, rank, kernel )
enddefine;

define newOpSynProps( style, rank, kernel );
    newAnySynProps( style, false, false, rank, kernel )
enddefine;

define newSingleSynProps( style, kernel );
    newAnySynProps( style, false, false, 0, kernel )
enddefine;

define newPairedSynProps( opener, closer, kernel );
    newAnySynProps( "FxendF", opener, closer, 0, kernel );
    newAnySynProps( "endF", opener, closer, 0, ClosingKeyword );
enddefine;

define synPropsClosingBracket( s );
    lvars b = s.synPropsClosingBracketAux;
    unless b.isword do
        mishap( 'Trying to use undefined closer', [% s %] )
    endunless;
    b
enddefine;

define synPropsOpeningBracket( s );
    lvars b = s.synPropsOpeningBracketAux;
    unless b.isword do
        mishap( 'Trying to use undefined closer', [ ^s ] )
    endunless;
    b
enddefine;


;;; -- Token --------------------------------------------------
;;;
;;; The output of the tokenizer is a Token which is effectively
;;; a pair ( item x syntactic-properties ).  The item is a word,
;;; a string, or termin.
;;;

defclass Token {
    tokenValue,
    tokenSynProps
};

define tokenKernel =
    tokenSynProps <> synPropsKernel
enddefine;

define newToken( item, synprops );
    unless item.isword or item.isstring or item == termin do
        mishap( 'Invalid item for Token', [ ^item ] )
    endunless;
    unless synprops.isSynProps do
        mishap( 'Invalid SynProps for Token', [ ^synprops ] )
    endunless;
    consToken( item, synprops )
enddefine;

define formString( s, endsWithNewline );
    lconstant StrongStringProps = newSingleSynProps( "x", ParaString );
    lconstant WeakStringProps = newSingleSynProps( "x", String );
    newToken(
        s,
        if endsWithNewline then
            StrongStringProps
        else
            WeakStringProps
        endif
    )
enddefine;

define formTermin();
    newToken(
        termin,
        newSingleSynProps( "endF", ClosingKeyword )
    )
enddefine;

define formWord( w );
    newToken(
        w,
        newSingleSynProps( "x", Word )
    )
enddefine;

;;; -- Tokenization -------------------------------------------

;;;
;;; Mode is a positive integer that counts how deeply
;;; nested we are in a quasi-quoted content.  I use the phrase
;;; quasi-quoted with some trepidation, I doubt it is correct!
;;;


defclass Tokenizer {
    tokenizerSource,
    tokenizerMode       : pint,
    tokenizerDump
};

define newTokenizer( procedure r );
    consTokenizer(
        r,              ;;; The character repeater.
        0,              ;;; In the normal context.
        []              ;;; The nested modes.
    )
enddefine;

define saveTokenizerMode( t );
    conspair( t.tokenizerMode, t.tokenizerDump ) -> t.tokenizerDump
enddefine;

define restoreTokenizerMode( t );
     t.tokenizerDump.dest ->  t.tokenizerDump -> t.tokenizerMode;
enddefine;

define enterQuasiQuotingMode( t );
    t.tokenizerMode + 1 -> t.tokenizerMode;
enddefine;


constant CHAR_plain = 0;
constant CHAR_digit = 1;
constant CHAR_letter = 2;
constant CHAR_simple = 3;
constant CHAR_sign = 4;
constant CHAR_termin = 5;
constant CHAR_slash = 6;
constant CHAR_layout = 7;
constant CHAR_dollar = 8;

lconstant answer = consstring(#| repeat 256 times CHAR_plain endrepeat |#);

constant charTable = (
    lblock

        define lconstant setType( charType, chars, table );
            lvars i;
            for i from 1 to chars.datalength do
                charType -> subscrs( subscrs( i, chars ), table )
            endfor
        enddefine;

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

vars procedure ( lookupWord );

define nextToken( procedure r, mode );

    define lconstant cantExtend( ch, chType );
        lvars newType = subscrs( ch, charTable );
        not(
            newType == chType or
            ( chType == CHAR_letter and newType == CHAR_digit )
        )
    enddefine;

    define lconstant eatString( procedure r, ch );
        formString(
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
                    if newCh == `\\` and nextCh == `\\` then
                        `\\`, r() -> _
                    else
                        newCh
                    endif;
                endrepeat;
                newCh -> r();
            |#),
            newCh == `\n`
        )
    enddefine;

    ;;; Dispose of leading whitespace.
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
                    if `a` <= newCh and newCh <= `z` do
                        newCh
                    else
                        newCh -> r();
                        quitloop
                    endif
                endrepeat
            |#).lookupWord
        elseif nextCh == `\\` then
            eatString( r, nextCh )
        else
            consword( nextCh, 1 ).lookupWord
        endif;
    elseif mode == 0 then       ;;; starts as 0, incremented by \$ operator.
        eatString( r, ch )
    elseif ch == `\"` then
        formString(
            consstring(#|
                ch,
                repeat
                    lvars newCh = r();
                    quitif( newCh == termin or newCh == ch or newCh == `\n` );
                    newCh
                endrepeat,
                ch
            |#),
            false       ;;; weak = not block-level
        )
    else
        lvars chType = subscrs( ch, charTable );
        lvars word = (
            if chType == CHAR_simple then
                consword( ch, 1 )
            else
                consword(#|
                    ch;
                    repeat
                        lvars newCh = r();
                        quitif( newCh == termin or cantExtend( newCh, chType ) );
                        newCh
                    endrepeat
                |#), newCh -> r()
            endif
        );
        word.lookupWord
    endif
enddefine;


define readToken( tokenizer );
    nextToken( tokenizer.tokenizerSource, tokenizer.tokenizerMode )
enddefine;
