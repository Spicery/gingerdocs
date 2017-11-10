
The Design of Loops in Ginger and Java
======================================

[This article is now out of date and requires substantial revision]

Overview
--------

One of the distinctive features of Ginger is its simple and uniform 
loop syntax. In this essay we highlight this feature by comparing 
with Java. In doing so, it should become apparent to the reader 
just what itches this particular syntax is intended to scratch. 

We select Java as an exemplar of a mature, modern programming 
language, one with much to recommend it. Our subsequent criticisms 
typically apply very widely, to almost all popular programming 
languages, and should not be read as targeting Java. 

Too Many Forms
--------------

How many ways of looping should a programmer need to learn? It 
is a key aspect of imperative programming so perhaps there should 
be quite a few? Popular programming languages have converged 
on having several top level forms with a few variants. 

Java provides three forms for looping over data: ``for``, ``while`` 
and ``do``. The ``for`` form itself comes in two different flavours 
``for( init; condition; step )`` and ``for(var: data)``. These provide 
a few variations on the one-&-a-half times loop looking like 
this. 

.. code-block:: text

    <init>;
    for (;;) { 
        <statements1> 
    if ( <test> ) break;
        <statements2> 
    }

Experienced Java (or C/C++/etc) programmers are aware that 
the “unstructured” control forms ``continue`` and ``break`` are 
required to compose further variations on the looping theme. 
It is rather unsatisfactory that a programmer has to resort to 
unstructured programming for this basic form. 

Ginger shows that the basic forms in languages such as Java are 
guilty of being too-specific. They capture a handful of specific 
cases extremely well at the expense of making minor variations 
awkward to write. 

In Ginger, the ``for`` form is the only way of introducing a loop. 
The extra expressive power comes from taking iterators seriously 
and adding features for combining and filtering them. For example, 
``while`` is seen as an operator on an iterator rather than a primitive 
form of loop. 

So here are the different forms in Ginger. 

``for( init; condition; step ) statements`` 

.. code-block:: text

    <init>;
    for while <condition> do
        <statements>
        <step>
    endfor

``for(var:data) statements``

.. code-block:: text

    for <var> in <data> do
        <statements>
    endfor

``while ( condition ) statements``

.. code-block:: text

    for while <condition> do
        <statements>
    endfor

``do statements while condition``

.. code-block:: text

    for do 
        <statements>
    while <condition>
    endfor

And to wrap it up, here is how Ginger composes the one-&-a-half times loop.

.. code-block:: text

    <init>;
    for do 
        <statements1> 
    while <test> do
        <statements2> 
    endfor

The syntax is slightly more verbose, it is true, but its highly 
modular nature means that it can easily express loops that are 
considerably more complicated. We believe that this is the right 
kind of practical trade-off. Yes, you need a couple of extra keywords 
to emphasize which parts are which because the form is less rigid, 
so people need a bit more help to see the structure. On the other 
hand, you don't get contorted loops riddled with breaks and continues. 

Iterating Over Linear Data: Arrays, Lists, Strings, StringBuffers, Sets, etc etc
--------------------------------------------------------------------------------

To iterate over the elements of an array means committing this "idiom" to memory 

.. code-block:: java

    for ( int i = 0; i < array.length; i++ ) {
        final TYPE element = array[ i ];
        S;
    }

But what about iterating over the same array in reverse?  You need to 
learn this.

.. code-block:: java

    for ( int i = array.length - 1; i <= 0; i-- ) {
        final TYPE element = array[ i ];
        S;
    }

Note the lack of symmetry. Note how the compiler has to work quite 
hard to determine that this is actually an iteration over the 
elements of an array (it has to deduce that array is not changed in 
``S``, that ``i`` is not changed in ``S``, and that the JVM code actually has 
this shape.) As a result, you cannot be sure that the array index 
is an index. 

But on the other hand, having learnt these idioms surely you can 
employ them for iterating over any data structure (as you sort 
of can in C++). No. There is a completely different idiom for iterating 
over a object. 

