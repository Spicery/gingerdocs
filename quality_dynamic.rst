Dynamic Strings, Lists, Vectors, Elements and Maps
==================================================

All the built-in types that are not strictly immutable come in three flavours: immutable, updateable and dynamic. Of these three flavours, dynamic is the most flexible and, unsurprisingly, typically uses a bit more store and is slightly slower to use. Not every built-in type has a dynamic version (e.g. numbers are exclusively immutable.)

Dynamic objects are designed to be efficient to modify. You can add, delete or change members freely at any position. The internal structure of a dynamic object is never exposed, so these changes are guaranteed to only be visible via a reference to the object itself.

In particular, iterating over a dynamic object is safe in the sense that any changes to the object have no effect on the iteration - it is as if the dynamic object is copied the moment the iteration begins (via copy-on-write). 

When you need the ability to freely modify a datastructure, these dynamic objects give you the maximum flexibility with a modest overhead.

Future Expansions
-----------------
All dynamic objects will support the temporary and permanent 'freezing' of their contents. When this happens they will typically take advantage of the 
chill/freeze to reorganise their contents for more efficient access rather than update (although this will be delayed until the first actual access, so
there is no penalty for precautionary freezing).

	# Temporary freezing
	chillDynamicObject( obj ) ::= is_chilled
	is_childed := chillDynamicObject( obj )

	# Permanent freezing
	freezeDynamicObject( obj ) ::= is_frozen
	is_frozen := freezeDynamicObject( obj ) 

And all dynamic objects can be interconverted with their Updateable and Immutable counterparts.

	imm_object := immutableCopy( obj )
	upd_object := updateableCopy( obj )

