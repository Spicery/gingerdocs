=========================================
Patterns and Queries in the Common Syntax
=========================================

Introduction
------------
The inclusion of literal regular expressions to the Common syntax has added a new kind of pattern matching.  The ``val`` and ``define`` constructs already have their own rather limited pattern-matching capability.  It is natural to investigate whether these two notions of matching can be usefully integrated by some kind of extension.

We want to explore integration for two reasons.  Firstly, we want to create a small, uniform and coherent explanatory model for Spice.  Secondly, we know that programming with pattern-matching is a very powerful technique; one could reasonably argue it is a programming paradigm on a par with OOP or even logic programming.

To discuss these opportunities, CJD and SFKL originally met up at HP Labs on 24th October 2001.  Following that meeting, we made a draft proposal. This document is a revision of that proposal, which captures the features we are confident are coherent and consistent with the design principles.

One of the less obvious aspects of this proposal is the way it handles unbound variables. These arise from disjunction and two-way matching. The issue with disjunction is that it may leave variables unbound from the match that was not taken. Similarly two-ways matches can unify variables without binding them to values. 

This proposal avoids the issues by cunningly avoiding disjunctions and two-way matches. In the future we may figure out a way to handles these neatly.

Current Support for Pattern Matching and the Analogy with Regular Expressions
-----------------------------------------------------------------------------
The core language already supports the following patterns when binding arguments, either as the argument of a ``val`` or the formal arguments of a function definition (``define`` or ``fn``).  A pattern is used to match against zero, one or more actual values.

The patterns that are part of the core of Spice are shown below.  In addition, the analogy with regular expressions is illustrated in the right hand column.

.. code-block:: text

    Pattern ::=     _                       # //./
            ::=     ...                     # //.*/
            ::=     Id                      # //(.)/
            ::=     Id ...                  # //(.*)/
            ::=     Id : TypeExpr           # //(T)/
            ::=     Pattern, Pattern        # //AB/
            (with restriction)


N.B. As the language stands, there is an extra restriction that only one vararg (... or Id...) argument can appear in a pattern.  This restriction was originally introduced in order to ensure unambiguous and efficient matching. However such a restriction violates the If-One-Why-Not-Many principle.

Var/Val and Pattern Context
---------------------------
An ambitious goal of this proposal is to interpret all declarations as pattern matches (strictly speaking as Queries). To this end we make a subtle reinterpretation of the ``var``/``val`` syntax. To assist with this, we will use the ``:=`` operator rather than ``=``, which is desirable because it frees up ``=`` for use as the equals operator.

We propose that ``var``/``val`` are prefix operators that introduce a new syntactic context call Pattern Context. Inside a pattern context, we interpret references to identifiers as declarations of those identifiers. Here are some examples that illustrate the concept.

.. code-block:: text

    ### val/var declarations now interpreted as Pattern = Expr with the
    ### ':=' operator playing the role of one-way matcher.
    val x := 99;     
    
    ### val/var of a function application is distributed down to the
    ### identifiers. The role of '=' as a matcher is even more obvious.
    val newPair( x, y ) := E;
    newPair( val x, val y ) := E;
    
    ### Inner uses of val/var override outer uses.
    val newPair( var x, y ) := E;
    newPair( val var x, val y ) := E;
    newPair( var x, val y ) := E;


The following contexts will be deemed to introduce a pattern-context:

 * val/var
 * formal parameters of define/fn
 * bindings of a for-loop
 * cases of a switch expression


Literals and Varargs
--------------------

The first real change we propose is to permit multiple vargs and literals and to
add literals.


.. code-block:: text

    Pattern ::=     Literal                 # //x/
            ::=     _                       # //./
            ::=     ...                     # //.*/
            ::=     Id                      # //(.)/
            ::=     Id...                   # //(.*)/
            ::=     Id : TypeExpr           # //(T)/
            ::=     Pattern, Pattern        # //AB/


This relatively modest change means that there can be multiple bindings to a pattern.  For example,

.. code-block:: text

    val ( x..., y, z... ) := 'abc';



Could bind as any of the following

.. code-block:: text

    x ==> { 'ab' }, y ==> 'c', z ==> {}
    x ==> { 'a' }, y ==> 'b', z ==> { 'c' }
    x ==> {}, y ==> 'a', z ==> { 'bc' }


