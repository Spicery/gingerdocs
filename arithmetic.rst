Ginger Arithmetic
=================
Arithmetic in Ginger seamlessly and dynamically shifts between difference implementations of numbers using a very similar model to that employed by Common Lisp.

Limited Arithmetic
------------------
At the moment Ginger only provide two implementations of numbers:

  * "Small" integers: broadly speaking these correspond to the native
    machine representation of integers, with a couple of bits reserved
    for tagging. 

  * Double precision floats: these are identical to the native repesentation
    of doubles.

Full Arithmetic Model
---------------------
In the future, Ginger will expand to include

  * Bignums: arbitrary sized integers.
  * Rationals.
  * Complex numbers.