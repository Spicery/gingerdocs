define parseFile( arg ) -> L;
    lvars tokenizer = arg.discin.newpushable.newTokenizer;
    parseRepeatedly( tokenizer, widestWidth ) -> ( L, _ )
enddefine;



define handleFile( arg, procedure renderer );
    renderer( parseFile( arg ) )
enddefine;

;;; define handleSet( arg );
;;;     ;;; do nothing, today.
;;; enddefine;
;;;
;;; define main( n );
;;;     lvars args = n.conslist;
;;;     lvars action = handleFile;
;;;     lvars arg;
;;;     for arg in args do
;;;         ;;; ['-- doing', arg].reportln;
;;;         if arg = '-file' then handleFile -> action
;;;         elseif arg = '-set' then handleSet -> action
;;;         else arg @action
;;;         endif
;;;     endfor
;;; enddefine;

define pickRenderer( format );
    if format == "latex" then
        renderToLatex
    elseif format == "xml" then
        renderToXML
    elseif format == "html" then
        renderToHTML
    else
        mishap( 'Unrecognized format', [ ^format ] )
    endif
enddefine;

define main( src, snk, format );
    dlocal outputSink = snk.discout;
    handleFile( src, format.pickRenderer  );
    outputSink( termin );
enddefine;

define manual1();
    main( 'manual.web', 'lab/manual.tex', "latex" );
enddefine;

define manual2();
    main( 'manual.web', 'lab/manual.xml', "xml" );
enddefine;

define manual3();
    main( 'manual.web', 'lab/manual.html', "html" );
enddefine;

define bar1();
    main( 'lab/bar.txt', 'lab/bar.xml', "xml" );
enddefine;

define bar2();
    main( 'lab/bar.txt', 'lab/bar.html', "html" );
enddefine;
