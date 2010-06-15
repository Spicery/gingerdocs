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

define global syntax 8.5 @;
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


;;; -- check --------------------------------------------------
;;;
;;; This is a hack for primitive type+consistency checking.  The
;;; main purpose is to double-check my intuitions about the types
;;; of input locals or loop variables.
;;;

define global syntax check;

    define lconstant check_predicate( w, x, pred );
        unless fast_apply( x, pred ) then
            mishap( x, 1, 'Variable ' sys_>< w sys_>< ' fails ' sys_>< pred.pdprops sys_>< ' test' )
        endunless
    enddefine;

    lvars w = readitem();
    sysPUSHQ( w );
    sysPUSH( w );
    if pop11_try_nextreaditem( ":" ) then
        sysPUSH( "is" <> readitem() );
    elseif pop11_need_nextreaditem( "." ) then
        sysPUSH( readitem() );
    else
        mishap( 0, 'Internal error' )
    endif;
    sysCALLQ( check_predicate );
enddefine;


;;; -- printing -----------------------------------------------
;;;
;;; To emulate pepper-style printing I have created a small
;;; collection of handy procedures.  These are very useful
;;; anyway since they support the redirection of output without
;;; taking over cucharout.  Hijacking cucharout is always a
;;; dangerous policy since it has an unintentionally wide
;;; effect.
;;;

;;;
;;; outputSink is the alternative to cucharout through which all
;;; character-level output will go.  This _must_ be dlocalized by
;;; -main-.
;;;
global vars procedure outputSink = cucharout;

;;; prints to outputSink.
define global print( x );
    dlocal cucharout = outputSink;
    pr( x )
enddefine;

;;; prints to outputSink.
define global println( x );
    dlocal cucharout = outputSink;
    pr( x );
    outputSink( `\n` )
enddefine;

;;; formatted printing to outputSink.
define global fprint();
    dlocal cucharout = outputSink;
    printf()
enddefine;

;;; formatted printing to outputSink.
define global fprintln();
    dlocal cucharout = outputSink;
    printf();
    nl( 1 )
enddefine;

;;; formatted printing to custom character sink.
define global fprintOn( consumer );
    dlvars procedure consumer;
    dlvars procedure previous = cucharout;

    define dlocal cucharout( ch );
        dlocal cucharout = previous;
        consumer( ch )
    enddefine;

    printf()
enddefine;

;;; formatted printing to custom character sink.
define global fprintlnOn( consumer );
    dlvars procedure consumer;
    dlvars procedure previous = cucharout;

    define dlocal cucharout( ch );
        dlocal cucharout = previous;
        consumer( ch )
    enddefine;

    printf();
    nl( 1 )
enddefine;

;;; prints to custom character sink.
define global printOn( x, consumer );
    dlvars procedure consumer;
    dlvars procedure previous = cucharout;

    define dlocal cucharout( ch );
        dlocal cucharout = previous;
        consumer( ch )
    enddefine;

    pr( x )
enddefine;



;;; -----------------------------------------------------------
