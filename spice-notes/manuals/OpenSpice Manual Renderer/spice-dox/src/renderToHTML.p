compile_mode :pop11 +strict;

define htmlPutOn( ch, procedure p );
    if ch == `<` then
        appdata( '&lt;', p )
    elseif ch == `>` then
        appdata( '&gt;', p )
    elseif ch == `&` then
        appdata( '&amp;', p )
    else
        p( ch )
    endif
enddefine;

define htmlPut( ch );
    htmlPutOn( ch, outputSink )
enddefine;

define htmlPrint( x );
    dlocal cucharout = htmlPut;
    pr( x )
enddefine;

define htmlPrintln( x );
    dlocal cucharout = htmlPut;
    pr( x );
    nl( 1 );
enddefine;

define weakOutput( M );
    lvars k = M.meaningKernel;
    if k == String then
        xmlOutput( M( 1 ) )
    elseif k == Word then
        appdata( M(1), outputSink )
    else
        mishap( 'Unexpected weak value', [ ^k ^M ] )
    endif
enddefine;

define paraOutput( M );
    applist( M.meaningArg, weakOutput )
enddefine;

vars styled_text = true;
vars the_contents;
vars the_issues;
vars the_defs;

defclass Contents {
    contentsList,
    contentsRefs
};

defclass Defs {
    defsMeaningToIndex,
    defsIndexToMeaning,
    defsIsDefined
};

define renderRefNo( r );
    lvars gap = '[';
    lvars i;
    for i in r do
        print( gap );
        '.' -> gap;
        print( i );
    endfor;
    print( ']' );
enddefine;

;;;
;;; Konqueror has a problem coping with refs-nos as anchors.  We render
;;; them in a plainer version for anchors.
;;;
define renderRefNoAsAnchor( r );
    lvars gap = '';
    lvars i;
    for i in r do
        print( gap );
        '_' -> gap;
        print( i );
    endfor;
enddefine;

;;;
;;; Konqueror seems to have a problem with stylesheets that means
;;; the abuse of BLOCKQUOTE gives a better result.  Netscape's
;;; support is also less than ideal.  So, with apologies to
;;; BLOCKQUOTE ...
;;;
define htmlName =
    newanyproperty(
        [
            [ ^List 'ul' ]
            [ ^Item 'li' ]
            [ ^Indented 'blockquote' ]
            [ ^TableRow 'tr' ]
            [ ^TableRowItem 'td' ]
        ], 8, 1, false,
        false, false, "perm",
        false,
        procedure( k, self );
            uppertolower( k.kernelAction.word_string )
        endprocedure
    )
enddefine;

;;;
;;; Precedence levels:
;;;     brackets has precedence 0
;;;     alternation has precedence 1
;;;     sequence is has precedence 2 (more tightly binding = bigger)
;;;

constant ZEROPREC = 0;
constant ALTPREC = 1;
constant SEQPREC = 2;
constant STARPREC = 3;

;;;
;;; prec is the precedence of the context, which determines if
;;; brackets are needed or not.
;;;
define renderItem( x, prec );
    if x.islist then
        lvars ( h, t ) = dest( x );
        if h == "SEQ" then
            if prec > SEQPREC then print( ' ( ' ) endif;
            lvars i;
            for i in t do
                renderItem( i, SEQPREC );
                print( ' ' );
            endfor;
            if prec > SEQPREC then print( ' ) ' ) endif;
        elseif h == "ALT" then
            if prec > ALTPREC then print( ' ( ' ) endif;
            lvars i;
            lvars gap = '';
            for i in t do
                print( gap );
                ' | ' -> gap;
                renderItem( i, ALTPREC );
            endfor;
            if prec > ALTPREC then print( ' ) ' ) endif;
        elseif h == "STAR" then
            if prec > STARPREC then print( ' ( ' ) endif;
            renderItem( t(2), STARPREC );
            print( ' ' );
            print( t(1) );
            print( ' ' );
            if prec > STARPREC then print( ' ) ' ) endif;
        elseif h == "OPT" then
            print( ' [ ' );
            lvars i;
            for i in t do
                renderItem( i, ZEROPREC );
                print( ' ' );
            endfor;
            print( ' ] ' );
        else
            mishap( 'Cannot render this item in DEF', [ ^h ] )
        endif
    else
        if x.isstring then
            print( '<b>' );
            xmlOutput( x );
            print( '</b>' );
        elseif defsIsDefined( the_defs )( x ) then
            print( '<a href="#syntax-' );
            htmlPrint( x );
            print( '">' );
            htmlPrint( x );
            print( '</a>' );
        else
            htmlPrint( x );
        endif;
        print( ' ' );
    endif
