Equality in Ginger
==================
There are three useful and slightly different notions of equality: 

  * approximate functional equivalence '=' (pragmatic equals)
  * exact functional equivalence '==' (system equals)
  * identity, "=^="

Functional Equivalence
----------------------
Two objects are functionally equal when any series of agnostic-operations on them would yield functionally equal outcomes. In this context, 'agnostic' means being "implementation agnostic" that boils down to having no side effects, not exploiting identity-based properties and not directly comparing the type (and hence determining the implementation), nor calling any 'non-agnostic' function.

In other words, one can only tell the difference between functionally equal objects by updating one of them and seeing the update in one but not the other, or checking a property that is set for one but not the other or using an operation that exposes the implementation - such as dataClass or showMe.

This definition is potentially circular, so we additionally define functional equality for all the built-in types. We need to define functional equivalence for:

  * integers - are distinct from each other but may be equal to a float with zero fractional part.
  * floats (finite) - are distinct from each other if their difference is non-zero but may be equal to an integer if their fractional part is zero.
  * non-finite numbers - are distinct from all other values
  * characters - are equal if their codepoints are equal
  * strings - are equal if they have the same characters in the same order
  * booleans - true and false are distinct from all other values.

Exact versus Approximate Equivalence
------------------------------------
The comparison of integers and floats raises an awkward consideration. Should (say) 1 be considered to be equal to 1.0 or not? When big-integers get added to Ginger, which is very much the plan, there will be a clear distinction between the two because big-integers remain exact when floats become approximate.

The resolution we have chosen is to distinguish two types of functional equality: one which demands exactness ("==") and the other which permits inexactness. 

The stricter, exact equality ("==") equality will be used for pattern matching, switching, standard hash tables and so on. In effect it plays the role of system-equals. By contrast inexact equality is a more everyday notion of equivalence.

Identity
--------
The other important equivalence is identity. This is an equality which is sensitive to all possible futures: two values are identical if any series of operations involving one and/or the other has exactly the same results; in other words they are identical up to updates, identity based properties and runtime type checks.

Equality of Immutable Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Even though immutable objects cannot be updated, it is not correct to say that identity and functional equivalence are the same. Identity-based properties can expose the fact that two equal immutable values are not identical.


When is Identity and Non-identity Guaranteed?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In general, Ginger does not require that the constructors for immutable objects are guaranteed to generate new objects or may reuse existing objects. An obvious example of this are integers; integers are immutable and arithmetic operations do not allocate new objects but return a canonical value. So the question of whether or not two equal integers are also identical is not pinned down.

To help programmers with this, functions that are guaranteed to yield values with new identities are (by convention) always prefixed with the word 'new' and those which are not will be prefixed by 'make'. Furthermore the function -newCopy- always return a new value, utilising delays if required, and -makeUnique- always returns a distinguished but equal value (possibly the identical value).