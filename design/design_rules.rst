Design Rules for the Spice Programming Language
===============================================

This is an attempt to articulate the design rules that we have employed in the development of the Spice language.  The rules are more like guidelines than laws, as spelt out in the ../MetaDesignRules.

One Rule to Rule Them All
-------------------------

  * Standards are local not global. By this we mean that standards are based on
    consensus and that individuals and teams must be free to depart from the
    common basis without incurring an impractical management penalty. 

General
-------

  * Compositionality - is the grand theme of Spice.  As much as possible we want to be able to   build large units by sticking together small units.  This applies to functions, classes, packages and everything else.
  
  * Restriction - when restrictions are introduced into the language, it should be possible to relax them without altering the meaning of programs (e.g. the early discussion of semi-colon elected to demand zero-results and not automatically force zero-results)
  
  * No overloading of procedures.  

  * System procedures have no magic features that user procedures cannot duplicate.  All system features are packaged so that a programmer can make use of them separately - not as part of some pre-determined task.
  
  * Patterns should be complete.  We strive to fit language features into memorable patterns and wherever we start a pattern we strive to complete it.
  
  * Access is never forbidden, merely requires explicit permission (because the programmer is in charge).
  
  * Defaults always give the weakest capabilities (e.g. assignability must be explicitly requested.)  Capabilities are not access rights but semantic features.  Where a capability is not requested, the programmer is implicitly offering the compiler the freedom to exploit the absence of  the capability. 

  * Simplify complexity, not trivialise simplicity.  We seek to turn the difficult into straightforward rather than turning the simple into the trivial.  Some programming languages have focused too hard on improving the power of expression for simple task.  In striving to simplify the trivial, they introduce rules "for programmer convenience" that compromise more complex tasks.  For example, some scripting languages automatically convert strings to numbers when performing arithmetic - but this compromises type security.
  
  * If one, why not many?  We strive to generalize features to support multiplicity - multiple values, multiple inheritance, multiple dispatch, multiple threads of execution, etc.
  
  * Symmetry - nothing should be distinguished or priveged without extraordinary justification

  * Features shouldn't come with a safety manual.  ("Gotcha-free")
  
  * Feature orthognality is emphasized e.g. mutable numbers

  * Safe, Robust, Defended - Spice has a robust run-time system and safe libraries.  Classes are designed to be correct in preference to fast or compact.

  * We believe that Java sets the new benchmark for language design - Spice must step up to this mark everywhere.  

  * Where convenient, Spice incorporates means for including constants written in other widespread notations.


Spice Programmers
-----------------

  * The programmer is always in charge.

  * Spice is suitable for occasional programmers.  An occasional programmer is one who has big breaks between their programming work.  So they might be students, web site builders, part-time workers, or full-time programmers with a different main programming language.
  
  * Spice is scaleable for team programming.
  


Syntax
------

  * On readability
      * Readability is a goal.
      * Terseness is not a goal but is welcome.
      * We are comfortable with a degree of verbosity - but excessive verbosity is unwelcome.
  
  * We expect that Spice will have multiple concrete syntaxes.  Although there will be a common syntax (the word 'standard' should be avoided) this does not imply that it has any greater recognition.  Some of these syntaxes will be general and able to express arbitrary programs, others will be special purpose and very limited.

  * Pre-existing external formats such as CSV, XML, GIF, JPEG and so on will be given standard (or default) loaders.  This mechanism allows the Spice programmer to treat these external formats as another way to write named constants.
  
  * We will define an AbstractSyntaxTree & its mapping to an XML transport format.
  
  * The common syntax will support programming in the ASCII character set by default but will include Unicode alternatives.  We see the Unicode alternatives as the prefered option and when writing in Unicode becomes commonplace we may deprecate the ASCII versions.  A Spice IDE should support Unicode.

  * The common syntax employs the usual reserved word strategy to distinguish special keywords from ordinary identifiers.  However, we see that as a convention for programming without text styling.  It is preferable to distinguish reserved words by their styling.  A Spice IDE should support styling.

  * Reserved words will '''never''' be one alphabetic character long.  Programmers should not use identifiers that are prefixed by "_" as these are all reserved for future use.

  * No overloading of tokens.

  * the "common core concrete syntax".
  
  * macro capability for common syntax.

  * Syntax for literal objects generates immutable run-time objects.  This means that the programmer can be assured that literal syntax remains true throughout a program run.  It also follows the rule of fewest capabilities.

  * Where it does not conflict with other more pressing concerns, the common syntax shall borrow from other programming languages in order to reduce the effort of cross-training.

Semantics
---------
  
  * Evaluation order 
      * is specified;
      * should follow reading order (left-to-right) as much as practical.


Type Checking
-------------

  * A true type assertion will never prevent a program from compiling (the DesignNotes/DollinPrinciple)

  * An OpenSpice implementation is not ''required'' to do any type checking.  Of course, one that omits type checking would be omitting a chunk of important and useful functionality.  But it would be a perfectly viable implementation.

Compilation and Performance
---------------------------
	
  * We aim to be macro-efficient rather than micro-efficient.  We are only mildly interested in benchmarks that test how efficient code generation is on the small scale.  We are much more interested in the performance of garbage collection, coroutine switching, etc.
  
  * Performance enhancing assertions are either checked at compile-time or there is an option to check them at run-time which is, by default, enforced.
  
  * We aim to be in the compilation sweet spot of simplicity versus performance.  We believe that this sweet spot exists.

  * Features that are potentially expensive to implement, such as multiple dispatch, are more acceptable if the programmer only incurs the penalty for using the feature (or using libraries that use the feature).

  * The target execution environment is the desktop computer.

  
Interactive Development Environment (IDE)
-----------------------------------------

  * Spice IDE warns but does not obstruct (because the programmer is in charge).

  * A type-error will not lead to an interaction that forces a programmer to correct it before proceeding to debugging.

  * Top-level definitions may appear in packages according to the programmer's organisational principles and not implementation concepts such as the class hiearchy.

  * The programmer is in charge

  * The programmer cannot legitimately expect capabilities to be added on demand - the compiler is free to assume it knows the full range of capabilities and only supply the minute set needed.  For example, when the compiler sees val x = 99 it is under no obligation to allocate store to represent x!!  As a consequence, the programmer is not able to force an assignment without a recompilation.

  * A Spice IDE should support Unicode and text styling as per the aims of the common syntax.

  * It must be easy to program Spice without an IDE.
