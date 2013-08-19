Pattern Matching
================
One of the most radical aspects of Ginger is the pervasive use of pattern matching. At the time of writing, only a small fraction of the full range of pattern matching constructs are available - as the project progresses we will see more and more of this capability revealed.

This note has two parts. The first part is the full vision of how pattern matching will work and the second part explains what has been implemented so far.

The Plan
--------
There are three parts of Ginger where pattern matching comes into play: initialisation, for loops and switches.

Initialisation
~~~~~~~~~~~~~~

When you write code like the following, what you are really doing is writing a _query_. A query is a Ginger expression that can be evaluated one or more times and has the effect of binding variables to values::

	>>> val ( x, y ) := ( 100, 200 );
	>>> x;
	There is one result.
	1.	100
	>>> y;
	There is one result.
	1.	200
	>>> 

The binding operator (:=) is in fact a query operator. Used in the normal way it has the effect of finding a assignment to all the variables. If it fails, it throws an exception. (When there are several possible bindings it returns the first one.)

Now you can use other things in a pattern apart from variables too. You can use constants such as "foo" and 17. When the query solver runs, it will only allow a constant to match against an equal value. This can be used as a shorthand way of checking that one field is the value you expected.

	# The head of the list should be zero, we only want the tail.
	val ( 0, x ) = list.headAndTail;

Another occasionally useful device is a dummy variable. Any variable starting with an underbar (_) is deemed to be a dummy variable, binding to anything but throwing the binding away afterwards::

	# We only want the first and last values of the 5-vector.
	val ( a, _b, _c, _d, e ) = v.explode;

You can also have a list, vector or element as a pattern::

	# Identical to the previous example (slightly more efficient).
	[ a, _b, _c, _d, e ] := v;

You can match zero or more values in one go by using a special kind of wildcard variable. This really increases the power of pattern matching since it allows for many alternative solutions::

	# Find the first and last elements of any vector with 2 or more values.
	[ first, middle..., last ] := v;
	
	# Split a vector v into head and tail.
	head, tail... := v...;

Lastly, you can add a restriction to a query with the 'where' keyword. This qualifies an entire query, so it goes at the end of an initialisation.

	# Split a vector v into two equal halves (rather inefficiently!)
	[ left..., right... ] := v where left.length = right.length


For Loops
~~~~~~~~~
For loops in Ginger are deceptively simple. All they do is iterate over all the possible solutions of a query. So when you write the following, what is really going on is that 'in' is a query operator that tries binding the pattern to each possible value in turn::

	# 'i in list' tries binding i to each member of the list.
	for i in list do 
		f( i ) 
	endfor

All the pattern matching constructs mentioned above work with for loops, which means that it is possible to write some very cute code::

	# Find all possible splits of a vector v
	[
		for [ left..., right... ] := v do
			[ left, right ]
		endfor
	]

For loops also make good use of higher-level operators such as the parallel operator '//'. This takes two subqueries and evaluates them in parallel, pairing up the solutions found by each subquery. (N.B. This clashes with the end-of-line comment in the C-Style syntax, so you'll find a slightly different way of writing it there.)::

	# Count as we iterate over a list.
	for i in list // n from 1 do 
		# i is a member of the list.
		# n is a count of how many times around the loop we have gone.
		...
	endfor

Another higher-level operator is query-conjunction '&'. This takes two subqueries and finds all solutions for both. This is a neat way of writing nested loops.

.. code:: common 

	for i from 1 to 10 & j from 1 to 10 do
		# 100 times around this loop
	endfor

You can cause an early termination of solutions by using while or until.

.. code:: common 

	for i in list while f( i ) do
		process( i )
	endfor

Indeed, there's no special 'while' loop in Ginger! While and until are both query operators.

.. code:: common 


	# How to write a while loop in Ginger.
	for while f( x ) do
		# If the left-hand side of while is empty, it defaults to
		# always succeeding.
	endfor


Switches
~~~~~~~~
The switch expression in Ginger also uses pattern matching. This is invoked by using the 'match' keyword rather than 'case'.

.. code:: common 


	for i in list do
		switch i
		match [] then # Ignore this case.
		match [x] then x
		match [ x | y ] then x + sum( y )
		endswitch
	endfor

See Also
~~~~~~~~

For a more formal description, read `Patterns and Queries`_. 

.. _`Patterns and Queries`: patterns_and_queries.html


Work Implemented to Date (as of version 0.8.2)
----------------------------------------------

At version 0.8.2 we have implemented a very limited subset of the pattern-matching vision.

  * Binding to pattern variables, including anonymous variables and the
    explicit use of var/val.
  * Binding to tuples of pattern variables.
  * for PATTERN_VARIABLE in EXPR do ... 