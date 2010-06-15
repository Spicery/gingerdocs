include system;
include st_mean;
include lists;

val CHAR_plain = 0;
val CHAR_digit = 1;
val CHAR_letter = 2;
val CHAR_simple = 3;
val CHAR_sign = 4;
val CHAR_termin = 5;
val CHAR_slash = 6;
val CHAR_layout = 7;
val CHAR_dollar = 8;

define procedure setType( charType, chars, table ) as
    for i from 1 to chars.length do
        charType -> table?(chars?i)
    endfor
enddefine;

val answer = consString(# repeat 256 times CHAR_plain endrepeat #);

define val charTable as
    setType( CHAR_digit, "0123456789", answer );
    setType( CHAR_simple, "(){}[];", answer );
    setType( CHAR_layout, "\n\t\s", answer );
    setType( CHAR_slash, "\\", answer );
    setType( CHAR_dollar, "$", answer );
    setType( CHAR_sign, "!@#~%^&*+-=|:<>?/", answer );
    setType( CHAR_letter, "abcdefghijklmnopqrstuvwxyz", answer );
    setType( CHAR_letter, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", answer );
    answer
enddefine;

define procedure peekCh( r ) as
    r() -> val peek, peek -> r(), peek
enddefine;

define procedure eatString( r, ch ) as
    consString
        (#
        ch;
        repeat
            val newCh = r();
            val nextCh = r.peekCh;
            breakif
                newCh == termin
                or (newCh == '\\' and nextCh /== '\\')
                or (newCh == '\n' and nextCh == '\n')
                ;
            if newCh == '\\' and nextCh == '\\' then '\\', r() @erase
            else newCh
            endif
        endrepeat;
        unless newCh == termin do newCh -> r() endunless
        #) @formString (newCh == '\n')
enddefine;

define procedure nextToken( r, mode, lookupWord ) as
    repeat
        val ch = r();
        breakunless (ch == ' ' or ch == '\n' or ch == '\t');
    endrepeat;
    if ch == termin then
        formTermin()
    elseif ch == '\\' then
        val nextCh = r();
        if 'a' <= nextCh and nextCh <= 'z' then
            consWord
                (#
                nextCh;
                repeat
                    val newCh = r();
                    breakunless ('a' <= newCh and newCh <= 'z');
                    newCh
                endrepeat
                #) @lookupWord, newCh -> r()
        elseif nextCh == '\\' then
            r @eatString nextCh
        else
            consWord(# nextCh #) @lookupWord
        endif
    elseif mode.left == 0 then
        r @eatString ch
;;;     elseif ch == '#' then
;;;         consString
;;;             (#
;;;             repeat
;;;                 val newCh = r();
;;;                 breakif (newCh == termin or newCh == '#');
;;;                 newCh
;;;             endrepeat
;;;             #) @formString false
    elseif ch == '\"' then
        consString
            (#
            ch,
            repeat
                val newCh = r();
                breakif (newCh == termin or newCh == ch or newCh == '\n');
                newCh
            endrepeat,
            ch
            #) @formString false
    else
        val chType = charTable?ch;
        if chType == CHAR_simple then
            consWord(# ch #)
        else
            consWord
                (#
                ch;
                repeat
                    val newCh = r();
                    breakif newCh == termin or (newCh @cantExtend chType);
                    newCh
                endrepeat
                #), newCh -> r()
        endif @lookupWord
    endif
enddefine;

define procedure cantExtend( ch, chType ) as
    val newType = charTable?ch;
    not (newType == chType or (chType == CHAR_letter and newType == CHAR_digit))
enddefine;
