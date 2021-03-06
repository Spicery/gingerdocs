﻿=======================================
The GSON Specification: Gingerised JSON
=======================================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Created, July 2011

Overview
--------

GSON is a strict superset of JSON that is convenient for writing GNX. It also incorporates the C-style comments of JSON-C and hence is also a strict extension of JSON-C. To find out more about JSON you can read this excellent website http://www.json.org/.

The purpose of GSON is twofold. Firstly it directly supports JSON expressions in Ginger. Secondly it is a more compact and friendly way of writing both MNX elements and GNX code. It can represent, in a natural way, any MNX element or GNX expression. 

In order to avoid clever encoding tricks, I added a few extensions to JSON to create MNX elements and GNX values. The main extension allows GSON to represent arbitrary MNX elements but there are several minor extensions to cover frequent patterns such as function application. 

Read the link:gson_background.html[Background to GSON] to learn more where it came from.

Tokenisation
------------

Because GSON supports comments, it is best to think of GSON having a separate tokenisation phase. GSON supports the following tokens:

* Double-quoted strings. JSON compatible.
* Numbers. JSON compatible.
* Names: These follow the same rules as XML names. 
* Signs: Single sign character (multiple-character signs are future expansion)

Both comments and inter-token white space are ignored.

Comments
~~~~~~~~

Comments may be inserted between tokens. Javascript style comments are supported, compatible with JSON-C. 

``//``  starts an end-of-line comment. 

``/* ... */`` are long comments that may cross several lines. They may not be nested.


Double-quoted String Tokens
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

    STRING ::= " CHAR* "
    CHAR 
            ::= any-Unicode-character-except-"-or-\-or-control-character
            ::= \" | \\ | \/ | \b | \f | \n | \r | \t | 
            ::= \u HEX**4
    HEX     ::= any-one-of 0123456789ABCDEF


Number Tokens
~~~~~~~~~~~~~

.. code-block:: text

    NUM     ::= INT FRAC? EXP?
    INT     ::= SIGN? DIGIT+
    SIGN    ::= any-one-of +-
    DIGIT   ::= any-one-of 0123456789
    FRAC    ::= . DIGIT*
    EXPR    ::= (+e+|+E+) SIGN? DIGIT+


Name Tokens
~~~~~~~~~~~

Names may contain essentially any alphanumeric character. This includes the standard English letters ``A`` through ``Z`` and ``a`` through ``z`` as well as the digits ``0`` through ``9``. XML names may also include non-English letters, numbers, and ideograms such as ``ö``, ``ç``, ``໓``, and ``他``. They may also include these three punctuation characters: the underscore ``_``, the hyphen ``-`` and the period ``.``.

Names may not contain other punctuation characters such as quotation marks, apostrophes, dollar signs, carets, percent symbols, semicolons or the colon. Names may not contain whitespace of any kind, whether a space, a carriage return, a line feed, a nonbreaking space, and so forth. 

Names may only start with letters, ideograms or the underscore character. They may not start with a number, hyphen or period. There is no limit to the length of a name. 

Sign Tokens
~~~~~~~~~~~

Sign tokens are made up from a single sign character. The permissible set of sign characters are:

    ``,:=<>()[]{}``

In the future, sign tokens may include multi-character signs.

Grammar
-------

The grammar is as follows. Note that JSON ``OBJECT`` is generalised to become a ``MAP``, corresponding to the Ginger map syntax, and that both ``:`` and ``=`` are acceptable ways of denoting a maplet within braces.

.. code-block:: text

    EXPR       ::= PRIMITIVE | COMPOUND
    PRIMITIVE  ::= STRING | NUMBER | VARIABLE
    VARIABLE   ::= NAME
    COMPOUND   ::= APPLY | SEQ | LAMBDA | ARRAY | MAP  | ELEMENT
    APPLY      ::= EXPR SEQ
    SEQ        ::= '(' EXPR, ... ')'
    ARRAY      ::= [ EXPR, ... ]
    LAMBDA     ::= NAME ATTRS SEQ? { EXPR, ... }
    MAP        ::= { ((EXPR : EXPR)|(NAME=EXPR)), ... }
    ELEMENT    ::= NAME ATTRS? ARRAY | NAME ATTRS
    ATTRS      ::= < ( NAME = STRING ), ... >


Variables
~~~~~~~~~

Variables are represented by standalone names. They will be translated into
the following GNX 

.. code-block:: text

    <id name="NAME">

.. tip:: Variables generalise JSON's ``true``, ``false`` and ``null``. This does mean that there is no direct support for literals in GSON. In the future all GNX named constants and functions may be given literal support e.g. ``#true``.

