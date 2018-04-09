Why Ginger?
===========
Ginger is a modern programming system that is built on top of a general purpose virtual machine. It comes with a modern programming language and library so that you can use to  write your own applications. But the whole system is designed to be open, so you can extend or replace almost every part of the system. 

Why did we create Ginger when there are so many programming systems already? Because we love programming and love making neat, effective programs. Other languages have all kind of conveniences that end up being confusing; strange corner cases that are supposed to be convenient but just make things ugly; or reasonable looking compromises that cause lots of problems later on. So we designed Ginger to be a language that gets out of your way and lets you enjoy the experience of writing programs, big or small.


Design Rules
------------
It took us a long time, more than ten years, to figure out what we thought that meant. Gradually we distilled our design goals into some key rules. One rule, for example, is "the programmer is in charge" by which we means that we aren't in the business of stopping the programmer from doing unconventional things. That affects the design of visibility declarations such as private/public; it requires that a programmer can get access to private variables for, say, debugging or writing unit tests. 

..  NOTE::
    If you are an experienced programmer, you may wonder how that could make sense - in which case turn to the chapter on packages. Or you may have misgivings about the wisdom of allowing bad coding practices - in which case turn to the chapter on policies. 

If you are interested in the design rules, you can `read more about them here`_.

.. _read more about them here: design/design_rules.html


Show Me What's Special About Ginger
-----------------------------------
Learning a new programming language takes a lot of time. So people always want clear examples of why they should prioritise learning Ginger over (say) C++ or C# or Ruby. Well we love programming so would always hope that people are going to learn Ginger in *addition* to those other languages. But here's some examples that shows Ginger's combination of simplicity and practicality. These examples start simple and get more advanced!

  * `Returning Zero, One, Two or More Values <special/multiplevalues.html>`_


.. Topics to include
   How to swap values
   List comprehension
   Transreal arithmetic
   Parallel loops
   Arbitrary precision arithmetic
   Every type has Immutable and Dynamic types - no need for StringBuilder
   Expression-ifs
   Auto-conversion for loading JSON, XML, images etc
   Unicode friendly (not implemented!)
   

