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

Ginger currently supports three numerical types: simple integers (long), floating point (double) and nonfinite values (infinity, -infinity, nullify). In the future more types will be added, especially bignums, rationals and complex numbers.

Arithmetic operators are "total"; this means they always return results and never raise exceptions. This follows the underlying rules of :term:transreal arithmetic.

Because arithmetic is total, numbers are automatically converted from one type to another as necessary. The general rule is that conversions maximise accuracy. (Note, however, that the "/" operator always returns a float - if that it unsuitable there are alternatives, see div and ./.)

See Also
--------

To learn more about Transreal arithmetic, take a look at this tutorial http://www.bookofparagon.com/Mathematics/Evolutionary_Revolutionary_2011_web.pdf . ((Not tutorial enough))

More academically minded readers may enjoy learning the theory.

Axioms of Transreal arithmetic.
http://www.bookofparagon.com/Mathematics/PerspexMachineVIII.pdf

Transreal analysis inc. scientific functions.
          
http://www.bookofparagon.com/Mathematics/PerspexMachineIX.pdf
