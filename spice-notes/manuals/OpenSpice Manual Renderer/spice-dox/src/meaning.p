compile_mode :pop11 +strict;

;;; -- Typedef Utilities --------------------------------------

define lconstant needed( predicate, desc );
    lvars procedure checker = identfn(%%);
    procedure( L, predicate, desc );
        unless predicate( L ) do
            mishap( L, 1, desc sys_>< ' NEEDED FOR FIELD VALUE' )
        endunless;
        L
    endprocedure(% predicate, desc %) -> checker.updater;

    return( checker )
enddefine;

constant procedure list_needed = needed( islist, 'LIST' );
constant procedure procedure_needed = needed( isprocedure, 'PROCEDURE' );
constant procedure word_needed = needed( isword, 'WORD' );

define strength_needed( x ) -> x;
    if x == "disallowed" then
        mishap( 'Trying to access disallowed strength', [] )
    endif
enddefine;

define updaterof strength_needed( x ) -> x;
    unless x == "strong" or x == "weak" or x == "disallowed" do
        mishap( 'Invalid strength', [ ^x ] )
    endunless
enddefine;

define child_strength_needed( x ) -> x;
    if x == "disallowed" then
        mishap( 'Trying to access disallowed child strength', [] )
    endif
enddefine;

define updaterof child_strength_needed( x ) -> x;
    unless x == "strong" or x == "weak" or x == "disallowed" or x == "non_meaning" do
        mishap( 'Invalid child strength', [ ^x ] )
    endunless
enddefine;


;;; -- Meanings -----------------------------------------------

defclass Kernel {
    kernelAction            : full # word_needed,
    kernelStrength          : full # strength_needed,
    kernelChildStrength     : full # child_strength_needed
};

constant procedure kernel_needed = needed( isKernel, 'KERNEL' );

defclass Meaning {
    meaningKernel           : full # kernel_needed,
    meaningArg              : full # list_needed
};

define meaningAction =
    meaningKernel <> kernelAction
enddefine;

define meaningStrength =
    meaningKernel <> kernelStrength
enddefine;

define meaningChildStrength =
    meaningKernel <> kernelChildStrength
enddefine;

procedure( n, m );
    subscrl( n, m.meaningArg )
endprocedure -> Meaning_key.class_apply;

;;; -- Predefine the Kernels ----------------------------------

define newStrongKernel( w );
    consKernel( w, "strong", "strong" )
enddefine;

define newWeakKernel( w );
    consKernel( w, "weak", "disallowed" )
enddefine;

define newParaKernel( w );
    consKernel( w, "strong", "weak" )
enddefine;

define newLeafKernel( w );
    consKernel( w, "weak", "non_meaning" )
enddefine;

define newFakeKernel( w );
    consKernel( w, "disallowed", "disallowed" )
enddefine;

vars AllIssues  = newStrongKernel( "AllIssues" );
vars AllSyntax  = newStrongKernel( "AllSyntax" );
vars Appendix   = newStrongKernel( "Appendix" );
vars Chapter    = newStrongKernel( "Chapter" );
vars Contents   = newStrongKernel( "Contents" );
vars Dollar     = newFakeKernel( "$" );
vars Fragment   = newStrongKernel( "Fragment" );
vars Indented   = newStrongKernel( "Indented" );
vars Item       = newStrongKernel( "Item" );
vars Issue      = newStrongKernel( "Issue" );
vars Label      = newWeakKernel( "Label" );
vars LinkTo     = newWeakKernel( "LinkTo" );
vars List       = newStrongKernel( "List" );
vars Part       = newStrongKernel( "Part" );
vars Passage    = newStrongKernel( "Passage" );
vars Ref        = newWeakKernel( "Ref" );
vars TableRow   = newStrongKernel( "TableRow" );
vars TableRowItem = newParaKernel( "TableRowItem" );
vars Section    = newStrongKernel( "Section" );
vars Spice      = newParaKernel( "Spice" );
vars Syntax     = consKernel( "Syntax", "strong", "weak" );
vars Table      = newStrongKernel( "Table" );
vars DocTitle   = newParaKernel( "DocTitle" );


vars Paragraph  = newParaKernel( "P" );
vars Dummy      = newStrongKernel( "Dummy" );

vars ParaString = consKernel( "String", "strong", "non_meaning" );
vars String     = newLeafKernel( "String" );

vars Word       = newLeafKernel( "Word" );

vars ClosingKeyword = newFakeKernel( "'<closer>'" );

vars HeaderTitle = newParaKernel( "HeaderTitle" );

;;; -----------------------------------------------------------


define isHeader( M );
    returnunless( M.isMeaning )( false );
    lvars name = M.meaningAction;
    if name == "Part" then
        1
    elseif name == "Chapter" or  name == "Appendix" then
        2
    elseif name == "Section" then
        3
    elseif name == "Passage" then
        4
    elseif name == "Fragment" then
        5
    else
        false
    endif
enddefine;


;;; -- Constructors -------------------------------------------

define newParagraph( n );
    if n >= 1 then
        lvars arg = conslist( n );
        consMeaning( Paragraph, arg )
    endif
enddefine;

define newDummy( L );
    consMeaning( Dummy, L )
enddefine;

define newMeaning =
    consMeaning
enddefine;

define lengthMeaning( m );
    lvars A = m.meaningArg;
    lvars L = A.listlength;
    lvars i;
    for i in A do
        if i.isMeaning then
            i.lengthMeaning
        else
            i.length
        endif + L -> L
    endfor;
    L
enddefine;

define isStringMeaning( M );
    returnunless( M.isMeaning )( false );
    returnunless( M.meaningAction == "String" )( false );
    lvars arg = M.meaningArg;
    unless arg.null.not and arg.tl.null do
        mishap( 'Invalid String Meaning', [ ^M ] )
    endunless;
    return( true );
enddefine;

;;; -----------------------------------------------------------
