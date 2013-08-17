Ginger Version 0.8.2
--------------------

Query Operators
~~~~~~~~~~~~~~~

* P & Q
* P // Q
* Q where C
* Q do S
* Q finally S
* Q while S then E

'Naked' queries have also been implemented.

'If' queries have been implemented.

Escapes
-------
We have implemented the most important category of exceptions - namely escapes.
These work rather like return

TransDoubles Implemented
~~~~~~~~~~~~~~~~~~~~~~~~
We have adopted James Anderson's transreal arithmetic as the basis for floating
point arithmetic in Ginger. This adds three transreal numbers +infinity, 
-infinity and nullity and ensures that arithmetic operators are defined
everywhere (including division by zero etc.)

Unary +
~~~~~~~
As part of the adoption of transreal numbers, where it is convenient to refer
to +infinity, we have added the unary + operator. It checks that its single
argument is a number, otherwise raises an error.

Under the Hood
~~~~~~~~~~~~~~
New vagrant scripts have been included for experimenting with Ginger and
rapidly getting test deployments working.


As usual there have been numerous refactorings:
    
    * We have eliminated all the compilation warnings on OS X. These were
      caused by the upgrade to XCode 4.6.3.

    * The use of *.inc files to define system functions has been entirely
      retired in favour of self-registering definitions.

    * The C++ code has finally been moved into its own namespace. This was
      a low priority but implemented to make writing the API cleaner.

    * We have consistently renamed "Machine" as "Engine" throughout the 
      code and documentation. The distinction between the virtual machine
      and its engine is unusual but important.