The analogy with regular expressions suggests that it may be acceptable to impose an order on these solutions, by interpreting ``...`` as greedy or reluctant, and so make a choice.

Also, adding Literals to Patterns is not quite as innocuous as it might seem.  The complication is that a Literal might cause a match to fail.

.. code-block:: text

    val ( "foo", y ) := 'ab';    ### Oh dear!

However, it is no worse that the run-time failure that can already result from a failure to result the correct number of results 

.. code-block:: text

    val x := f();                ### Not necessarily correct!

Type Restrictions
-----------------

The next extension is to restrict Patterns by type. There are two possible interpretations of "x is of type T".  Just as a method's formal parameter can be marked as dispatch or non-dispatch (required), so we can distinguish between the patterns ``x :- T`` and ``x : T``.  


.. code-block:: text

    Pattern ::=     Literal                     # //x/
            ::=     _                           # Shorthand for Any
            ::=     ...                         # Shorthand for Any...
            ::=     Id                          # Shorthand for Id : Any
            ::=     Id...                       # Shorthand for Id : Any...
            ::=     Id : TypeExpr               # Required match
            ::=     Id :- TypeExpr              # Dispatched match
            ::=     Pattern, Pattern            # //AB/    

To illustrate the difference between the two, consider these two examples

.. code-block:: text

    val ..., x : String, ... := ( 0, "oops" );           # generates a run-time error
    val ..., x :- String, ... := ( 0, "ok" );            # binds x to "ok"

In the first case, we find an invalid binding and check it post-hoc.  We don't like what we find and have to raise a run-time error.  In the second case, the match is guided to the unique valid binding and it succeeds.

As will be seen a little further below, the difference between ``:`` and ``:-`` is exactly what we need to "inline" methods as switch statements.


Unified Patterns
----------------

Another worthwhile extension, borrowed from SML this time, is the idea of "chained" Patterns, so you can refer to the original value as well as its matched components.  In our case I have added one clause to the Pattern grammar

.. code-block:: text

    Pattern ::=     Pattern ~= Pattern
    

The Pattern
^^^^^^^^^^^

.. code-block:: text

    A ~= B

is one that only matches if *both* A and B are matched against and all their bindings established.  Note that this is dangle-free.

Switches
--------

Next, we want to execute code conditionally upon a match.  In this case the challenge is to avoid "dangling" match variables.  A spectacular example of a matcher that fails this criterion is the Pop11's matcher.  Experience with the Pop11 matcher shows us that it is important to restrict the scope of match variables to the context of a successful match.  [Aside: A possible alternative would be to define the values in the event of a failed match - which is the approach taken in traditional regular expression matching.]



We propose adapting the ``switch`` statement for this purpose.

.. code-block:: text

    switch Expr
    case Pattern then
        Statements      # match variables of Pattern in scope here
    endswitch   


One issue is that it is commonly required for multiple cases to have the same body. Rather than clone code, it is permitted to write a single case with multiple Patterns. This raises the issue of pattern-disjunction and might create references to unbound variables. This is handled by requiring that every referenced variable in Statements is guaranteed to be bound.

.. code-block:: text

    switch Expr
    case x
    case y then
        ### Cannot reference either x or y since neither are guaranteed to be bound.
    endswitch

Loops as Query Iterators
------------------------

Origin of the Idea
^^^^^^^^^^^^^^^^^^

The second use of Patterns that we would desire is the ability to iterate over some or all of the possible solutions.  Our first hypothetical step is to add a new type of loop expression such as:

.. code-block:: text

    for Pattern matches Expression do Statements endfor
    

The meaning would be that all the possible matches of the Pattern would be found in turn and the Statements executed with the appropriately bound match variables in scope.  

This idea naturally leads to an intriguing interpretation of all the loop expressions as Query iterators.  A good analogy is to be made with Prolog.  A Pattern plays the role of a Prolog term but a Query plays the role of a Prolog predicate.  In this interpretation, code fragments such as:

.. code-block:: text

    i in my_list

    j from 0 to 99


would be interpreted as a Queries.  Their meaning is that the control Pattern is successively bound to the generated values.

Development of the Idea
^^^^^^^^^^^^^^^^^^^^^^^

We propose treating declarations as a form of Query. Queries are forms whose evaluation generates a sequence of bindings to the variable of a Pattern. In particular we will interpret ``=`` as a one-way matcher operator.