enddefine;

define renderDef( N, name, body, anchored );

    define blobLength( x );
        if x.islist then
            lvars total = 0;
            lvars i;
            for i in x.tl do
                total + blobLength( i ) + 1 -> total
            endfor;
            total
        else
            x.length
        endif
    enddefine;

    define isLongSeq( x );
        x.blobLength > 72
    enddefine;

    /*  -----------------------
        | def<N>|Name|::=|Seq1|
        |-------+----+---+----|
        |       |    ||  |Seq2|
        -----------------------
    Each Seq is laid out either horizontally or vertically depending
    on width.
    */
    lvars ( ALT, seqs ) = body.dest;
    unless ALT == "ALT" do
        mishap( 'Unexpected', [ ^ALT ] )
    endunless;

    lvars def = 'def' sys_>< N sys_>< '.';
    lvars altsym = '::=';
    println( '<blockquote><table border="0">' );
    lvars seq;
    for seq in seqs do
        lvars ( SEQ, stuff ) = seq.dest;
        unless SEQ == "SEQ" do
            mishap( 'Unexpected', [ ^SEQ ] )
        endunless;
        print( '<tr>' );
        print( '<td valign="top">' );
        if def then
            htmlPrint( def )
        else
            print( '&nbsp;' )
        endif;
        println( '</td>' );
        print( '<td valign="top">' );
        if name then
            if anchored then
                print( '<a name="syntax-' );
                htmlPrint( name );
                print( '">' );
                htmlPrint( name );
                print( '</a>' );
            else
                htmlPrint( name );
            endif
        else
            print( '&nbsp;' )
        endif;
        println( '</td>' );
        print( '<td valign="top">' );
        print( altsym );
        println( '</td>' );
        false -> def;
        false -> name;
        '|' -> altsym;
        print( '<td valign="top">' );
        lvars islong = isLongSeq( seq );
        lblock
            lvars i;
            for i in stuff do
                renderItem( i, ALTPREC );
                if islong then
                    println( '<br>' )
                endif
            endfor;
        endlblock;
        println( '</td>' );
        println( '</tr>' );
    endfor;
    println( '</table></blockquote>' );
enddefine;

define renderOneDef( M, anchored );
    lvars args = M.meaningArg;
    renderDef(
        defsMeaningToIndex( the_defs )( M ),
        hd( args )( 1 ),
        parseSyntax( [% lvars j; for j in args.tl do j(1) endfor %] ),
        anchored
    )
enddefine;

define render( M );
    check M : Meaning;
    if M.meaningStrength == "weak" then
        if styled_text then
            weakOutput( M )
        else
            applist( M.meaningArg, htmlPrint )
        endif
    else
        lvars kernel = M.meaningKernel;
        lvars name = kernel.htmlName;
        lvars args = M.meaningArg;
        if kernel == Syntax then
            renderOneDef( M, true )
        elseif kernel == AllSyntax then
            lvars i;
            for i in_vector defsIndexToMeaning( the_defs ) do
                renderOneDef( i, false )
            endfor;
        elseif kernel == HeaderTitle then
            lblock
                lvars r = contentsRefs( the_contents )( M );
                lvars name = 'h' sys_>< r.length;
                fprint( '<%p><a name="', [^name] );
                renderRefNoAsAnchor( r );
                println( '">' );
                renderRefNo( r );
                print( ' ' );
                paraOutput( M );
                fprintln( '</a></%p>', [ ^name ] );
            endlblock
        elseif M.isHeader then
            lblock
                applist( args, render );
            endlblock
        elseif kernel == Spice then
            dlocal styled_text = false;
            println( '<blockquote><pre>' );
            applist( args, render );
            println( '</pre></blockquote>' );
        else
            if args.null then
                fprintln( '<%p/>', [ ^name ] );
            else
                fprint( '<%p>', [ ^name ] );
                applist( args, render );
                fprintln( '</%p>', [ ^name ] );
            endif
        endif
    endif
