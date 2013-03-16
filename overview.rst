==================
Overview of Ginger
==================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Background
----------

Ginger is our next evolution of the Spice project. Ginger itself is a intended to be a rigorous but friendly programming language and toolset. It includes a syntax-neutral programming language, a virtual machine implemented in C++ that is designed to support the family of Spice language efficiently, and a collection of supporting tools.

Spice has many features that are challenging to support efficiently in existing virtual machines: pervasive multiple values, multiple-dispatch, multiple-inheritance, auto-loading and auto-conversion, dynamic virtual machines, implicit forcing and last but not least fully dynamic typing.

The virtual machine is a re-engineering of a prototype interpreter that I wrote on holiday while I was experimenting with GCC's support for FORTH-like threaded interpreters. But the toolset is designed so that writing alternative VM implementations is quite straightforward - and we hope to exploit that to enable embedding Ginger into lots of other systems.


Special Features of the Ginger Language and Tools
-------------------------------------------------

Syntax Neutral
~~~~~~~~~~~~~~

Apart from performance, one of the interesting aspects of the virtual machine is that the input is an easy-to-generate subset of XML. For example the equivalent of Pop-11's ``if f( 0 ) then p else q endif( false )`` would be:

.. code-block:: xml

    <app>
       <if>
             <app>
                 <id name="f" />
                <int value="0" />
            </app>
            <id name="p" />
            <id name="q" />
        </if>
        <bool value="false" />
    </app>

The aim is to make the choice of programming syntax a personal decision and making the interpreter language neutral is one step towards that. [Status: done]

Pattern Matching
~~~~~~~~~~~~~~~~
Another interesting part of the work is that we have designed the XML to elegantly support the concept of initialisation-as-pattern matching. In this approach, variable declarations turn out to be matches which evaluate to the first match and for-loops are iterators over all possible matches. It is rather pretty. [Status: designed, implementation in progress]

Dynamically Create New Virtual Machines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
On the drawing board is the ability to create new virtual machines as a dynamic object that can be manipulated. The aim is to have all the power of reflection without any of the dirtiness. The programmer will be able to create new virtual machines (e.g. ``var vm = newVM()`` ), load code into them, run them at full speed, manage exceptions and even single step them (different virtual machines can use different interpreters). [Status: planned]

Implicit Force
~~~~~~~~~~~~~~
Lastly, we intend to build in support for explicit-delays with implicit-forcing. This is a more general version of pdtolist. The basic idea is that you can _delay_ an expression by surrounding it with delay-brackets e.g. ``delay EXPR enddelay``. The effect is that this ``EXPR`` is bundled up inside a procedure but executed on demand i.e. when the runtime system attempts to determine its runtime-type. 

Fairly obviously this needs pervasive support at the lowest level. I have implemented this once before (in JSpice) and so have reasonable expectations that it can be implemented in such a way that there is no impact when it is not used. That means it is an affordable technique to include. [Status: planned]

One Logical Instruction Set, Multiple Implementations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The virtual machine has a single CISC-style instruction set. Each instruction consists of an instruction-word followed by zero-or-more data words (words are the size of a long int). However there are three quite different implementations of the core engine with differing performance/portability tradeoffs. Adding new implementations is relatively simple e.g. the planned debugger will be implemented by an engine which allows hooks to be inserted into the code. [Status: done]

Development Status (Immature!)
------------------------------

  * Runs on 64 & 32 bit machines, all 3 engines
  * Common-syntax to Ginger XML front end
  * Basic function definitions & 1st class functions
  * Conditions and short-circuit operators
  * Basic for loops
  * Relational operators for small integers
  * Small integer arithmetic (only)
  * Primitive values (booleans, absent, Unicode characters)
  * Strings (8-bit only)
  * Lists and vectors
  * No classes
  * Garbage collector implemented, includes weak refs and weak maps.
  * Basic packages working
  * Full lexical binding

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
