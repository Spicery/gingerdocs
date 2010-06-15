compile_mode :pop11 +strict;


;;; -- Parser -------------------------------------------------

constant widestWidth = 200;

define makeOperand( T );
    newMeaning( T.tokenKernel, [% T.tokenValue %] )
enddefine;

define makeNiladic( T );
    newMeaning( T.tokenKernel, [] )
enddefine;

define makeMonadic( L, T );
    newMeaning( T.tokenKernel, [ ^L ] )
enddefine;

define makeMonadicWrapped( Ls, T );
    newMeaning( T.tokenKernel, Ls )
enddefine;

define makeDyadic( L, R, T );
    newMeaning( T.tokenKernel, [ ^L ^R ] )
enddefine;


vars unwrappers = [];

vars procedure ( parseStuff, parseRepeatedly );

define parseOperand( it, tokenizer, width ) -> ( answer, token );
    lvars it_syn = it.tokenSynProps;
    lvars s = it_syn.synPropsStyle;
    lvars rank = it_syn.synPropsRank;
;;;    [`parse operand starting`, s].reportln;
    if s == "Fx" and rank <= width then
        lvars ( R, newNext ) = parseStuff( readToken( tokenizer ), tokenizer, rank - 1 );
        makeMonadic( R, it ), newNext
    elseif s == "FxendF" then
        lvars wantedb = it_syn.synPropsClosingBracket;
        dlocal unwrappers = [ ^wantedb ^^unwrappers ];
        saveTokenizerMode( tokenizer );
        lvars ( X, closer ) = parseRepeatedly( tokenizer, widestWidth );
        makeMonadicWrapped( X, it );
        restoreTokenizerMode( tokenizer );
        lvars gotb = closer.tokenSynProps.synPropsClosingBracket;
        if gotb == wantedb then
            ;;; good; advance to the next token ...
            readToken( tokenizer )
        else
            ;;; ah. we have a random closer.
            if lmember( gotb, unwrappers ) then
                ;;; someone missed out *our* closer! Complain & deliver it.
                warning( 'missing closer', [% wantedb, "got", gotb %] );
                closer
            else
                ;;; this one is lonely. Discard it.
                warning( 'unexpected closer', [% gotb, 'nested in', unwrappers %] );
                readToken( tokenizer )
            endif
        endif
    elseif s == "x" then
        it.makeOperand, readToken( tokenizer )
    elseif s == "F" then
        makeNiladic( it ), readToken( tokenizer )
    elseif s == "$" then
        tokenizer.enterQuasiQuotingMode;
        parseOperand( readToken( tokenizer ), tokenizer, width )
    else
        mishap( 'what sort of starter is this?', [^it] )
    endif -> ( answer, token );
    unless answer.isMeaning do
        mishap( 'ParseOperand says Meaning needed', [ ^answer ] )
    endunless;
enddefine;

define parseStuff( this, tokenizer, width ) -> ( L, next );
    parseOperand( this, tokenizer, width ) -> ( L, next );
    repeat
        lvars next_syn = next.tokenSynProps;
        lvars s = next_syn.synPropsStyle;
        lvars rank = next_syn.synPropsRank;
        quitunless( s == "xF" or s == "xFx" ) and ( rank <= width );
        if s == "xF" then
            ;;; [`-- that is postfix`].reportln;
            makeMonadic( L, next ) -> L,  readToken( tokenizer ) -> next
        else
            ;;; [`-- that is infix`].reportln;
            lvars ( R, newNext ) =  parseStuff( readToken( tokenizer ), tokenizer, rank - 1 );
            makeDyadic( L, R, next ) -> L, newNext -> next
        endif
    endrepeat;
    unless L.isMeaning do
        mishap( 'parseStuff says Meaning needed', [ ^L ] )
    endunless;
enddefine;

define parseRepeatedly( tokenizer, width );
    lvars this = tokenizer.readToken;
    [%
        until this.tokenSynProps.synPropsStyle == "endF" do
            parseStuff( this, tokenizer, width ) -> this
        enduntil
    %];
    this
enddefine;


;;; -- Main ---------------------------------------------------

define defWrapper( name, endName, kernel );
    lvars ( a, b ) = newPairedSynProps( name, endName, kernel );
    ( [ ^name ^a ], [ ^endName ^b ] )
enddefine;

define defSimple( name, kernel );
    [% name, newSingleSynProps( "F", kernel ) %]
enddefine;

define defInfix( name, level, kernel );
    [% name, newOpSynProps( "xFx", level, kernel ) %]
enddefine;

define defPrefix( name, kernel );
    [% name, newOpSynProps( "Fx", 20, kernel ) %]
enddefine;

define synPropsTable =
    newanyproperty(
        [%
            defInfix( "linkto", 20, LinkTo );
            defPrefix( "label", Label );
            defInfix( "ref", 20, Ref );
            defWrapper( "part", "endpart", Part ),
            defWrapper( "indented", "endindented", Indented ),
            defWrapper( "title", "endtitle", DocTitle ),
            defWrapper( "chapter", "endchapter", Chapter ),
            defWrapper( "appendix", "endappendix", Appendix ),
            defWrapper( "section", "endsection", Section ),
            defWrapper( "passage", "endpassage", Passage ),
            defWrapper( "fragment", "endfragment", Fragment ),
            defWrapper( "list", "endlist", List ),
            defWrapper( "syntax", "endsyntax", Syntax ),
            ;;; defWrapper( "issue", "endissue", Issue ),
            defWrapper( "row", "endrow", TableRow ),
            defWrapper( "spice", "endspice", Spice ),
            defWrapper( "table", "endtable", Table ),
            defSimple( "allsyntax", AllSyntax ),
            defSimple( "allissues", AllIssues ),
            defSimple( "contents", Contents ),
            [ $ % newSingleSynProps( "$", Dollar ) %]
        %].dup.length, 1, false,
        false, false, "perm",
        newSingleSynProps( "x", Word ),
        false
    )
enddefine;

define lookupWord( w );
    lvars syn = w.synPropsTable;
    newToken( w, syn )
enddefine;


;;; -----------------------------------------------------------
