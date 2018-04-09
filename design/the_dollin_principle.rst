The Dollin Principle
====================

The Dollin Principle is a simple statement that tries to capture the idea that type assertions should not affect the run-time behaviour of programs.  It is usually phrased in terms of adding or removing type assertions to a program on a particular set of inputs. The term was casually coined by the ECMAScript commitee (ECMA TC 39, if memory serves) after Chris Dollin argued strongly in favour of its adoption in ECMAScript itself.

Phrased _positively_, it states that adding a set of true type assertions to a program will not affect its run-time behaviour for the given inputs. A true type assertion is one that is true for all the given set of inputs. Phrased _negatively_, it states that removing a set of type assertions cannot change the run-time behaviour on the given set of inputs.

There is some ambiguity with regard to adding true type assertions. In general a valid type assertion might may lead to (compile-time) type-check failures. The question is whether or not the Principle allows for this possibility.

  * The limited Principle is phrased with an additional side-condition of satisfying a type check. In other words, adding a set of true type assertions that additionally type-check will not affect run-time behaviour.  
  * Alternatively, the unlimited version of the Principle states that adding a set of true type assertions cannot lead to a failed type-check - as that would reduce the set of valid program inputs (to zero). 

The difference between the limited and unlimited forms is a very interesting issue. As far as I can tell, the Limited Principle corresponds to a common interpretation of strong type checking. In this version of the Principle, a type check seeks to guarantee type correctness assuming that explicit type assertions cannot be narrowed. The purpose of this is to ensure that all the type provides all the required operations.

By contrast, the unlimited Principle seems to correspond to the idea of type-checking as type-inference in which programmer types are routinely narrowed.  This means, for example, that the inferred type signature of a function may be different (more forgiving) than the programmer asserted signature.

The limited version of the Principle doesn't sit as comfortably with the idea of type inference. One possibility would be to distinguish the absence of a type assertion from the topmost type (say, Object). In the absence of a type assertion, the inference system would be free to infer supply a narrowable type. Another approach would be to have an annotation that distinguishes type that can be narrowed from those which cannot (e.g. a postfix annotation "**" to mean may be narrowed.)

:mod:`Ginger`'s Relationship to the Dollin Principle
----------------------------------------------------
:mod:`Ginger` takes the position that type-assertions may be read as run-time assertions. In other
words, as the program executes it checks the assertions and, on failure, will raise an error. A type
assertion describes the type of a variable or the result of an expression, where type describes the 
the set of operations it must participate in. 

A type assertion on a variable is understood to apply for the entire duration of that variable's dynamic lifetime - and must be checked on every update. A type assertion on a value is simple a one-off check. :mod"`Ginger` also defines a relatively strong notion of an assertion being true or *valid*. An
assertion on the inputs to a function is *valid* if and only if it is true for all possible inputs to the enclosing program. An assertion that is enclosed by a *function* is valid if and only if it is true for all possible inputs to the functions that also satisfy the input's type assertions.

Type assertions in :mod:`Ginger` have no other purpose. In particular they have no influence over the choice of method-body that is executed (c.f. static methods). Consequently, :mod:`Ginger` satisifies the Unlimited Dollin Principle for adding and removing valid assertions to a function.


---------------------

Stephen Leach, revised Nov 2017
