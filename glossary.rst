.. glossary::

transdouble
	An implementation of :term:`transreal` floating point numbers on top
	of IEEE 754 double precision numbers. Transdoubles are one of the number
	classes implemented in Ginger. 

	Ginger uses transdoubles in preference to
	plain old doubles because they are more straightforward to understand,
	have less surprises for programmers and make maths programs more robust.

transreal
	Transreal numbers are a simple extension to real arithmetic
	with the aim of making all arithmetic functions :term:`total`.
	There are three special 'transreal' numbers +infinity, -infinity and
	nullity that help with this. In contrast to plain old floating point 
	arithmetic these are perfectly respectable values (e.g. nullity equals 
	nullity.)

	There are practical advantages to using total arithmetic
	as the basis for programming languages: base cases are simplified and 
	the need for reasoning about exceptional situations is eliminated. 

