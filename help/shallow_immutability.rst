Tech Note on Shallow Immutability
=================================

Mutablity implies being able to attribute changes to objects but, if we only look at the public interface of objects, then we can run into trouble. For example if we have an object X and we see a sequence like this:

	>>> X.f;
	42
	>>> X.setF( 99 );
	>>> X.f;
	99

The we may be tempted to say that X is mutable. However, here's a counter-example::

	>>>
	define makeGetterAndSetter( x ) =>>
		var hidden_state := 42;
		fn getter( y ) =>> if x == y then hidden_state else _ endif endfn,
		fn setter( x, n ) =>> if x == y then hidden_state ::= n endif endfn
	enddefine;

	>>> X := 3;
	>>> ( f, setF ) := makeGetterAndSetter( X );

	>>> 3.f;
	42
	>>> 3.setF( 99 );
	>>> X.f;
	99

What we would like to say is that the hidden state lies in the getter and setter functions but arguably these functions have just attached state to the number 3.

The way out of this bind is to label certain methods of a class as state observers and others as component getters. If the state observers reveal an object changing independently of its components, then it is mutable. If all the observable changes can be accounted for by changes in the components, then we say the object is immutable.

What counts as a state observer? Any pure, side-effect free function of that object may be used. (Fortunately being pure is a easier criterion to determine: only invoking pure functions makes no observable changes to a system regardless of the arguments to the functions, order of application etc.)

What counts as a component getter? It must be a pure function of an object but aside from that it is a design choice. 

And finally, what counts as a full account of the changes observed? It is necessary to show a 1-1 mapping between the changes observed on the object and  changes observed on the components. 
