define ved_popmr();
    dlocal vedargument;
    ved_gsr( '/`/!!' -> vedargument );      ;;; pep wrd -> saved
    ved_gsr( '/\'/`' -> vedargument );       ;;; pep chr -> pop chr (pep wd)
    ved_gsr( '/"/\'' -> vedargument );      ;;; pep str -> pop str (pep chr)
    ved_gsr( '/!!/"' -> vedargument );      ;;; pep wrd svd -> pop wrd (pop str)
    ved_gsr( '/(#/(#|' -> vedargument );
    ved_gsr( '/#)/|#)' -> vedargument );
enddefine;
