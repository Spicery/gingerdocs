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

    * `Pervasive multiple values`_, including loop expressions.
    * `Dynamic type checking`_ 
    * `Full arithmetic`_, supporting integers, big integers, rationals and doubles.
    * `Immutable objects`_ - strings, lists vectors and maps.
    * `XML like elements`_ built-in (immutable only).
    * User-defined `records`_ and `vectors`_.
    * `First class functions`_ and `lambda expressions`_ with full lexical binding.
    * `Basic CGI integration`_.
    * `Garbage Collection`_ with weak references, weak maps and file closing.
    * `Syntax Neutral`_ with two available front-end syntaxes so far.
    * `Multiple Implementations of Single Instruction Set`_

.. _`Pervasive multiple values`: help/multiple_values.html
.. _`Dynamic type checking`: help/type_checking.html
.. _`Full arithmetic`: help/mahs.html
.. _`Immutable objects`: help/quality_immutable.html
.. _`XML like elements`: help/elements.html
.. _`records`: help/record_classes.html#user-defined-record-classes
.. _`vectors`: help/vector_classes.html#user-defined-vector-classes
.. _`First class functions`: help/first_class_functions.html
.. _`lambda expressions`: help/lambdas.html
.. _`Basic CGI integration`: help/cgi.html
.. _`Garbage Collection`: help/garbage_collection.html
.. _`Syntax Neutral`: design/syntax_neutral.html
.. _`Multiple Implementations of Single Instruction Set`: design/multiple_implementations.html


Further, Planned Features
-------------------------

The Ginger project has an extensive roadmap that reflects our ambitions for it as a language. Here are some of the key features from the project roadmap that are not yet available. By and large most of these features are designed but require implementation. n.b. If there's a particular feature of interest to you, let us know.

    * Regular expressions and supporting syntax.
    * `Pattern Matching`_ used pervasively to implement binding and smart loops.
    * `Enhancements to the Garbage Collector`_ 
    * `Dynamically Create New Virtual Machines`_ as first class objects.
    * `Implicit Force`_
    * Complex numbers.
    * `Immutable`_, `updateable`_, and `dynamic`_ strings, lists, vectors, elements and maps.
    * `Optional static typing`_, consistent with the Dollin principle.
    * Full object-oriented programming model with multiple inheritance and multiple dispatch.
    * Coroutines as first class objects.
    * Keyword parameters with default values.
    * Partial application.
    * Auto-loading and auto-importing.
    * Updaters and deconstructors.
    * Advanced exception handling model with Alternative returns, Rollbacks, Failovers and Panics.
    * An additional Lisp-based front-end syntax.
    * Two further important built-in types: bags and priority queues
    * Full CGI Integration.
    * Full Unicode integration.
    
.. _`Pattern Matching`: help/pattern_matching.html
.. _`Enhancements to the Garbage Collector`: help/garbage_collection.html#enhancements-to-the-garbage-collector
.. _`Dynamically Create New Virtual Machines`: help/dynamic_vms.html
.. _`Implicit Force`: help/implicit_force.html
.. _`Immutable`: help/quality_immutable.html
.. _`updateable`: help/quality_updateable.html
.. _`dynamic`: help/quality_dynamic.html
.. _`Full dynamic arithmetic`: help/arithmetic.html#full-arithmetic-model
.. _`Optional static typing`: help/type_checking.html#optional-static-type-checking

Development Status
------------------

  * Linux and Mac OS X, 64 & 32-bit versions of all 4 engines.
  * Common-syntax and C-style syntax front ends.
  * Basic function definitions & 1st class functions.
  * Conditions and short-circuit operators.
  * Basic for loops.
  * Dynamic integer and double arithmetic & relational operators.
  * Primitive values (booleans, absent, Unicode characters).
  * Strings (8-bit only).
  * Lists, vectors, elements and maps (weak/hard, identity/equality).
  * Basic stream-based i/o working and integrated with garbage collector.
  * Garbage collector, includes weak refs and weak maps.
  * Basic packages working.
  * Full lexical binding, higher order functions.

