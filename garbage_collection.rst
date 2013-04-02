Garbage Collection with Weak References, Maps and O/S Resource Finalisation
===========================================================================

Currently Implemented
---------------------

TODO:

Enhancements to the Garbage Collector
-------------------------------------
The following enhancements are planned and are likely to be implemented in the order they are described below.

Operating system resources such as file handles, sockets and pipes are in limited supply and care must be taken to close them. The current garbage collector already closes any o/s resources that are eligible for garbage collection. However, it is important that when the runtime system attempts and fails to allocate a resource that it immediately schedules a garbage collection in an attempt to claw back some of those resources. Only if that fails to close any resources of the right type, may the runtime system fail (typically with an alternative return).

Large heap objects present performance problems to the GVMs copying garbage collector. Unless handled specially, a large object will be copied on each garbage collection. The improvement we have planned is to allocate large objects in their own 'cage', of which they are the single member, which is flagged as being a pinned (non-copying) cage. [Status: designed]

One of the problems of garbage collection based runtime systems is their tendency to create unpredictable pauses in execution. One of the ways in which this disadvantage can be lessened is by scheduling a 'speculative' garbage collection when the virtual machine is waiting on i/o. The key property of a speculative garbage collection is that it can be immediately abandoned without significant penalty. Nor will a speculative garbage collection be performed if the heap isn't sufficiently full.

We intend to provide a speculative garbage collector which will either be run automatically or on a one-off basis ('the next "wait" is an opportunity for a speculative garbage collection'). For testing purposes it will be possible to force a speculative collection but in the ordinary way the runtime will ignore requests if the heap's usage falls below a (configurable) threshold.



