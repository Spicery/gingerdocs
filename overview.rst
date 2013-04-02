==================
Overview of Ginger
==================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Background
----------

Ginger is our next evolution of the Spice project. Ginger itself is a intended to be a rigorous but friendly programming language and supporting toolset. It includes a syntax-neutral programming language, a virtual machine implemented in C++ that is designed to support the family of Spice language efficiently, and a collection of supporting tools.

Spice has many features that are challenging to support efficiently in existing virtual machines: pervasive multiple values, multiple-dispatch, multiple-inheritance, auto-loading and auto-conversion, dynamic virtual machines, implicit forcing and last but not least fully dynamic typing.

The virtual machine is a re-engineering of a prototype interpreter that I wrote on holiday while I was experimenting with GCC's support for FORTH-like threaded interpreters. But the toolset is designed so that writing alternative VM implementations is quite straightforward - and we hope to exploit that to enable embedding Ginger into lots of other systems.


Features of the Ginger Language and Tools
-----------------------------------------

Here's a list of the features we have already implemented for the GVM project.

    * Pervasive multiple values, including loop expressions.
    * Dynamically typed values.
    * Dynamic arithmetic, supporting integers and doubles.
    * Immutable strings, list, vectors and maps.
    * XML-like elements built-in (immutable only).
    * User-defined records and vectors.
    * First class functions and lambda expressions with full lexical binding.
    * `Garbage Collection`_ with weak references, weak maps and file closing.
    * `Syntax Neutral`_ with two available front-end syntaxes so far.
    * `Multiple Implementations of Single Instruction Set`_

.. _`Garbage Collection`: garbage_collection.html
.. _`Syntax Neutral`: syntax_neutral.html
.. _`Multiple Implementations of Single Instruction Set`: multiple_implementations.html


Further, Planned Features
-------------------------

The Ginger project has an extensive roadmap that reflects our ambitions for it as a language. Here are some of the key features from the project roadmap that are not yet available. By and large most of these features are designed but require implementation. n.b. If there's a particular feature of interest to you, let us know.

    * `Pattern Matching`_ used pervasively to implement binding and smart loops.
    * `Enhancements to the Garbage Collector`_ 
    * `Dynamically Create New Virtual Machines`_
    * `Implicit Force`_
    * Full dynamic arithmetic, supporting bignums, rationals and complex numbers.
    * `Immutable`_, `updateable`_, and `dynamic`_ strings, lists, vectors, elements and maps.
    * Optional static typing, consistent with the Dollin principle.
    * Multiple inheritance.
    * Multiple dispatch.

.. _`Pattern Matching`: pattern_matching.html
.. _`Enhancements to the Garbage Collector`: garbage_collection.html#enhancements-to-the-garbage-collector
.. _`Dynamically Create New Virtual Machines`: dynamic_vms.html
.. _`Implicit Force`: implicit_force.html
.. _`Immutable`: quality_immutable.html
.. _`updateable`: quality_updateable.html
.. _`dynamic`: quality_dynamic.html


Development Status (Immature!)
------------------------------

  * Linux and Mac OS X, 64 & 32-bit versions of all 4 engines.
  * Common-syntax and C-style syntax front ends.
  * Basic function definitions & 1st class functions.
  * Conditions and short-circuit operators.
  * Basic for loops.
  * Dynamic integer and double arithmetic & relational operators.
  * Primitive values (booleans, absent, Unicode characters).
  * Strings (8-bit only).
  * Lists, vectors, elements and maps (weak/hard, identity/equality).
  * Garbage collector implemented, includes weak refs and weak maps.
  * Basic packages working
  * Full lexical binding, higher order functions.

Recent News
-----------

The main change over the past week have been the addition of lists and vectors, adding the framework for functional tests, basic for loops and a nice feature for showing the VM code for a function. The implementation of lists and vectors got refactored this weekend so that the C++ code is automagically generated (using Java).

The system is now robust enough to compile and execute naïve reverse. Here's the code in the Common syntax. The ``.`` and ``@`` operator just turn the next word into an infix operator.

