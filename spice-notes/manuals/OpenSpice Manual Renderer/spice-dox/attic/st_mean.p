include system;
include lists;

define procedure oops( x ) as
    mishap(# "oops", x #)
enddefine;

define recordkey Meaning as
    meanTitle
    meanStrength
    meanStyle
    meanArg
    meanRank
    meanAction
    with length as lengthMeaning
enddefine;

define procedure sigmaLength( n, x ) as
    x.length + n
enddefine;

define procedure lengthMeaning( m ) as
    val A = m.meanArg; val L = A.length;
    (L, A) @appList sigmaLength
enddefine;

define procedure makeWrapper( t, operands ) as
    consMeaning( t.meanTitle, `strong`, `made`, operands, 0, t.meanAction )
enddefine;

define procedure evalString( w ) as
    w @appList identfn
enddefine;

define procedure formString( s, endsWithNewline ) as
    val title = if endsWithNewline then `paraString` else `inString` endif;
    consMeaning( title, `weak`, `x`, [s], 0, evalString )
enddefine;

define procedure formTermin() as
    consMeaning( termin, `weak`, `endF`, absent, 0, oops(% "termin" %) )
enddefine;