.. code-block:: java

    final Iterator it = obj.iterator(); 
    while ( it.hasNext() ) { 
        final TYPE element = (TYPE)it.next(); 
        S; 
    }

There is no satisfactory way to iterate over a collection in reverse. 

If you have a ``List``, you can generate a ``ListIterator`` and iterate 
in either direction *provided* you start the iteration from the 
front. 

To combine these two types of iterations is best done through 
the for loop. 

.. code-block:: java

    final Iterator it = obj.iterator(); 
    for ( int i = 0; i < array.length && it.hasNext(); i++ ) { 
        final TYPE1 element1 = (TYPE1) it.next(); 
        final TYPE2 element2 = array[ i ]; 
        S;
    } 

It's a mess but, on the other hand, there's nothing else to learn. 
Oh, I forgot. Not all of the data types have been updated to the 
new ``Iterator`` interface. ``StringTokenizer`` only implements the old 
``Enumeration`` interface. The idiom for that is 

.. code-block:: java

    final Enumerator en = obj.enumeration(); 
    while ( it.hasMoreElements() ) { 
        final TYPE element = (TYPE)it.hasNext(); 
        S; 
    } 

Combining the three types of iteration should be fairly easy, 
now we're getting the hang of this high level language. 

.. code-block:: java

    final Enumeration en = obj1.enumeration(); 
    final Iterator it = obj2.iterator(); 
    for ( 
        int i = 0; 
        i < array.length && 
        it.hasNext() && 
        it.hasMoreElements(); 
        i++ 
    ) { 
        final TYPE1 element1 = (TYPE1)it.hasNext(); 
        final TYPE1 element2 = (TYPE2) it.next();
        final TYPE2 element3 = array[ i ]; 
        S; 
    } 

So, all you have to do is learn the above example and you have got 
the hang of iterating in Java. Gruesome but not rocket science. 
Did I mention StringBuffers? No? Silly me! Of course ``StringBuffer`` 
is different. ``StringBuffer`` is a special purpose class so the 
way you iterate over that is, well, errr, special. ``StringBuffer`` doesn't 
implement ``Enumeration``, ``Iterator``, and isn't an array. The way 
you do it is almost but not quite the same as array iteration - you just 
have to remember that ``StringBuffer.length`` is a method, not an 
instance variable. Ready? 

.. code-block:: java

    for ( int i = 0; i < sbuffer.length(); i++ ) { 
        final char ch = sbuffer.charAt( i ); 
        S; 
    } 

And put the iteration idioms together ... 

.. code-block:: java

    final Enumeration en = obj1.enumeration(); 
    final Iterator it = obj2.iterator(); 
    for ( 
        int i = 0; 
        i < array.length && 
        i < sbuffer.length() && 
        it.hasNext() && 
        it.hasMoreElements(); 
        i++ 
    ) { 
        final TYPE1 element1 = (TYPE1)it.hasNext(); 
        final TYPE1 element2 = (TYPE2) it.next(); 
        final TYPE2 element3 = array[ i ]; 
        final char ch = sbuffer.charAt( i ); 
        S; 
    } 

OK, OK, OK, let's stop the striptease. There are a lot of other 
daft variations on iteration. The ``java.util.Random`` iteration looks 
like this ... 

.. code-block:: java

    final Random random = Random(); 
    do { 
        final boolean bit = random.nextBoolean(); 
    } while( true ); 

The ``java.util.StringTokenizer`` is one of the "old-fashioned" 
``java.util.Enumeration`` that haven't been converted to 
``java.util.Iterator``. But *no* serious Java programmer would 
use the enumeration interface. They would use the ``StringTokenizer`` 
iteration idiom which looks like this:

.. code-block:: java

    final StringTokenizer toks = new StringTokenizer( str, delim ); 
    while ( toks.hasMoreElements() ) { 
        final String tok = toks.nextToken(); 
        S; 
    } 

Iterating over a range of ``java.lang.Integer`` looks like this:

