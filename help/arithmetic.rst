Ginger Arithmetic
=================
Arithmetic in Ginger seamlessly and dynamically shifts between difference implementations of numbers using a very similar model to that employed by Common Lisp.

Number Types
------------

At the moment Ginger only provides the following types of numbers:

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


.. _`transreal arithmetic`: transmaths.html

Full Arithmetic Model
---------------------
In the future, Ginger will expand to include

  * Bignums: arbitrary sized integers.
  * Rationals.
  * Complex numbers.