.. note:: In GNX, variables may have any name whatsoever. In the future we will have to support with this either by allowing escaped characters inside names or by allowing name quotation. The exact mechanism will be decided in the future.

Elements
~~~~~~~~

Elements have three parts: a *name*, an optional set of name=value *attributes*, and an optional list of *children*. Note that at least one of the two optional parts must be present (otherwise the name will be treated as a variable.)

These are transformed into a GNX element in the obvious way.

* The *name* becomes the name of the GNX element.
* The *attributes* become the attributes of the GNX element.
* The *children* are recursively transformed into GNX expressions and the results become the children of the GNX element. Order is preserved.
    
Example

.. code-block:: text

    if< declarative="true">[ flag1, 1, if[ flag2, 0, 1 ] ]
    
.. code-block:: xml

    <if declarative="true">
        <id name="flag1"/>
        <constant type="int" value="1"/>
        <if>
            <id name="flag2"/>
            <constant type="int" value="0"/>
            <constant type="int" value="1"/>
        </if>
    </if>

Sequences
~~~~~~~~~

A sequence of expressions enclosed in parentheses is automatically transformed into a GNX sequence.

* The result is a GNX element with name ``seq``.
* Each of the child expressions are transformed into GN expressions and
  added in order to the GNX element.

Example

.. code-block:: text

    ( 1, true, fn<>{} )
    
.. code-block:: xml

    <seq>
        <constant type="int" value="1"/>
        <id name="true"/>
        <fn>
            <seq/>
            <seq/>
        </fn>
    </seq>


Function Applications
~~~~~~~~~~~~~~~~~~~~~

Function applications are written in prefix form i.e. ``f(x)``. They are automatically transformed into GNX ``app`` elements.

Example

.. code-block:: text

    calculate_index( 1, true, [ "cat", "dog" ] )
    
.. code-block:: xml

    <app>
        <id name="calculate_index"/>
        <seq>
            <constant type="int" value="1"/>
            <id name="true"/>
            <list>
                <constant type="string" value="cat"/>
                <constant type="string" value="dog"/>
            </list>
        </seq>
    </app>

Lambda Functions
~~~~~~~~~~~~~~~~

Lambda functions have a short syntax. In GNX they are an element with the name ``fn``, possibly some attributes, and two children that are a pattern element and an expression element respectively. It is reasonably simple to write this out in full, simply using GSON element syntax - but it can be a little clumsy in GSON.

Here's an example of a lambda function that simply swaps its arguments. 

.. code-block:: text

    fn[ ( x, y ), ( y, x ) ]

The short form uses "naked" attributes, such as +<>+ or +<name="swap">+ followed by an argument-list in paretheses then followed by an expression-list in braces. 

.. code-block:: text

    <>( x, y ){ y, x }

.. code-block:: xml

    <fn>
        <seq>
            <id name="x"/>
            <id name="y"/>
        </seq>
        <seq>
            <id name="y"/>
            <id name="x"/>
        </seq>
    </fn>   


The argument-lists may be omitted altogether. In this case the argument-list is assumed to be ``()``.

.. code-block:: text

    <>{ f(), g() }

.. code-block:: xml

    <fn>
        <seq/>
        <seq>
            <app>
                <id name="f"/>
                <seq/>
            </app>
            <app>
                <id name="g"/>
                <seq/>
            </app>
        </seq>
    </fn>   


The argument-lists may be repeated, to express curry'd lambda expressions. Here's the K combinator as an example.


.. code-block:: text

    < name="K" >( x )( y ){ x }

.. code-block:: xml

    <fn>
        <seq>
            <id name="x"/>
            <id name="y"/>
        </seq>
        <seq>
            <id name="y"/>
            <id name="x"/>
        </seq>
    </fn>


Extended Example
----------------

As an example, consider the following Ginger expression:

.. code-block:: common

    define andThen( f, g ) => 
        fn () => f(); g() endfn 
    enddefine;

This will expand into the following fairly unreadable GNX code.

.. code-block:: xml

    <bind>
        <var name="andThen" protected="true"/>
        <fn name="andThen">
            <seq>
                <var name="f"/>
                <var name="g"/>
            </seq>
            <fn>
                <seq/>
                <seq>
                    <app>
                        <id name="f"/>
                        <seq/>
                    </app>
                    <app>
                        <id name="g"/>
                        <seq/>
                    </app>
                </seq>
            </fn>
        </fn>
    </bind>


In GSON, it appears as shown below. As you can see, GSON is just as machine friendly as GNX but more compact and more readable.

.. code-block:: text

    bind[
        var< name="andThen", protected="true" >,
        fn< name="andThen" >( f, g ){ fn<>(){ f(), g() } }
    ]


