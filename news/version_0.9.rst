Ginger Version 0.9
------------------

Query Operators
~~~~~~~~~~~~~~~

The following query operators have been implemented:

* P & Q
* P // Q
* Q where C
* Q do S
* Q finally S
* Q while S then E

Naked Queries and Conditional Queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In addition to the main uses of queries in for-loops, 'naked' queries have also 
been implemented. This allows you to write declarations like these.

::
	i := 99;							### Declares the variable 99.
	j from 80 where j.isprime;			### j is the smallest prime number > 80.

Queries can also be used inside if-statements. These 'if'-queries execute their
then-part if the match succeeded or the else-part if the match failed.



Escapes
~~~~~~~
We have implemented the most important category of exceptions - namely escapes.
These are a form of 'tagged' return statement that need to be handled or they
escalate into more serious exceptions.

Math: Bigintegers, Rationals, Analytical Functions and TransDoubles Implemented
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We have adopted James Anderson's transreal arithmetic as the basis for floating
point arithmetic in Ginger. This adds three transreal numbers +infinity, 
-infinity and nullity and ensures that arithmetic operators are defined
everywhere (including division by zero etc.)

We have implemented arbitrary precision integer arithmetic and
rational arithmetic. 

We have also implemented analytical functions for:

* divmod 
* log
* log2
* log10
* sin
* cos
* tan
* min, minAll 
* max, maxAll
* sqrt
* cbrt
* hypot
* unary +

Constants E and PI have been added. 

Bug Fixes
~~~~~~~~~

* file2gnx enhanced to handle single-expression files properly.

* All components now print the GPL correctly.

* ginger -q: the quiet startup flag is now honoured.

* <if/> now parsed correctly as legitimate expression.


Refactorings
~~~~~~~~~~~~

* We have eliminated all the compilation warnings on OS X. These were
  caused by the upgrade to XCode 4.6.3.

* The use of \*.inc files to define system functions has been entirely
  retired in favour of self-registering definitions.

* The C++ code has finally been moved into its own namespace. This was
  a low priority but implemented to make writing the API cleaner.

* We have consistently renamed "Machine" as "Engine" throughout the 
  code and documentation. The distinction between the virtual machine
  and its engine is unusual but important.

* Engines now self-register, so adding new engines is much more straightforward.

* CppLite2 now the basis of C++ unit testing.

Experimental / In-Progress Features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* New Dockerfile added for easy experimentation and to ensure a clean build process.

* New vagrant scripts have been included for experimenting with Ginger and
  rapidly getting test deployments working.

* An initial implementation of co-processes (aka first class VMs) have been added
  to the core but not exposed to the application programmer.
