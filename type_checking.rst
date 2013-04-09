Typing in Ginger
================

Dynamically Typed Variables
---------------------------


TODO:
	Emphasise that Ginger has strong, dynamic typing by default.
	This is all about the fact that varaiables are dynamically rather
	than statically typed. We should have a section on optional static typing.


Optional Type Assertions
------------------------
This is a planned feature of Ginger, which will be added subsequent to Release 1.0. 

Optional type assertions enable the programmer to assign a type assertion to any variable. That assertion is enforced for the entire lifetime of the variable. For example, you might assert that a variable is a string, like this:

Example::

	fred : String := "42";

Casually, we speak of these type assertions as "static type checks". And in most cases it is possible for the compiler to prove that the type assertion is satisfied for all possible execution paths, in which case the type assertion can be statically eliminated. However, that cannot be done in the general case and so it is not quite accurate to say that this is "static type checking".

It is important to appreciate that type assertions are exactly and only what they say - a validity check. It might seem bizarre to emphasise this but in some other programming languages, notably C# and C++, changing the type of a variable can radically change the runtime behaviour of a program.

Ginger subscribes to `the Dollin Principle`_ which says that assertions can only prevent invalid execution, not influence the execution paths. It's an essential ingredient, allowing the seamless, incremental introduction of type assertions into a program. It also requires Ginger to explicitly support so-called "late binding".

.. _`the Dollin Principle`: the_dollin_principle.html
