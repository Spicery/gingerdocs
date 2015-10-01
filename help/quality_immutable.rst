Immutable Strings, Lists, Vectors, Elements and Maps
====================================================

Built-in types come in three flavours: immutable, updateable and dynamic. Of these three flavours, immutable is the most restrictive and, unsurprisingly, is the most efficient. Every built-in type has an immutable version and is considered to be the default version.

An immutable object remains completely unchanged throughout its entire lifetime. Any attempt to modify the object will generate an exception. However, immutability is "shallow" in the sense that an immutable object may have mutable components. 

Technical Aside: Shallow Immutability
-------------------------------------

What does it mean to say an immutable object has a mutable "component"? This is easy to answer in terms of the implementation structures but much harder to answer if we respect data encapsulation. Fundamentally this is an API design question. See `Tech note on shallow immutability`_.

.. _`Tech note on shallow immutability`: shallow_immutability.html


Future Expansions
-----------------
A planned extension of the garbage collector is identifying deeply immutable objects i.e. groups that can be safely shared by multiple virtual machine objects, significantly reducing the cost of creation a virtual machine. This is vital to make transaction-blocks reasonably efficient.

Immutable objects are also beneficial in the context of heap locking. At strategic points in an application's lifecycle it can be a good idea to compact and then "pin" the extant objects so that they can be scanned but not moved by the garbage collector. Deeply immutable objects do not need to be scanned at all and immutable objects that point to mutable objects need to be scanned: they are treated as additional roots.

All immutable objects can be interconverted with their updateable and dynamic counterparts.

	upd_object := updateableCopy( obj )
	dyn_object := dynamicCopy( obj )
	
Naturally, it is possible to take a dynamic-copy of a dynamic object, which is the same as a plain copy.

	imm_object := immutableCopy( obj )
	
