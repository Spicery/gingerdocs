Function Expressions, aka Lamba Expressions
===========================================
Ginger supports first class function expressions, more commonly called lambda expressions. These expressions are started with the "fn" keyword and closed with the "endfn" keyword. The formal arguments are separated from the body with the "=>>" keyword.

Example::
	
	>>> # Increments by 99.
	>>> fn x =>> x + 99 endfn 

	>>> # Increase all the numbers in a list by 99.
	>>> define appValues( L, f ) =>> for i in L do f( i ) endfor enddefine;
	>>> [ appValues( [ 1, 2, 3, 4 ], fn x =>> x + 99 endfn ) ];
	[100, 101, 102, 103]

Named Lambdas - Special Feature
-------------------------------
Unlike other programming languages, Ginger's function expressions may be named. This is done in the natural way, by making the head (left hand side) of the function expression look like a function call::

	>>> fn fact( n ) =>> if n <= 1 then 1 else n * fact( n - 1 ) endif endfn;
	<function fact>

As the example above shows, the name of the function is used to help print out the function in a less unfriendly way. However, it does more than that. In fact within the function body the name is locally bound to the function itself. This can be handy when writing directly recursive functions::

	>>> F := fn fact( n ) =>> if n <= 1 then 1 else n * fact( n - 1 ) endif endfn;
	>>> F( 6 );
	There is one result.
	1.	720

