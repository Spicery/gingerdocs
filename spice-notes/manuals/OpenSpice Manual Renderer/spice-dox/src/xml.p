/****************************************************************************
The Target XML Format
---------------------
The key distinction is between text-level elements (weak) and block level
elements (strong).

The -repair- process eliminates the awkward distinction between strong
and weak strings.  It does this by gathering together non-block elements
into paragraphs.  Paragraphs are an implicit block-level grouping that
means that all blocks are represented by a block-element.
****************************************************************************/

compile_mode :pop11 +strict;
section $-xml => repair verify xmlOutput;

define parseString( x );

    define parse( a, z, delim, str );
        while a <= z do
            lvars ch = subscrs( ( a, a + 1 -> a ), str );
            quitif( ch == delim );
            if ch == `!` then
                if a <= z then
                    subscrs( ( a, a + 1 -> a ), str );
                else
                    warning( '! at end of string', [ ^str ] );
                    ch
                endif
            elseif ch == `_` then
                [ b % parse( a, z, ch, str ) -> a %]
            elseif ch == `*` then
                [ i % parse( a, z, ch, str ) -> a %]
            elseif ch == `~` then
                [ sub % parse( a, z, ch, str ) -> a %]
            elseif ch == `^` then
                [ sup % parse( a, z, ch, str ) -> a %]
            elseif ch == `|` then
                ;;; Should really be code not tt.
                [ code % parse( a, z, ch, str ) -> a %]
            else
                ch
            endif
        endwhile;
        a;
    enddefine;


    [ plain %
        lvars z = parse( 1, x.datalength, false, x );
        unless z == x.datalength + 1 do
            mishap( 'parseString failed', [ ^x ^(x.datalength) ^z ] )
        endunless
    %]

enddefine;

define xmlPrintParsedString( tree );

    define printChar( ch );
        if ch == `<` then
            print( '&lt;' )
        elseif ch == `>` then
            print( '&gt;' )
        elseif ch == `&` then
            print( '&amp;' )
        else
            outputSink( ch )
        endif
    enddefine;

    if tree.isinteger then
        printChar( tree )
    else
        lvars ( type, args ) = tree.dest;
        if type == "plain" then
            applist( args, xmlPrintParsedString )
        else
            fprint( '<%p>', [ ^type ] );
            applist( args, xmlPrintParsedString );
            fprint( '</%p>', [ ^type ] );
        endif
    endif
enddefine;

;;;
;;; At this point "str" is meant to represent styled text using
;;; a set of textual conventions.  e.g. _foo_ meaning bold [sic] foo.
;;;
define xmlOutput( str );
    check str : string;
    xmlPrintParsedString( parseString( str ) )
enddefine;

define verify( M );
    dlvars count = 0;
    lvars nesting = [];

    define do_verify( M );
        check M : Meaning;
        count + 1 -> count;
        dlocal nesting = M.meaningAction :: nesting;

        define verify_child_strength( x, cs );
            if cs == "strong" or cs == "weak" then
                x.isMeaning and x.meaningStrength == cs
            elseif cs == "non_meaning" then
                not( x.isMeaning )
            else
                mishap( 'Verification failed: Invalid child strength', [ ^cs ] )
            endif
        enddefine;

        if M.meaningKernel == Syntax then
            lvars i;
            for i in M.meaningArg do
                lvars k = i.meaningKernel;
                unless k == String or k == Word do
                    mishap( 'Verify failed: Syntax contains inappropriate Meaning', [ ^i ] )
                endunless;
            endfor
        endif;

        lvars cs = M.meaningChildStrength;
        lvars i;
        for i in M.meaningArg do
            unless verify_child_strength( i, cs ) do
                mishap( 'Verification failed: Wrong child', [% cs, M.meaningAction, i, nesting %] )
            endunless;
            if i.isMeaning do
                do_verify( i )
            endif
        endfor;
    enddefine;

    do_verify( M );
    nprintf( 'Verified %p nodes', [ ^count ] );
enddefine;

;;;
;;; Repair the Meaning tree:
;;;     Ensure all the well-formedness constraints are satisfied.
;;;
define repair( M ) -> M;

    define addParagraphs( L );

        define eat( n, x, L );
            lvars s = x.meaningStrength;
            if s == "weak" then
                if L.null then
                    newParagraph( x, n + 1 )    ;;; form para & stop.
                else
                    eat( x, n + 1, L.dest )     ;;; start building paras & cont.
                endif
            elseif x.isStringMeaning then
                copy( x ) -> x;
                String -> x.meaningKernel;
                newParagraph( x, n + 1 );       ;;; form para & push.
                addParagraphs( L );             ;;; start again
            else
                newParagraph( n );              ;;; form para if needed & push.
                x.repair;                       ;;; push x.
                addParagraphs( L )              ;;; start again
            endif
        enddefine;

        unless L.null do
            eat( 0, L.dest )
        endunless
    enddefine;

    if M.isMeaning then
        lvars kernel = M.meaningKernel;
        if kernel == TableRow then
            newMeaning(
                TableRow,
                [%
                    lvars i;
                    for i in M.meaningArg do
                        newMeaning( TableRowItem, [ ^i ] )
                    endfor
                %]
            ) -> M
        elseif M.isHeader then
            copy( M ) -> M;
            lvars ( title, rest ) = M.meaningArg.dest;
            title.copy -> title;
            String -> title.meaningKernel;
            [%
                newMeaning( HeaderTitle, [ ^title ] ),
                rest.addParagraphs
            %] -> M.meaningArg;
        elseif M.meaningChildStrength == "strong" then
            copy( M ) -> M;
            [% M.meaningArg.addParagraphs %] -> M.meaningArg;
        elseif M.meaningChildStrength == "weak" then
            copy( M ) -> M;
            [%
                lvars m;
                for m in M.meaningArg do
                    if m.isMeaning then
                        lvars s = m.meaningStrength;
                        if s == "strong" then
                            if m.meaningKernel == ParaString then
                                newMeaning( String, [% m(1) <> '\n\n' %] )
                            else
                                mishap( 'Cannot repair this strong item in weak context', [ ^m ] )
                            endif
                        elseif s == "weak" then
                            m
                        else
                            mishap( 'Repair refused: Inappropriate strength found', [ ^s ^m ] )
                        endif
                    else
                        mishap( 'Repair refused: Inappropriate non-meaning found', [ ^m ] )
                    endif
                endfor
            %] -> M.meaningArg;
        endif;
        if M.meaningKernel == List then
            lblock
                copy( M ) -> M;
                [%
                    lvars i;
                    for i in M.meaningArg do
                        newMeaning( Item, [% i %] )
                    endfor
                %] -> M.meaningArg;
            endlblock
        endif;
    endif
enddefine;

endsection;