Here's the ever-expanding grammar:

.. code-block:: text

    Query   ::=     Pattern = Expr
            ::=     Pattern in Expr
            ::=     Pattern on Expr
            ::=     Pattern from Expr to Expr       ### and all relevant variants


Motivating Examples
^^^^^^^^^^^^^^^^^^^

By way of introduction to the idiom of pattern programming, note how the way can be exploited to achieve the effect of ``in``.

.. code-block:: text

    for x in L do <etc>
    
    for ..., x, ... := L... do <etc>

    

This gives rise to some neat shortcuts - or perhaps merely strange effects.  For example, we can interpret the following loop:

.. code-block:: text

    for x, y in L <etc>

as

.. code-block:: text

    for ..., x, y, ... := L... do <etc>

    
In other words, it finds all the adjacent element pairs in ``L``.  We can vary this trick to get other useful results.  If we wanted all the ordered pairs of distinct elements we might write

.. code-block:: text

    for x, ..., y in L do <etc>

If we wanted to select the string elements from a list we might write this

.. code-block:: text

    { for x :- String in L do x endfor } 

Another idiom might be iterating over all the partitions of list

.. code-block:: text

    for lhs..., rhs... matches L... do <etc>

Constructors and Destructors
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There has been a long-standing tacit agreement that at some point we would attempt to integrate constructors into structure Patterns.  For example, it has always been our intention to arrange that:

.. code-block:: text

    val { x, y } := { 'xy' };


would have the same effect as:

.. code-block:: text

    val x := 'x';  val y := 'y';

We propose to treat function-like application as if they were constructors and implement the match by using their destructors.  This obviously requires that destructors can inferred from constructors and that destructors are distinct from updaters. We propose creating a general "inverse" relationship between functions - and allowing user programmers to extend it themselves.

Adding constructors into Patterns adds no complications.  The grammar expands quite a lot just because we want to match against constructors in both Patterns and TypePatterns.

.. code-block:: text

    Pattern ::=     Literal                     # //x/
            ::=     _                           # Shorthand for Any
            ::=     ...                         # Shorthand for Any...
            ::=     Id                          # Shorthand for Id : Any
            ::=     Id...                       # Shorthand for Id : Any...
            ::=     Id : Type                   # Required match        } see below!
            ::=     Id :- Type                  # Dispatched match      }
            ::=     Pattern, Pattern            # //AB/
            ::=     Pattern ~= Pattern
            ::=     Construction

    Construction 
            ::=     { Pattern }
            ::=     Expr( Pattern )
            ::=     Pattern . Expr
            ::=     Pattern . Expr( Pattern )
            ::=     Pattern @ Expr
            ::=     Pattern @ Expr Pattern

Side Conditions
---------------

Another easy-to-anticipate extension is the addition of side-conditions to Queries (or even Patterns).  Borrowing from HPSL again, we can extend our grammar with the clause:

.. code-block:: text

    Query   ::= Query where Expr

This enables us to write much more powerful queries, such as this palindrome finder, without any significant complications:

.. code-block:: text

    for i..., j... in L where i = j.rev and i.length >= 2 do <etc>


Composite Queries and Repeated Match Variables
----------------------------------------------

Conjunction
^^^^^^^^^^^

Further we might well want to consider the conjunction of two Queries ``A & B``.  Unlike disjunction, conjunction is safe to incorporate as a Query operator as it binds all variables.

.. code-block:: text

    Query   ::= Query & Query


This extension can be used for very modest effect such as the following compact declaration:

.. code-block:: text

    val x := 1 & y := 2;
    

Alternatively, it can be exploited for powerful idioms.  Here is one such idiom for computing the shared elements of two lists:

.. code-block:: text

    define function shared( A, B ) =>
        { for i in A & j where i = j in B do i endfor }
    enddefine;

If there was a way of escaping from a pattern-context back to expression-context we could write the above rather more compactly. We might use the rather ugly ``\( ... )`` notation for that.

.. code-block:: text

    { for i in A & \(i) in B do i endfor }


Shared Variables
^^^^^^^^^^^^^^^^

We can achieve the effect of the above example if we adopt the elegant convention that repeated match variables are permitted and imply equality. The only consideration is whether this extension would introduce difficult scope issues; none have been identified. It anticipaties full two-way unification as in Prolog.  

