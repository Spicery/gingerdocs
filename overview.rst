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

