Type Checking in Ginger
=======================

Dynamically Typed Variables
---------------------------
Ginger is by default a dynamic, strongly typed language. By dynamically typed we mean that variables may be assigned values of any type throughout their lifetime. By strongly typed, we mean that all operations check that they are applied to values of the correct type and fail otherwise.

This means that Ginger values carry their type information with them wherever they go and that type information is constantly being checked. There is a significant amount of dynamic overhead associated with this relative to statically type-checked systems.

Optional Static Type Assertions
-------------------------------
This is a planned feature of Ginger, which will be added subsequent to Release 1.0. 

Optional static type assertions enable the programmer to assign a type assertion to any variable. That assertion is enforced for the entire lifetime of the variable. For example, you might assert that a variable is a string, like this:

Example::

	# The variable foo may only be bound to a String.
	var fred : String := "42";

Casually, we speak of these type assertions as "static type checks" but that's slightly inaccurate because it implies the checking can be discharged by the compiler. Although in many cases it is possible for the compiler to prove that the type assertion is satisfied for all possible execution paths, in which case the type check can be eliminated. However, that cannot be done in the general case and so it is more accurate to say "state type assertions with static/dynamic type checking".

It is important to appreciate that type assertions are exactly and only what they say - a validity check. It might seem bizarre to state the obvious but in some other programming languages, notably C# and C++, changing the type assertion of a variable can radically change the runtime behaviour of a program!

Ginger subscribes to `the Dollin Principle`_ which says that assertions can only prevent invalid execution, not influence the execution paths. It's an essential ingredient, allowing the seamless, incremental introduction of type assertions into a program. It also requires Ginger to explicitly support so-called "late binding".

.. _`the Dollin Principle`: ../design/the_dollin_principle.html
