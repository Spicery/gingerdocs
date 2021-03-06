===============================
Common Syntax
===============================

Example of common syntax
------------------------
.. literalinclude:: ../src/example1.common
   :lines: 1-53
   :linenos:
   :language: common

Moar (test) examples
--------------------

.. literalinclude:: ../src/helloworld.common
   :linenos:
   :language: common

.. literalinclude:: ../src/nfib.common
   :linenos:
   :language: common


.. literalinclude:: ../src/factorial.common
   :linenos:
   :language: common


Formal description
------------------

Use http://railroad.my28msec.com/rr/ui to produce a railroad diagram.

.. code-block:: antlr

    Package ::=
        'package' PackageName ';' Import* TopLevelForms 'endpackage'
        
    Import ::=
        'import' ImportQualifier* Tags? from PackageName ( 'alias' AliasName )? ( 'into' Tags )? ';'

    ImportQualifier ::=
        'pervasive' |
        'nonpervasive' |
        'qualified' |
        'unqualified'
        
    Tags ::= '(' ( Tag ( ',' Tag )* )? ')'

    TopLevelForms ::= ( Declaration | Statement ) ( ';' TopLevelForms )*

    Declaration ::=
        Definition |
        Query |
        RecordclassDeclaration

    Definition ::=
        'define' ApplyPattern '=>>' Statements 'enddefine'

    RecordclassDeclaration ::=
        'recordclass' Identifier
            ( 'slot' Identifier ';' )*
        'endrecordclass' 

    Statements ::=
        Statement ( ';' Statements )*

    Statement ::=
        Query |
        Expr

    Query ::=
        Pattern ( 
            ':=' Expr |
            'in' Expr |
            FromByTo
        )
        
    Pattern ::=
        Literal |
        ( ( 'var' | 'val' )? Tags )? Identifier |
        Pattern ( (','|';') Pattern )+  |
        '(' Pattern? ')' |
        '[' Pattern? ']' |
        '{' Pattern? '}' |
        '[%' Pattern? '%]' |
        '\(' Expression ')' |
        ApplyPattern

    ApplyPattern ::=
        Identifier '(' Pattern? ')' |
        Pattern ( '.'|'@') ( Identifier | '(' Expr ')' ) Pattern

    FromByTo ::=
        'from' Expr ('by' Expr )? ('to' Expr)? |
        'by' Expr ('to' Expr)? |
        'to' Expr .

    Expr ::=
        PrimaryExpr ( InfixOperator Expr )*
        

    PrimaryExpr ::=
        AtomicExpr |
        AssignExpr |
        ApplyExpr |
        LambdaExpr |
        ListExpr |
        VectorExpr |
        ConditionalExpr |
        LoopExpr

    AtomicExpr ::=
        Literal |
        Identifier |
        '(' Statements? ')'

    Literal ::=
        'absent' |
        ( 'true' | 'false' ) |
        Number |
        CharacterConstant |
        String
        
    AssignExpr ::=
        Expr '=::' TargetExpr |
        TargetExpr '::=' Expr
        
    TargetExpr ::=
        Identifier |
        ApplyExpr |
        ConditionalTarget
        
    ConditionalTarget ::=
        'if' CoreConditionalTarget 'endif' |
        'unless' CoreConditionalTarget 'endunless'

    CoreConditionalTarget ::=
        Expr then TargetExpr MoreConditionalTarget* 'else' TargetExpr .

    MoreConditionalTarget ::=
        ( 'elseif' | 'elseunless' ) Expr then TargetExpr .
        
    ApplyExpr ::=
        AtomicExpr '(' Statements? ')' |
        PrimaryExpr ( '.' | '@' ) AtomicExpr PrimaryExpr .
        

    LambdaExpr ::=
        'fn' AppExpr '=>>' Statements 'endfn' 

    ListExpr ::=
        '[' Expr* ( '|' Expr )? ']'

    VectorExpr ::=
        '{' Expr '}'

    ConditionalExpr ::=
        'if' CoreConditional 'endif' |
        'unless' CoreConditional 'endunless'

    CoreConditional ::=
        Expr then Statements MoreConditional* ( 'else' Statements )?

    MoreConditional ::=
        ( 'elseif' | 'elseunless' ) Expr then Statements

    LoopExpr ::=
        'for' Query 'do' Statements 'endfor'


    Number ::=
        digit+ ( '.' digit+ )

    String ::=
        '"' QuotedCharacter* '"'

    CharacterConstant ::=
        "'" QuotedCharacter "'"
        
    QuotedCharacter ::=
        printing_character |
        '\\' ( 'n' | 'r' | 's' | 't' | 'v' ) |
        '\\&' HTMLEntity ';' |  
        '\\(' Expr ')'

    InfixOperator ::= ',' | '+' | '-' | '*' | '/'


