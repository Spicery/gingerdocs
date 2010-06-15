compile_mode :pop11 +strict;

define startsWith( items, word );
    if items.null then
        false
    elseif word.islist then
        member( items.hd, word )
    else
        items.hd == word
    endif
enddefine;

vars procedure ( parseAlts );

define parseItem( items );
    lvars it;
    if startsWith( items, "(" ) then
        items.back.parseAlts -> ( it, items );
        ( it, items.back )
    elseif startsWith( items, "[" ) then
        items.back.parseAlts -> ( it, items );
        ( [ OPT ^it ], items.back )
    else
        items.dest
    endif
enddefine;

define parseAlt( items );
    lconstant toks = [% "|", "]", ")" %];
    [ SEQ %
        until items.null or ( items @startsWith toks ) do
            lvars it = items.parseItem -> items;
            if
                startsWith( items, "*" ) or
                startsWith( items, "**" ) or
                startsWith( items, "+" ) or
                startsWith( items, "++" )
            then
                [ STAR % items.hd, it %];
                items.tl -> items
            else
                it
            endif
        enduntil
    %],
    items
enddefine;

define parseAlts( items );
    [ ALT %
        repeat
            lvars alt;
            items.parseAlt -> ( alt, items );
            alt;
            quitunless( items @startsWith "|" );
            items.tl -> items
        endrepeat
    %], items
enddefine;

define parseSyntax( L );
    lvars ( x, rest ) = parseAlts( L );
    unless rest.null do
        mishap( 'Stuff left over', [ ^rest ] )
    endunless;
    x
enddefine;