.. code-block:: common

    define append( x, y ) =>
        if x.isPair then
            x.head @newPair append( x.tail, y )
        else
            y
        endif
    enddefine;

    define nreverse( x ) =>
        if x.isPair then
            x.tail.nreverse @append [x.head ]
        else
            []
        endif
    enddefine;

    [ 1, 2, 3, 4, 5 ].nreverse;


When translated to Ginger XML it looks like this - and yes I know commas are handled badly! :)

.. code-block:: xml

    <dec>
        <var name="append" protected="true" />
        <fn name="append">
            <seq>
                <var name="x" /><var name="y" />
            </seq>
            <if>
                <sysapp name="isPair">
                    <seq>
                        <id name="x" />
                    </seq>
                </sysapp>
                <sysapp name="newPair">
                    <seq>
                        <sysapp name="head">
                            <seq>
                                <id name="x" />
                            </seq>
                        </sysapp>
                        <app>
                            <id name="append" />
                            <seq>
                                <sysapp name="tail">
                                    <seq>
                                        <id name="x" />
                                    </seq>
                                </sysapp>
                                <id name="y" />
                            </seq>
                        </app>
                    </seq>
                </sysapp>
                <id name="y" />
            </if>
        </fn>
    </dec>


    <dec>
        <var name="nreverse" protected="true" />
        <fn name="nreverse">
            <seq>
                <var name="x" />
            </seq>
            <if>
                <sysapp name="isPair">
                    <seq>
                        <id name="x" />
                    </seq>
                </sysapp>
                <app>
                    <id name="append" />
                    <seq>
                        <app>
                            <id name="nreverse" />
                            <seq>
                                <sysapp name="tail">
                                    <seq>
                                        <id name="x" />
                                    </seq>
                                </sysapp>
                            </seq>
                        </app>
                        <sysapp name="newList">
                            <sysapp name="head">
                                <seq>
                                    <id name="x" />
                                </seq>
                            </sysapp>
                        </sysapp>
                    </seq>
                </app>
                <sysapp name="newList">
                    <seq />
                </sysapp>
            </if>
        </fn>
    </dec>

    <app>
        <id name="nreverse" />
        <seq>
            <sysapp name="newList">
                <seq>
                    <seq>
                        <seq>
                            <seq>
                                <int value="1" />
                                <int value="2" />
                            </seq>
                            <int value="3" />
                        </seq>
                        <int value="4" />
                    </seq>
                    <int value="5" />
                </seq>
            </sysapp>
        </seq>
    </app>


As one expects, the result is as follows (using engine#1):

.. code-block:: text

    There is 1 result   (4.3e-05s)
    1.  [5,4,3,2,1]

The code generated isn't terribly good I have to admit.  Here's the code dump for append - the strange values after syscalls are addressed of the raw C++ code. 25 instructions is poor. As the comments indicate, the code quality will improve dramatically when the arity analysis is enabled. Branch-chaining will probably come first and will deliver a minor improvement (but will include TCO).

.. code-block:: text

    define: 0 args, 6 locals, 0 results, 49 #words used
    [1] enter 
    [2] start 2 <- arity analysis not implemented yet
    [4] start 3 <- ditto
    [6] push_local0 
    [7] set 3 <- ditto
    [9] syscall 4295108918 
    [11]    check1 2 <- ditto
    [13]    ifnot 29 
    [15]    start 2 <- ditto
    [17]    start 3 <- ditto
    [19]    push_local0 
    [20]    set 3 <- ditto
    [22]    syscall 4295108249 
    [24]    start 4 <- ditto
    [26]    start 5 <- ditto
    [28]    push_local0 
    [29]    set 5 <- ditto
    [31]    syscall 4295107580 
    [33]    push_local1 
    [34]    end_call_global 4 append 
    [37]    set 2 <- ditto
    [39]    syscall 4295110249 
    [41]    goto 2 <- branch-chaining not implemented yet
    [43]    push_local1 
    [44]    return 
    enddefine
