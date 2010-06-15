
;;; load dox.p



;;; trace getToken;
;;; trace nextToken;
;;; trace eatString;
;;; trace formString;
untrace parseOperand;
untrace parseRepeatedly;
untrace parseStuff;

define parse( fname );
    dlocal poplinenum = 0;
    dlocal cuchartrace = cucharout;
    lvars tokenizer = newTokenizer( fname.charsFromFile );
    parseRepeatedly( tokenizer, widestWidth ) -> _
enddefine;

define test( fname );
    dlocal poplinenum = 0;
    dlocal cuchartrace = cucharout;
    dlocal outputSink = 'test-lab/foo.tex'.discout;
    lvars tokenizer = newTokenizer( fname.charsFromFile );
    [%
        '\\documentclass{report}\n' @literal,
        '\\setlength{\\parindent}{0in}\n' @literal,
        '\\setlength{\\parskip}{2mm}\n' @literal,
        delayedTitle,
        '\\author{Chris Dollin}\n' @literal,
        '\\begin{document}\n' @literal,
        '\\maketitle\n' @literal,
        '\\tableofcontents\n' @literal,
        applist( parseRepeatedly( tokenizer, widestWidth ) -> _, evalItemPara ),
        '\\end{document}\n' @literal
    %] @applist printItem;
    outputSink( termin );
enddefine;

;;; test( 'test-lab/foo.txt' );
test( 'manual.web' );
