include system;
include lists;
include st_mean;
include st_tokens;

val widestWidth = 200;

var lookupWord = false;

define procedure makeNiladic( F ) as
    ( F.meanTitle, `daft`, `opApplied`, [], 0, F.meanAction ) @consMeaning
enddefine;

define procedure makeMonadic( L, F ) as
    ( F.meanTitle, `daft`, `opApplied`, [L], 0, F.meanAction ) @consMeaning
enddefine;

define procedure makeMonadicWrapped( Ls, F ) as
    ( F.meanTitle, `daft`, `opApplied`, Ls, 0, F.meanAction ) @consMeaning
enddefine;

define procedure makeDyadic( L, R, F ) as
    ( F.meanTitle, `daft`, `opApplied`, [L, R], 0, F.meanAction ) @consMeaning
enddefine;

define procedure getToken( r, mode ) as
    r @nextToken (mode, lookupWord)
enddefine;

define procedure advance( r, mode ) as
    r @getToken mode, r
enddefine;

var unwrappers = [];

define procedure parseOperand( it, r, mode, width ) as
    val s = it.meanStyle;
    val rank = it.meanRank;
;;;    [`parse operand starting`, s].reportln;
    if s == `Fx` and rank <= width then
        r @advance mode @parseStuff (mode, rank - 1)
        -> (val R, val newNext);
        R @makeMonadic it, newNext
    elseif s == `FxendF` then
        dlocal unwrappers = [it.meanArg | unwrappers];
        val oldLevel = mode.left;
        r @parseRepeatedly (mode, widestWidth) -> (val X, val closer);
        X @makeMonadicWrapped it;
        oldLevel -> mode.left;
        if closer.meanTitle = it.meanArg then
            ;;; good; advance to the next token ...
            r @getToken mode
        else
            ;;; ah. we have a random closer.
            if closer.meanTitle @member unwrappers then
                ;;; someone missed out *our* closer! Complain & deliver it.
                warning(# "missing closer", it.meanArg, `got`, closer #);
                closer
            else
                ;;; this one is lonely. Discard it.
                warning(# "unexpected closer", closer, "nested in", unwrappers #);
                r @getToken mode
            endif
        endif
    elseif s == `x` then
        it, r @getToken mode
    elseif s == `F` then
        it @makeNiladic, r @getToken mode
    elseif s == `$` then
        mode.left + 1 -> mode.left;
        r @advance mode @parseOperand (mode, width)
    else
        mishap(# "what sort of starter is this?", it #)
    endif -> (val answer, val token);
;;;     [`parse operand returning`, answer, token].reportln;
    answer, token
enddefine;

define procedure parseStuff( this, r, mode, width ) as
    (this, r) @parseOperand (mode, width) -> (var L, var next);
    ;;; [`parse stuff has`, L, `with next`, next.meanStyle,`=`, next].reportln;
    repeat
        val s = next.meanStyle;
        val rank = next.meanRank;
        breakunless (s == `xF` or s == `xFx`) and (rank <= width);
        if s == `xF` then
            ;;; [`-- that is postfix`].reportln;
            L @makeMonadic next -> L, r @getToken mode -> next
        else
            ;;; [`-- that is infix`].reportln;
            r @advance mode @parseStuff (mode, rank - 1)
            -> (val R, val newNext);
            (L, R) @makeDyadic next -> L, newNext -> next
        endif
    endrepeat;
    ;;; [`parse stuff returns`, L, `with next`, next].reportln;
    L, next
enddefine;

define procedure parseRepeatedly( r, mode, width ) as
    var this = r @getToken mode;
    [repeat until this.meanStyle == `endF` do
        (this, r) @parseStuff (mode, width) -> this
    endrepeat],
    ;;; [`parse repeatedly ends with`, this].reportln;
    this
enddefine;
