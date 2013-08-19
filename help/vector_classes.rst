Vector Classes
==============

Vector classes are used to create 1-dimensional arrays of data. In general any class that supports the below operations is said to be a vector class.

  * `indexing`_, which is invoked by the v[i] syntax.
  * `length`_
  * `++`_, which is the append operation.
  * `copy`_, which returns a shallow copy.
  * `in`_ iterates over the members of the vector object.

.. _`indexing`: ../std/index.html
.. _`length`: ../std/length.html
.. _`++`: ../std/++.html
.. _`copy`: ../std/copy.html
.. _`in`: ../syntax/in.html

Built-in Vector Classes
-----------------------
There are four built-in vector classes in 

	* `strings`_
	* `vectors`_
	* `lists`_, n.b. indexing is not O(1) operation!
	* `elements`_

.. _`strings`: ../help/strings.html
.. _`vectors`: ../help/vectors.html
.. _`lists`: ../help/lists.html
.. _`elements`: ../help/elements.html

User Defined Vector Classes
---------------------------
To be implemented! Probable initial design will be something like::

	vectorclass CLASS_NAME
		[ flavour (immutable|updateable|dynamic); ]
		[ type TYPE_EXPRESSION; ]
		[ constructor CONSTRUCTOR_NAME; ]		
		[ exploder EXPLODER_NAME; ]
		[ recogniser RECOGNISER_NAME; ]
		[ indexer INDEXER_NAME; ]
		[ length LENGTH_NAME; ]
	endvectorclass;