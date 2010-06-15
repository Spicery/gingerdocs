compile_mode :pop11 +strict;

define xmlRender( M );
    if M.isstring then
        xmlOutput( M )
    elseif M.isword then
        appdata( M, outputSink )
    elseif M.isMeaning then
        lvars w = M.meaningAction;
        lvars action = M.meaningAction;
        lvars name = action.uppertolower;
        lvars args = M.meaningArg;
        lvars level = M.isHeader;
        if level then
            lblock
                fprintln( '<%p level="%p">', [ ^name ^level ] );
                applist( args, xmlRender );
                fprintln( '</%p>', [ ^name ] );
            endlblock
        else
            if args.null then
                fprintln( '<%p/>', [ ^name ] );
            else
                fprint( '<%p>', [ ^name ] );
                applist( args, xmlRender );
                fprintln( '</%p>', [ ^name ] );
            endif
        endif
    else
        mishap( 'Unexpected output', [ ^M % M.dataword % ] )
    endif
enddefine;

define renderToXML( L );
    println( '<Document Author="Chris Dollin">' );
    println( '<Contents/>' );
    lvars d = newDummy( L ).repair;
    verify( d );
    applist( d.meaningArg, xmlRender );
    println( '</Document>' );
enddefine;
