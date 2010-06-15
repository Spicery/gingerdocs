
global vars procedure outputSink;

define global print( x );
    dlocal cucharout = outputSink;
    pr( x )
enddefine;

define global println( x );
    dlocal cucharout = outputSink;
    pr( x );
    nl( 1 );
enddefine;

define global fprint();
    dlocal cucharout = outputSink;
    printf()
enddefine;

define global fprintln();
    dlocal cucharout = outputSink;
    printf();
    nl( 1 )
enddefine;

define global printOn( x, consumer );
    dlvars procedure consumer;
    dlvars procedure previous = cucharout;

    define dlocal cucharout( ch );
        dlocal cucharout = previous;
        consumer( ch )
    enddefine;

    pr( x )
enddefine;
