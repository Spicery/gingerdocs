The Dollin Principle
====================

The Dollin Principle is a simple statement that tries to capture the idea that type assertions should not affect the run-time behaviour of programs.  It is usually phrased in terms of adding or removing type assertions to a program on a particular set of inputs. The term was casually coined by the ECMAScript commitee (ECMA TC 39, if memory serves) after Chris Dollin argued strongly in favour of its adoption in ECMAScript itself.

Phrased in positive form it states that adding a set of true type assertions to a program will not affect its run-time behaviour for the given inputs. A true type assertion is one that is true for all the given set of inputs. Phrased negatively, it states that removing a set of type assertions cannot change the run-time behaviour on the given set of inputs.

There is some ambiguity with regard to whether adding true type assertions may lead to type-check failures. The limited Principle is phrased with an additional side-condition of passing a type check. In other words, adding a set of true type assertions that also type-check will not affect run-time behaviour.  Alternatively, the Principle may be read as implying that adding a set of true type assertions cannot lead to a failed type-check since that would reduce the set of valid program inputs (to zero). This is the unlimited form.

The difference between the limited and unlimited forms is a very interesting issue. As far as I can tell, the Limited Principle corresponds to a common interpretation of strong type checking. In this interpretation a type check seeks to guarantee type correctness assuming that explicit type assertions cannot be narrowed. The purpose of this is to ensure that all the type provides all the required operations.

By contrast, the unlimited Principle seems to correspond to the idea of type-checking as type-inference in which programmer types are routinely narrowed.  This means, for example, that the inferred type signature of a function may be different from the programmer asserted signature.

The limited version of the Principle doesn't sit as comfortably with the idea of type inference. One possibility would be to distinguish the absence of a type assertion from the topmost type (say, Object). In the absence of a type assertion, the inference system would be free to infer supply a narrowable type. Another approach would be to have an annotation that distinguishes type that can be narrowed from those which cannot (e.g. a postfix annotation "**" to mean may be narrowed.)

---------------------

Stephen Leach
