Ginger - Frequently Asked Questions List
========================================

**Completely out of date! TODO!**

What is Ginger?
---------------

It is a modern, general purpose language that is friendly enough for occasional programmers but powerful enough for professionals.  In terms of similarity, the most influential language design efforts are Pop11, Java, and CLOS.  Ginger is planned to be a large programming language that feels small and friendly because of its very regular and consistent design.

Why invent a new language?
--------------------------


The short answer: because programming should be easier and much more fun than it is.

The longer answer: Today's popular programming languages, like C++ and Java, are insanely complicated and full of inconsistencies.  Competence in these languages takes dedication and is really only available to the full-time professional programmer.  As a rule they are hopelessly unsuitable for people who need to program every now and then - occasional programmers such as mathematicians, scientists, historians, linguists, economists, and students - not to mention industry related categories such as project managers, website developers, database programmers, graphic designers, and so on.  And there has been a plethora of special purpose languages to meet the needs of these different occupations.

But these special purpose languages are typically very limited.  They offer these occasional programmer no continuous learning opportunity or any route to general purpose programming.  They make merry with exotic, uncontrollable features such as string evaluation or dynamic name resolution in the pursuit of mundane effects.  And they lack the basic features needed for team programming.

Ginger is a programming language for occasional programmers without those limitations.  It has to be easy to pick up and easy to resume after a long break.  It has to have plenty of scope for growth without becoming intimidating.  And it has to be suitable for team programming.

In a nutshell, Ginger is a programming language for the rest of us.  In pursuit of this lofty goal we have raided the best programming languages in the world and tried to:

  * cleanly separate all features and reflect this in the syntax
  * only add features that work together absolutely seamlessly
  * always unify of similar concepts using umbrella concepts
  * fanatically eliminate ambiguities, inconsistencies and infelicities

The concrete answer: The Palantir project needs a special type of programming language.  (I'll get around to describing Palantir later, honest!)  In Palantir, the use of embedded XML is a fundamental technique but only works if the language supports multiple results, garbage collection, and dynamic typing.  Additionally the package system and automatic importing are both required to make working with a programmatic web site as easy as working with a file based site.  The only well-known language that comes close to these requirements is Common Lisp.  This falls short in many of our overall design goals, such as friendliness for occasional programmers and its multiple result feature is much too cumbersome for our needs.  But implementing Ginger as a relatively thin layer on top of Common Lisp would be a good idea.


What features does it have?
---------------------------

 * Interactive, incremental compiler
 * Dynamic typing with optional static typing
 * Garbage collection integrated with resource management
 * Simple and elegant package system is exclusive means for managing name spaces
 * Object-oriented with multiple inheritance, multiple dispatch and "free-standing" method definitions
 * Functions and methods are completely unified and are "first-class" values
 * Functional programming supported by lambda abstraction, function parameters and tail-call optimization
 * An XML-based syntax for transport and exchange
 * Several friendly syntaxes for programming
 * Easy-to-use multiple results from expressions
 * Embeddable XML start and end tags to simplify constructing XML trees which have an efficient implementation and elegant specification
 * Automatic importing of external formats into objects
 * Assignment-once local variables commonly used as default
 * Updaters and ident support abstraction over updating

Which other programming languages is it like?
---------------------------------------------

In terms of similarity, the most influential language design efforts are Pop-11, ["Java"], ML, and the awesome Common Lisp Object System (CLOS).  It is a pleasure to acknowledge these works:

Fired up by Pop-11 we were shown
  * that programming with multiple values is controllable and essential
  * how a single unified namespace is neccesary, practical and efficient
  * how to do arithmetic (which Pop-11 learned from Common Lisp)
  * the crucial significance of hash tables and their garbage collection issues
  * the merits of programming with couroutines
  * that higher-order programming can be approachable for occasional programmers
  * the correct way to implement full lexical binding
  * the right way to manage overloading in a dynamicly typed language
  * the conflict between novice and expert programmers is mythical
  * that a well-designed syntax is more important than recycled, familiar syntax

In Java we found
  * a new and demanding standard for modern language design
  * an impressive, albeit flawed, family of mutable Collections and Maps
  * a practical experience in using abstract classes and methods
  * much food for thought on programming with exceptions
  * the sum of good features is not necessarily a good language

Standard ML was firm (but fair) and we discovered
  * the critical role of type inference
  * the issues of parameterized type system

And the Common Lisp Object System (CLOS) taught us
  * the necessity of multiple inheritance
  * the compulsion of multiple dispatch
      * and the unity of functions and methods
      * and that methods are not members of a class

We have also closely reviewed and tried to incorporate features or philosophy from other language such as Perl, and Python to name but two.  There are some major ideas we very much admire that we have deliberately held back from so far, simply because we need to work through the current batch of novelties.  These are logic-based, aspect-oriented  and contract-based programming exemplified by works such as Prolog, AspectJ and Eiffel.

You say Ginger is a work in progress - how will it change in the future?
------------------------------------------------------------------------

These days the great majority of changes to Ginger are additions rather than modifications of existing changes.  There are quite a few features we have to add to implement Palantir properly, such as exception handling and the 2D image processing API, and some we would like to add for more aesthetic reasons such as the explicit-delay/implicit-force construct.  Here is a shortlist :-

 * Exception/error handling (more...)
 * Prolog-like facts and rules with integrated database support (more...)
 * 2D-Image processing API (more...)
 * Coroutines and tasks (rather than threads) (more...)
 * Explicit delay / implicit force (more...)
 * Enforced "side-effect free" annotation (more...)
 * Units and polynomials (more...)
 * Machine arithmetic (more...)
 * Curried function definitions (more...)
 * Ginger stylesheets (more...)


How is Ginger good for HTML / XHTML / XML processing?
-----------------------------------------------------

Ginger supports XML processing in three ways.  Firstly it has a compact and efficient internal representation of XML trees (no backlinks).  Secondly it is easy to build the nodes (elements) of a tree using embedded start and end tags.  Lastly it is easy to write transformation rules that are applied recursively to a tree - somewhat akin to XSLT stylesheets.

Here's a very simple example that creates a table illustrating the "birthday paradox" (the probability that two or more people in a group of N people share their birthday.)

.. code:: common

    define bparadox( n ) =>>
        <table border="1">
            var p = 1;
            for i from 1 to n do
                p := ( 365 - i + 1 ) * p;
                <tr>
                    <td> i </td>
                    <td> 1 - p </td>
                </tr>
            endfor
        </table>
    enddefine


This example illustrates a couple of things.  It shows how the start and end tags work, just like list brackets in fact.  And it also demonstrates how to return multiple values from a loop - and why that is an elegant way of working.  Each time round the loop we add a table-row element to the return values of the loop.  All those values then become child nodes of the table-element.


What is the license for Ginger?
-------------------------------

At the present we plan on adopting the GNU Free Documentation License for the language specification and all pages on this website.  The licenses for particular implementations are at the discretion of the implementors.


How can I follow the progress of the project?
---------------------------------------------


Apart from coming back to this website every few weeks, there are several mailing lists that you can subscribe to.  You'll find details on the ["Website/Community"].
