%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
The Design Principles for the  :mod:`Ginger`  Language, Interpreter and Virtual Machine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Design Rules for the  :mod:`Ginger`  Programming Language
=========================================================

This is an attempt to articulate the design rules that we have 
employed in the development of the :mod:`Ginger` language. 
The rules are guidelines, not laws. Wherever we can, rules should 
be phrased both positively and negatively. 

General
--------

* Compositionality - is the grand theme of :mod:`Ginger`. 
  As much as possible we want to be able to build large units by 
  sticking together small units. This applies to functions, 
  classes, packages and everything else. 

* Restriction - when restrictions are introduced into the language, 
  it should be possible to relax them without altering the meaning 
  of existing programs (e.g. the early discussion of semi-colon elected 
  to demand zero-results and not automatically force zero-results, 
  which meant when we relaxed that rule everything carried on 
  working.) 

* Library code has no magic features that user procedures 
  cannot duplicate. 

* All features are packaged so that 
  a programmer can make use of them separately - not as part of 
  some pre-determined task. 

* Patterns in language and library features should be complete. We strive 
  to fit features into memorable patterns and wherever we 
  start a pattern we strive to complete it. Omissions are treated 
  as breaking the pattern and we hate breaking patterns. 

* Access is never forbidden, it merely 
  requires explicit permission. The key principle is that the 
  the programmer is in charge of the virtual machine (but their 
  decisions are published and can be vetoed by users.) 

* Defaults always give the weakest capabilities (e.g. assignability 
  must be explicitly requested.) Capabilities are not access 
  rights but semantic features. Where a capability is not requested, 
  the programmer is implicitly offering the compiler the freedom 
  to exploit the absence of the capability. 

* Simplify complexity, not trivialise simplicity. We seek 
  to turn the difficult into straightforward rather than turning 
  the simple into the trivial. Some programming languages have 
  focused too hard on improving the power of expression for simple 
  task. In striving to simplify the trivial, they introduce 
  rules "for programmer convenience" that compromise more 
  complex tasks. For example, some scripting languages automatically 
  convert strings to numbers when performing arithmetic - but 
  we see this as a pointless micro-convenience that 
  just makes it harder to write large, robust programs.

* We say “If one, why not many?” We strive to generalize features 
  to support multiplicity; multiple values, multiple inheritance, 
  multiple dispatch, multiple threads of execution, etc. 

* Symmetry - nothing should be distinguished or privileged 
  without extraordinary justification.

* Features shouldn't come with a safety manual. ("Gotcha-free") 

* Feature orthogonality is emphasized e.g. mutable numbers. 
  Exceptions to the design are rejected. 

