Garbage Collection with Weak References, Maps and O/S Resource Finalisation
===========================================================================
Garbage collection is a way of managing the most general class of store, commonly called the heap, in which objects are allocated and deallocated in an arbitrary order. It's a critical part of the runtime of any programming language.

The Ginger garbage collector is a relatively standard stop-and-copy, `Cheney style`_ collector. The key features are:

  * It is a 'stop the world' collector.
      - This has the disadvantage of unpredictable pauses in execution.
      - But it is relatively straightforward to implement.

  * It is a copying, compacting collector that moves stores 
    around on each collection.
      - This has the advantage that deciding where to allocate is quick.
      - And the disadvantage that store moves, so it's unsuitable for 
        integrating with store managed by C/C++ allocators.
      - And the disadvantage that it copies from used to unused semi-spaces,
        and the unused semi-spaces is a storage overhead. In a naive 
        implementation this overhead is as much as a factor of 2.

  * Unreachable store is not traced.
      - Which has the strong advantage that the cost of a garbage collection
        only depends on the amount of store that survives a collection.
      - The big benefit is that the garbage collector can dynamically 
        expand and reduce the store in use to maintain a fixed ratio between
        the time spent garbage collecting and the time spent doing useful 
        work. This self-tuning works under a wide range of practical
        circumstances.

  * It's a precise collector that collects circular chains of references and
    supports weak references and weak tables.
      - The advantage is that it collects all dead store on each collection.
      - Weak tables are also a vital tool for programmers, allowing
        objects to be given additional 'sparse' properties. But they require
        special support from the collector.

  * Lightweight heap usage
      - The GVM implementation adopts the position that the heap is flexible
        but expensive to manage. So it allocates many objects out of heap 
        (e.g. symbols, streams).
      - This means that the heap population is lower than might be expected,
        which means that garbage collections are faster.
      - And the design of heap objects emphasises them being flat, making
        copying (the expensive part of the collection) faster and reducing
        the overhead associated with processing individual heap objects.
      - The overall result is a quick garbage collection.


.. _`Cheney style`: http://en.wikipedia.org/wiki/Cheney's_algorithm

Enhancements to the Garbage Collector
-------------------------------------
The following enhancements are planned and are likely to be implemented in the order they are described below.

Operating system resources such as file handles, sockets and pipes are in limited supply and care must be taken to close them. The current garbage collector already closes any o/s resources that are eligible for garbage collection. However, it is important that when the runtime system attempts and fails to allocate a resource that it immediately schedules a garbage collection in an attempt to claw back some of those resources. Only if that fails to close any resources of the right type, may the runtime system fail (typically with an alternative return).

Large heap objects present performance problems to the GVMs copying garbage collector. Unless handled specially, a large object will be copied on each garbage collection. The improvement we have planned is to allocate large objects in their own 'cage', of which they are the single member, which is flagged as being a pinned (non-copying) cage. [Status: designed]

One of the problems of garbage collection based runtime systems is their tendency to create unpredictable pauses in execution. One of the ways in which this disadvantage can be lessened is by scheduling a 'speculative' garbage collection when the virtual machine is waiting on i/o. The key property of a speculative garbage collection is that it can be immediately abandoned without significant penalty. Nor will a speculative garbage collection be performed if the heap isn't sufficiently full.

We intend to provide a speculative garbage collector which will either be run automatically or on a one-off basis ('the next "wait" is an opportunity for a speculative garbage collection'). For testing purposes it will be possible to force a speculative collection but in the ordinary way the runtime will ignore requests if the heap's usage falls below a (configurable) threshold.



