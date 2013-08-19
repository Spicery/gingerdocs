Updateable Strings, Lists, Vectors, Elements and Maps
=====================================================

All the built-in types that are not strictly immutable come in three flavours: immutable, updateable and dynamic. Of these three flavours, updateable strikes a balance between flexibility and efficiency. Typically updateable objects are almost as efficient as immutable objects. Not every built-in type has an updateable version, even if it has a dynamic form (e.g. numbers are exclusively immutable.)

Update objects are designed to be efficient to modify members but they don't allow you to add new members. i.e. You can modify but not cannot add or delete members. The internal structure of an updateable object is never exposed, so these changes are guaranteed to only be visible via a reference to the object itself.

In particular iterating over an updateable object is guaranteed to be safe in the sense that any changes to the object have no effect on the values that will be looped over. It is as if the updateable object is copied the moment the iteration begins (via copy-on-write).

Unlike dynamic objects, updateable objects will not support chilling or freezing. This is because that facility has a undesireable impact on performance.
