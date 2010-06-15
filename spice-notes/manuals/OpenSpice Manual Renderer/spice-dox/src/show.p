uses showtree;

define treeify( x );
    if x.isMeaning then
        [% x.meaningAction, applist( x.meaningArg, treeify ) %]
    else
        lvars s = x sys_>< '';
        if s.length > 10 then
            allfirst( 10, s ) >< '...'
        else
            s
        endif
    endif
enddefine;
