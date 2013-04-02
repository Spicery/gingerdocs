Implicit Forcing - Explicitly Defined Laziness
==============================================

Lastly, we intend to build in support for explicit-delays with implicit-forcing. This is a more general version of pdtolist. The basic idea is that you can _delay_ an expression by surrounding it with delay-brackets e.g. ``delay EXPR enddelay``. The effect is that this ``EXPR`` is bundled up inside a procedure but executed on demand i.e. when the runtime system attempts to determine its runtime-type. 

Fairly obviously this needs pervasive support at the lowest level. I have implemented this once before (in JSpice) and so have reasonable expectations that it can be implemented in such a way that there is no impact when it is not used. That means it is an affordable technique to include. [Status: planned]