.. code-block:: java

    for ( int i = lo.intValue(); i < hi.intValue(); i++ ) { 
    final Integer j = new Integer( i ); 
        S 
    } 

But iterating over a range of ``java.math.BigInteger`` looks like 
this:

.. code-block:: java

    for ( 
        BigInteger i = lo; 
        i.compareTo( hi ) < 0; 
        i = i.add( java.math.BigInteger.ONE ) 
        ) S 

But iterating over a range of ``java.math.BigDecimal`` looks a little 
different (surprise!) because you don't create constants the 
same way:

.. code-block:: java

    final BigDecimal one = new BigDecimal( java.math.BigInteger.ONE ); 
    for ( 
        BigDecimal i = lo; 
        i.compareTo( hi ) < 0; 
        i = i.add( one ) 
        ) S 

And I almost forgot ``StreamTokenizer``:

.. code-block:: java

    final StreamTokenizer stok = new StreamTokenizer( reader ); 
    int stok_type; 
    while ( (stok_type = stok.next()) != java.io.StreamTokenizer.TT_EOF 
    ) { 
        S 
    } 

There are probably dozens of others - but who cares. The bottom 
line is that there is no unified concept of data structure iteration 
and there is a proliferation of idioms that implies Java programming 
is for experts only. 

Our running example looks like this 

.. code-block:: java

    final StreamTokenizer stok = new StreamTokenizer( reader ); 
    int stok_type; 
    final StringTokenizer toks = new StringTokenizer( str, delim ); 
    final Random random = Random(); 
    final Enumeration en = obj1.enumeration(); 
    final Iterator it = obj2.iterator(); 
    BigInteger bi = loBigInt; 
    for ( 
        int i = 0; 
        i < array.length && 
        i < sbuffer.length() && 
        it.hasNext() && 
        it.hasMoreElements() && 
        toks.hasMoreElements() && 
        bi.compareTo( hiBigInt ) && 
        (stok_type = stok.next()) != java.io.StreamTokenizer.TT_EOF; 
        i++, 
        bi = bi.add( java.math.BigInteger.ONE ) 
    ) { 
        final TYPE1 element1 = (TYPE1)it.hasNext(); 
        final TYPE1 element2 = (TYPE2) it.next(); 
        final TYPE2 element3 = array[ i ]; 
        final char ch = sbuffer.charAt( i ); 
        final boolean bit = random.nextBoolean(); 
        final String tok = toks.nextToken(); 
        S 
    } 

Iterating Over Maps
-------------------

And now we turn our attention to the next important type of 
iteration. Iterating over map-like structures. Here is the 
key idiom - iterating over ``java.util.Map``. 

.. code-block:: java

    final Iterator it = map.iterator(); 
    while ( it.hasNext() ) { 
        final Map.Entry maplet = (Map.Entry)it.next(); 
        final KEYTYPE key = (KEYTYPE)maplet.getKey(); 
        final VALTYPE val = (VALTYPE)maplet.getValue(); 
        S 
    }

Real-life Java programming gets one *very* familiar with this idiom, I must say. 
Not a very difficult idiom to commit to memory, one has to concede. 
But this won't work with the important ``java.util.Properties`` 
datatype because it is a ``Hashtable`` and not a ``Map``. 
You need to use this idiom. 

.. code-block:: java

    final Enumeration keys = prop.keys(); 
    while ( keys.hasMoreElements() ) { 
        final KEYTYPE key = (KEYTYPE)keys.nextElement(); 
        final VALTYPE val = (VALTYPE)prop.get( key ); 
        S 
    } 

Beginners might be tempted to get both ``Enumerations`` for the keys 
and values of the prop but they are not guaranteed to be synchronized. 

It is extremely likely that it will work in practice - so you need 
to remember it.

Iterating Over A File System
----------------------------

You *might* have thought that iterating over a file system would 
employ ``Map`` iteration idioms. But, by this stage, we've got the 
picture. 

