Vectors
=======

Vectors are generic 1-dimensional arrays and an important basic type in Ginger. They are compact, fast to index and iterate over.

Classes & Constructors
----------------------

Vector
UpdateableVector
DynamicVector
	N.B. Dynamic vectors not yet implemented!
	These are the classes associated with the three different flavours
	of vector. The apply-action of the classes is the corresponding
	constructor.

[ X1, ..., Xn ] -> V
newVector( X1, ... Xn ) -> V
Vector( X1, ..., Xn ) -> V
	Takes N items X1 to Xn and constructs a single immutable vector
	V of length N with X1 to Xn as its members.

newDynamicVector( X1, ..., Xn ) -> DV
DynamicVector( X1, ..., Xn ) -> V
	Takes N items X1 to Xn and constructs a single immutable vector
	DV of length N with X1 to Xn as its members.

newUpdateableVector( X1, ..., Xn ) -> UV
UpdateableVector( X1, ..., Xn ) -> V
	N.B. Updateable vectors not yet implemented!
	Takes N items X1 to Xn and constructs a single updateable vector
	UV of length N with X1 to Xn as its members.


Recognisers
-----------

isVector( OBJECT ) -> BOOL
	Returns true if OBJECT is a vector and immutable. Implies
	`isImmutableObject`( OBJECT ).

isUpdateableVector( OBJECT ) -> BOOL
	Returns true if OBJECT is a vector and updateable. Implies
	`isUpdateableObject`_( OBJECT ).

isDynamicVector( OBJECT ) -> BOOL
	N.B. Dynamic vectors not yet implemented!
	Returns true if OBJECT is a vector and dynamic. Implies 
	`isUpdateableObject`_( OBJECT ) and `isDynamicObject`_( OBJECT ).

isVectorLike( OBJECT ) -> BOOL
	Returns true if OBJECT is a vector (immutable, updateable or dynamic),
	otherwise false. 

isUpdateableVectorLike( OBJECT ) -> BOOL
	Returns true if OBJECT is an updateable vector (updateable or dynamic),
	otherwise false. 

isDynamicVectorLike( OBJECT ) -> BOOL
	Returns true if OBJECT is a dynamic vector and (at the time of writing)
	this is a synonym for isDynamicVector.

.. _`isImmutableObject`: isImmutableObject.html
.. _`isUpdateableObject`: isUpdateableObject.html
.. _`isDynamicObject`: isDynamicObject.html

Accessors, Updaters and Exploders
---------------------------------

explode( V ) -> ( X1, ..., Xn )
explode( V ) <- ( X1, ..., Xn )
explodeVector( N, V ) -> ( X1, ..., Xn )
explodeVector( N, V ) <- ( X1, ..., Xn )
	N.B. Updaters not implemented yet.
	Returns the members of a vector V. In update mode, batch updates
	all the members of a vector. Updating only applies to updateable
	and dynamic vectors.

V[ N ] -> Xn
V[ N ] <- X
V( N ) -> Xn
V( N ) <- X
indexVector( N, V ) -> Xn
indexVector( N, V ) <- Xn
index( N, V ) -> Xn
index( N, V ) <- X
	N.B. Updaters not consistently implemented yet.
	Returns the Nth member of any vector V. In update mode, it will replace
	the Nth member of an updateable or dynamic vector with X. Attempting to
	update an immutable vector will generate a failover.

	Note that indexVector is the apply-action of vectors.

length( V ) -> N
lengthVector( V ) -> N
	Returns the length of any vector. `Length`_ is applicable to any 
	list-like object but lengthVector may only be applied to vectors.

.. _`Length`: length.html