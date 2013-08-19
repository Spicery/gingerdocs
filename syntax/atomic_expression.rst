Atomic Expressions
==================
Atomic expressions turn up in several places in Ginger's `Common syntax`_. These are places where it is natural to provide a literal value and a general expression might be confusing. To protect against the confusion, expressions are limited to the following forms:

  * variables are interpreted as literal symbols.
  * literal constants (strings, symbols, characters, numbers).
  * Any expression in paretheses, which must return a single value!

A good example is provided by the start tags in Ginger. It is required that attribute values are atomic expressions, for example. This prevents awkward situations like this::

	<!-- Wrong! -->
	<data flag=x>y> z </data>

	<!-- Should be ... -->
	<data flag=(x>y)> z </data>


Single Value
------------
Atomic expressions are restricted to return a single value. This affects character constants and expressions in parentheses. So this would not be allowed::

	<item chars='abc'/>


.. _`Common syntax`: ../syntax/common.html