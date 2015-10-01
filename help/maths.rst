Maths Functions in Ginger
=========================

.. comment
	* Numerical types
	* Basic arithmetic functions
	* Scientific constants
	* Scientific functions
	* references
		http://www.bookofparagon.com/Mathematics/PerspexMachineVIII.pdf
		http://www.bookofparagon.com/Mathematics/PerspexMachineIX.pdf

Number Types
------------
Ginger currently supports the following numerical types - in the future complex numbers with be added.

  * "Small" integers: broadly speaking these correspond to the native
    machine representation of integers, with a couple of bits reserved
    for tagging. e.g. -1, 0, 1, 2, 77, -23456. These automatically overflow
    into big-nums.

  * "Bignums", which are integral values of unlimited precision. 
    e.g. 12345678900. These automatically convert into small integers when
    needed.

  * Rational numbers, which are the ratio of two integral values called
    the numerator and the denomiator. e.g. 1/2, -113/355. Strictly speaking, 
    rationals will be normalised so that the numerator and denominator are 
    coprime, so that they do not share any prime factors, and the denominator
    is positive. 

  * Double precision floats: these are the same as the native repesentation
    of doubles. The clean rules of `transreal arithmetic`_ are used for all
    double precision arithmetic. All arithmetic is 'total', meaning that it
    always returns a single, meaningful value - and it is safe and
    correct to divide by zero, raise zero to the power of zero, etc.

  * Strictly transreal numbers: nullity, +infinity and -infinity. These are
    cleaned up, safe versions of the floating point NaN and infinities that
    can be used with integers, rationals and floats. 

Total Arithmetic
----------------

Arithmetic operators are "total"; this means they always return results and never raise exceptions. This follows the underlying rules of `transreal`_ arithmetic.

Because arithmetic is total, numbers are automatically converted from one type to another as necessary. The general rule is that conversions maximise accuracy. (Note, however, that the "/" operator always returns a float - if that is unsuitable there are alternatives, see div and ./.)

.. _`transreal`: transmaths.html



Working with Non-finite Numbers
-------------------------------
Ginger provides three special values for representing non-finite numbers: infinity, -infinity and nullity. Infinity and -infinity can be intuitively understood as standing for numbers that are too large, positively or negatively, to be represented exactly. Nullity, on the other hand, can be understood as the situation where you have no information about the value.

Unlike the normal floating point versions, there is nothing 'bad' about these values. They are generated predictably, work the way you might expect given these intuitive meanings, can be compared reliably with themselves and with other non-finite numbers, and can be stored in variables and so on.

The two infinities are generated when dividing any non-zero finite value by zero, much as in normal floating point arithmetic. They are also used for representing the overflow of arithmetic operations that would otherwise fail.

Nullity is generated when dividing zero by zero and also arises naturally in many problematic situations, such as adding plus and minus infinities. It work a good deal like NaN in ordinary floating point arithmetic but can be safely comparsed with itself. It often comes in handy when writing functions such as the arithmetic mean - there's no need to check for an empty list of values::

	define arithmeticMean( list ) =>>
		var sofar := 0;
		for i in list do
			sofar ::= sofar + i
		endfor;
		sofar / list.length
	enddefine;

	>>> arithmeticMean( [] );
	There is one result.
	1.	nullity


Basic Arithmetic Functions
--------------------------
The basic arithmetic functions are +, -, *, and /.


Scientific Constants
--------------------
TO BE DONE

Scientific Functions
--------------------

TO BE DONE


See Also
--------

To learn more about Transreal arithmetic, take a look at this tutorial http://www.bookofparagon.com/Mathematics/Evolutionary_Revolutionary_2011_web.pdf . ((Not tutorial enough))

More academically minded readers may enjoy learning the theory.

Axioms of Transreal arithmetic.
http://www.bookofparagon.com/Mathematics/PerspexMachineVIII.pdf

Transreal analysis inc. scientific functions.
          
http://www.bookofparagon.com/Mathematics/PerspexMachineIX.pdf
