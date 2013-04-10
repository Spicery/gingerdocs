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
A planned extension of the garbage collector is identifying closed groups of immutable objects i.e. groups without any links to other objects. These groups can be safely shared by multiple virtual machine objects, significantly reducing the cost of creation a virtual machine. 

Immutable objects are also beneficial in the context of heap locking. At strategic points in an application's lifecycle it can be a good idea to compact and then "pin" the extant objects so that they can be scanned but not moved by the garbage collector. Furthermore, only the immutable objects that point to mutable objects need to be scanned: these simply get treated as additional roots.