* Safe, Robust, Defended - :mod:`Ginger` has a robust 
  run-time system and safe libraries. Classes are designed 
  to be correct in preference to fast or compact. (We would like 
  them to be fast and compact too. But we won't compromise robustness.) 

* We believe that Java sets the new benchmark for language design 
  - :mod:`Ginger` must step up to this mark everywhere. 

* Where convenient, :mod:`Ginger` incorporates means 
  for including constants written in other widespread notations. 

* :mod:`Ginger` is not about preventing access but preventing 
  accidents. 

* Big but friendly! Feels much smaller than it actually is because 
  of its strong regularity. 



:mod:`Ginger`  Programmers
---------------------------

* The programmer is always in charge - not the IDE. 

* :mod:`Ginger` is suitable for occasional programmers. 
  An occasional programmer is one who has big breaks between 
  their programming work. So they might be students, web site 
  builders, part-time workers, or full-time programmers with 
  a different main programming language. 

  We want :mod:`Ginger` to be the language people turn to for
  their own projects. We call this being their "other" programming
  language. We believe this is the most sincere form of appreciation
  and its our passionate goal.

* :mod:`Ginger` is scaleable for team programming. 



Variable Names and Package Names
--------------------------------

* Variable names are sequences of Unicode characters of arbitrary 
  length. In particular there are no reserved words in the abstract 
  language, only in concrete syntaxes. Therefore all concrete 
  syntaxes must support names being arbitrary Unicode strings. 

* Variable names are not overloaded. In particular, no overloading 
  of procedures is allowed. (In this context, overloading means 
  that a single name in a single lexical context could denote 
  two different variables.) 

* The programmer is free to name variables and packages as they 
  please because they are in charge. If there are relationships 
  between variables or packages in the language, they cannot 
  be implied by a naming convention. 
  (The programmer is free to do otherwise, of course. They are 
  in charge.) This implies that the suggested convention for 
  "fast" packages is wrong. 



Syntax-Agnostic and Data File Formats
-------------------------------------

* We want :mod:`Ginger` to have multiple concrete syntaxes. 
  Some of our programmers will be programming regularly in a 
  different “primary” language and we want them to feel welcome 
  when they pick up :mod:`Ginger` . 

* Although there will be a Common syntax (the word 'standard' 
  must be shunned) this must not imply that it has any special 
  privilege. The name “Common” is chosen to suggest friendliness 
  and shared ownership and the word “standard” must be firmly 
  avoided – along with any attempt to give it a special role. Some 
  of these syntaxes will be general and able to express arbitrary 
  programs, others will be special purpose and very limited. 

* Pre-existing external formats such as CSV, XML, GIF, JPEG 
  and so on will be given standard (or default) loaders. This 
  mechanism allows the :mod:`Ginger` programmer to 
  treat these external formats as another way to write named 
  constants. 

* We will define an AbstractSyntaxTree & its mapping to an XML 
  transport format. 


Common Syntax
--------------

Some of our programmers will be students and not have a strong 
preference for a particular style of syntax. Some of our experienced 
programmers will be looking for a syntax that is neither a crash 
of symbols nor a tedious exercise in form-filling. We think the 
Common syntax may be for them. 

Common is a modern syntax designed to be memorable, consistent, 
readable and resilient against common mistakes. For example, 
languages with the fragile C/Java syntax are vulnerable to the 
following common mistake. 

.. code-block:: text

    if ( this.test() )   
        this.FirstThing();  
        this.SecondThing();    // Supposed to be inside the if.

Common guards against this mistake by arranging that keywords 
such as `if` have their textual scope delimited by a matching 
closing keyword – in this case `endif`. This is how it might look 
in Common. 

.. code-block:: common

    if this.test() then          // Cryptic brackets replaced by "then"  
        this.FirstThing();  
        this.SecondThing();      // Much harder to make the mistake.  
    endif;

Here's a list of our goals. 

* Readability is a goal. 

* Terseness is not a goal but is welcome. 

* We are comfortable with a degree of verbosity - but excessive 
  verbosity is unwelcome. 

* Reserved words will never be one alphabetic character long. 

* No overloading of tokens. 

* Macro capability for standard syntax. 

* Syntax for literal objects generates immutable run-time 
  objects. This means that the programmer can be assured that 
  literal syntax remains true throughout a program run. It also 
  follows the rule of fewest capabilities. 

* Where it does not conflict with other more pressing concerns, 
  the common syntax shall borrow from other programming languages 
  in order to reduce the effort of cross-training. 

* The common syntax employs the usual reserved word strategy 
  to distinguish special keywords from ordinary identifiers. 
  However, we see that as a convention for programming without 
  text styling. It is preferable to distinguish reserved words 
  by their styling. A :mod:`Ginger` IDE should support 
  styling. 

* Common: The common syntax will support programming in the 
  ASCII character set by default but will include Unicode alternatives. 
  We see the Unicode alternatives as the preferred option and 
  when writing in Unicode becomes commonplace we may deprecate 
  the ASCII versions. A :mod:`Ginger` IDE should support 
  Unicode. 


Semantics
---------

* Evaluation order is specified 

* Evaluation should follow reading order (left-to-right) 
  as much as practical. 

Type Checking
-------------
* A valid type assertion will never prevent a program from compiling 
  (`the Dollin Principle`_). 

* An :mod:`Ginger` implementation is not ''required'' 
  to do any type checking. Of course, one that omits type checking 
  would be omitting a chunk of important and useful functionality. 
  But it would be a perfectly viable implementation. 

* A :mod:`Ginger` implementation is not ''required'' 
  to perform any type inference. 

.. _`the Dollin Principle`: the_dollin_principle.html

Compilation and Performance
---------------------------

* We aim to be macro-efficient rather than micro-efficient. 
  We are only mildly interested in benchmarks that test how efficient 
  code generation is on the small scale. We are much more interested 
  in the performance of garbage collection, coroutine switching, 
  etc. 

* Performance enhancing assertions are either checked at compile-time 
  or there is an option to check them at run-time which is, by default, 
  enforced. 

* We aim to be in the compilation sweet spot of simplicity versus 
  performance. We believe that this sweet spot exists. 

* Features that are potentially expensive to implement, such 
  as multiple dispatch, are more acceptable if the programmer 
  only incurs the penalty for using the feature (or using libraries 
  that use the feature). 

* The target execution environment is the desktop computer. 

Interactive Development Environment (IDE)
------------------------------------------

* The programmer is in charge. 

* :mod:`Ginger` IDE may warn but may not obstruct (which 
  is one of the things we we mean by the programmer being in charge). 

* A type-error detected at compile-time will not lead to an interaction 
  that forces a programmer to correct it before proceeding to 
  running and debugging. 

* Top-level definitions may appear in packages according to 
  the programmer's organisational principles and not implementation 
  concepts such as the class hierarchy. 

* The compiler is free to assume it knows the full range of capabilities 
  and only supply the minimum set needed. 
  So the programmer cannot legitimately expect capabilities 
  to be dynamically added on demand. For example, when the compiler 
  sees ``val x := 99`` it is under no obligation to allocate store to 
  represent ``x``!! As a consequence, the programmer is not able 
  to force an assignment without a recompilation. 

* A :mod:`Ginger` IDE should support Unicode and text 
  styling as per the aims of the Common syntax. 

* It must be easy and practical to program :mod:`Ginger` 
  without an IDE. 