.. code-block:: text

    ### So it is correct to write the following.
    { for i in A & i in B do i endfor }

This also introduces this beautiful idiom for nested iteration!

.. code-block:: text

    ### This surprised me ...
    for i in A & j in B do <etc>


Parallel Queries
^^^^^^^^^^^^^^^^

In addition to composing Queries with conjunction, we can allow queries to be executed in parallel. The syntax ``Q1 // Q2`` yields a new query that iterates through the solutions of queries Q1 and Q2 in step, binding all the variables in parallel. 

.. code-block:: text

    for i from 1 // j in list do
        ### iterates over j, n being the index of the j in the list
    endfor

Repeated variables are treated as an implicit where clause on the whole query, just as for conjunction.

.. code-block:: text

    ### Find the items that appear in the same position in list1 and list2.
    for i in list1 // i in list2 do
        i
    endfor
    
    ### It works because it is the same as this.
    for ( i in list1 // j in list2 ) where j = i do
    endfor


Queries as Expressions
----------------------
 
Of course, we also want to make conditional switches on Queries as well as Patterns. For this we introduce the ``?- Query`` syntax. This returns true if the binding succeeds and false otherwise. The ``?-`` operator introduces a pattern context.

.. code-block:: text

    if ?- Query then Statements else ... endif

The pattern variables are in scope within the Statements, following the general convention that variables introduced in a condition are in-scope if they are guaranteed to be bound.

Outside of a conditional context the pattern variables are not in scope. It can be treated as a shorthand for ``if ?- Query then true else false endif``. This gives rise to some compact one-liners.  Here is the code for list membership :-

.. code-block:: text

    # Sweet!
    define member( x, L ) => ?- \(x) in L enddefine;


Naked Queries
-------------

A query may simply be written in-line. In which case we refer to it as a declaration. The pattern part of a naked query is always considered to introduce a pattern-context.

.. code-block:: text

    ### Declare x as 99.
    var x := 99;
    
    ### x will be declared as val by default.
    x := 99;
    
    ### Pick out the items to left & right of absent. If no match then fail.
    ### N.B. absent is a literal constant, hence this works.
    ( val left, absent, val right ) in list;        


Equivalence of Method Definitions and Switches
----------------------------------------------

This framework is now more than powerful enough to allow us to rewrite the methods of a generic function as a single switch statement.  [Aside: This satisfies another of our general background goals, to be able to rewrite methods into a simpler in-line construct.]  If we have the following definitions

.. code-block:: text

    define g( Pattern ) => Expr enddefine;
    define override g( Pattern_1 ) => Expr_1 enddefine;
    define override g( Pattern_2 ) => Expr_2 enddefine;    

We can rewrite this as:

.. code-block:: text

    ### We require the match clauses to be ordered by generality
    define g( args... ) =>
        switch args...
        case Pattern_1 then Expr_1
        case Pattern_2 then Expr_2
        case Pattern then Expr
        else fail
        endswitch
    enddefine;

Summary: One-Way Unification
----------------------------

All of the changes discussed make structural pattern matching a very powerful tool.  However, it is still only a one-way unification.  As such it does not allow the creation of shared variables (aliases).  Nor does it permit Patterns to be used as first-class objects; they are restricted to appearing in a few static contexts.

.. code-block:: text

    Query   ::=     Pattern := Expr
            ::=     Pattern in Expr
            ::=     Pattern on Expr
            ::=     Pattern from Expr to Expr   ### and all relevant variants
            ::=     Query where Expr
            ::=     Query & Query

    Pattern ::=     Literal                     ### //x/
            ::=     _                           ### Shorthand for Any
            ::=     ...                         ### Shorthand for Any...
            ::=     Id                          ### Shorthand for Id : Any
            ::=     Id...                       ### Shorthand for Id : Any...
            ::=     Id : Type                   ### Required match        } see below!
            ::=     Id :- Type                  ### Dispatched match      }
            ::=     Pattern, Pattern            ### //AB/
            ::=     Pattern ~= Pattern
            ::=     Construction

    Construction 
            ::=     { Pattern }
            ::=     Expr( Pattern )
            ::=     Pattern . Expr
            ::=     Pattern . Expr( Pattern )
            ::=     Pattern @ Expr
            ::=     Pattern @ Expr Pattern