enddefine;


define getDefs( args );

    dlvars count = 0;
    dlvars procedure defs_table = (
        newanyproperty(
            [], 8, 1, false,
            false, false, "perm",
            false, false
        )
    );
    dlvars procedure is_defined = (
        newanyproperty(
            [], 8, 1, false,
            false, false, "perm",
            false, false
        )
    );

    define find( M );
        returnunless( M.isMeaning );
        if M.meaningKernel == Syntax then
            count + 1 ->> count -> defs_table( M );
            lvars name = hd( meaningArg( M ) )( 1 );
            true -> is_defined( name );
        else
            applist( M.meaningArg, find )
        endif
    enddefine;

    applist( args, find );

    lvars index = initv( count );
    fast_appproperty(
        defs_table,
        procedure( k, v );
            k -> index( v )
        endprocedure
    );

    consDefs(
        defs_table,
        index,
        is_defined
    )
enddefine;


define getContents( args );
    dlvars depth = 0;
    dlvars refno = [];
    dlvars procedure ref_table = (
        newanyproperty(
            [], 8, 1, false,
            false, false, "perm",
            false, false
        )
    );

    define findHeader( M );
        returnunless( M.isMeaning );
        lvars level = M.isHeader;
        if level then
            lvars ( hdr, rest ) = M.meaningArg.dest;
            if level > depth then
                repeat level - depth - 1 times
                    conspair( 1, refno ) -> refno
                endrepeat;
                level -> depth;
                conspair( 0, refno ) -> refno;
            else
                repeat depth - level times
                    depth - 1 -> depth;
                    refno.tl -> refno
                endrepeat;
            endif;
            conspair( refno.hd + 1, refno.tl ) -> refno;
            refno.rev -> hdr.ref_table;
            hdr;
            applist( M.meaningArg, findHeader )
        else
            applist( M.meaningArg, findHeader )
        endif
    enddefine;

    consContents(
        [% applist( args, findHeader ) %],
        ref_table
    )
enddefine;


define renderContents( cnts );

    define nbsp( n );
        repeat n times
            print( '&nbsp;' );
        endrepeat;
    enddefine;

    println( '<p>Contents</p>' );
    println( '<table border="0">' );
    lvars m;
    for m in contentsList( cnts ) do
        lvars r = contentsRefs( cnts )( m );
        lvars len = r.length;
        if len <= 3 then
            print( '<tr><td>' );
            ;;; nbsp( len - 1 );
            print( '<a href="#' );
            renderRefNoAsAnchor( r );
            print( '">' );
            renderRefNo( r );
            print( '</a>' );
            print( '</td><td>' );
            repeat 2 * ( len - 1 ) times print( '.&nbsp;' ) endrepeat;
            render( m(1) );
            println( '</td></tr>' );
        endif;
    endfor;
    println( '</table>' );
enddefine;

define getHead( args );
    lvars doctitle = args.hd;
    unless doctitle.meaningAction == "DocTitle" do
        mishap( 'DocTitle needed', [ ^doctitle ] )
    endunless;
    doctitle
enddefine;

define renderHead( head );
    print( '<title>' );
    paraOutput( head );
    println( '</title>' );
enddefine;

define renderTitle( head );
    print( '<h1 align="center"><u>' );
    paraOutput( head );
    println( '</u></h1>' );
enddefine;

define getBody( args );
    args.tl
enddefine;

define renderBody( body, cnts, defs );
    dlocal the_contents = cnts;
    dlocal the_defs = defs;
    applist( body, render )
enddefine;

constant transitional_dtd = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">';

define renderToHTML( L );
    lvars dummy = newDummy( L ).repair;
    verify( dummy );
    lvars args = dummy.meaningArg;

    lvars cnts = args.getContents;
    lvars defs = args.getDefs;
    lvars head = args.getHead;
    lvars body = args.getBody;

    println( transitional_dtd );
    println( '<html>' );
    println( '<head>' );
    renderHead( head );
    println( '</head>' );
    println( '<body style="background-color: white;">' );
    renderTitle( head );
    renderContents( cnts );
    renderBody( body, cnts, defs );
    println( '</body>' );
    println( '</html>' );
enddefine;
