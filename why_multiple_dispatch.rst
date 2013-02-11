Why Multiple Dispatch?
[Where should this be put? Background / Advocacy]

[Taken from an original letter to Andy Skingsley. Will need to be rewritten so it is more of an article than a personal letter.]
 
I thought you might appreciate a few notes on multiple (as opposed to single dispatch) in object-oriented programming. In Smalltalk influenced programming languages, methods are written inside classes and take an extra, implicit argument called “this”.
 
.. code::

	// Method in a typical Smalltalky language.
	class Thing {
		// doit is a method that needs to be invoked on 3 arguments – the
		// special argument called the subject and two additional typed arguments.
		void doit( int a, string b ) {
			… code body that can refer to a read-only local variable ‘this’ of type ‘Thing’…
		}
	}
 
This is an especially mediocre way to write method definitions and overrides. It obscures the natural and simple relationship between methods and functions, it obscures the difference between method introduction and method override, it obscures the fact that there is an additional parameter being passed in, it causes difficulty due to name clashes with ‘this’ when writing inner class definitions, it creates a problematic distinction between the invocation of methods and functions – revealing implementation is a loss of encapsulation, and does not support putting the subject in any other position other than first not having more than one subject.
 
Since there is a much more obvious way to write method definitions that suffers from none of these problems, I think it is perfectly justified to call the Smalltalk approach broken. Here’s the natural way of writing method introductions:
 
.. code::

	// The caret (^) marks the subject.
	void doit( Thing ^this, int a, string b ) {
		… code body that can refer to its variables, ‘this’ is not a special name …
	}
 
In other words, write the method as a perfectly ordinary function, explicitly include the variable that will act as a subject, and use a marker to show the argument that is “dispatched” on to select the correct override.
 
In order to extend the method for a subclass of Thing, SubThing, we need to write an override. The obvious way to do this is to state that the definition is an override.
 
	override void doit( SubThing ^that, int a, string b ) { … code body… }
 
With the two markers ‘override’ and ‘^’ we have almost everything we need to do object-oriented programming (the one extra thing we need is the multiple-dispatch equivalent of ‘super’). The most important thing is that we no longer are obliged to use a funny notation to call methods that is different from calling functions. i.e. x.doit( a, b ) can now treated exactly the same as doit( x, a, b ). Literally there is no difference.
 
Elegantly we can now dispatch on two arguments.
 
	// Glue two Things together.
	Thing glue( Thing ^this, Thing ^that ) { … default … }
	override Thing glue( SubThing ^this, SubThing ^that ) { … special double SubThing case… }
 
Is there a downside? Yes, the main reason for the silly method calling syntax x.f(y,z) is so we can avoid endlessly passing in ‘this’. In other words if we assume foo, bar and gort are all methods of Thing then we could write:
 
.. code::

	class Thing {
		void doit( int a, string b ) {
		   foo( bar( a ), gort( b ) );
	   }
	}
 
And it would be equivalent to
 
.. code::

	void doit( Thing ^this, int a, string b ) {
		this.foo( this.bar( a ), this.gort( b ) );
	}
 
That’s actually quite a nice shortcut. The usual way of getting the benefit of this shortcut is to allow the caret (^) to be used in the code body as a shorthand for ‘this.’. So you can then write:
 
.. code::

	void doit( Thing ^this, int a, string b ) {
		^foo( ^bar( a ), ^gort( b ) );
	}
 
There are three nice positives about this shorthand. The first is that you can use it with ordinary functions of course! Because we did not create an artificial and meaningless distinction between functions and methods everything just works for both automatically. It’s almost like we aren’t deliberately screwing up the design (actually that’s all it is – not deliberately screwing up a simple design.)
 
The second positive is that the fact that an extra argument is passed in is not obscured. As a programmer you really need to know about where objects are accessed and updated. The implicit argument convention in Smalltalk is wholly destructive and you won’t find many experienced programmers taking advantage of it.
 
The third positive is that the compiler does NOT need to type check before it can figure out what is being called. It might not be immediately obvious but when the compiler encounters
 
.. code::

	foo( a, b )
 
how does it know whether or not it is a function or method and whether or not to pass in an extra ‘this’ argument? It has to do a whole lot of searching. Technically this means that name resolution occurs ahead of type resolution. This immediately simplifies error messages and diagnostics, eliminates rare but baffling error cases, and opens the opportunity for incremental and interactive compilation (in a true interactive development environment).
 
We can go one small step further now and permit this shorthand to be used like this in method definitions.
 
.. code::

	class Thing {
		void ^doit( int a, string b ) { … all the goodness & none of the badness… }
	}
 
When used in this way, the caret (^) means exactly the same an explicit Thing ^this argument. With just a few very small tweaks we have all the advantages, none of the disadvantages, reified methods – so higher order programming is now a snap, simplified the compiler, improved error messages, benefited functions as well as methods, got the benefits of multiple dispatch and moved two steps closer to heaven.
