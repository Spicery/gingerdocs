Returning Zero, One, Two or More Values from a Function
-------------------------------------------------------
In a lot of programming languages there's a big difference between how you make a function return no values, one value, two values, or more. In Ginger you just list the values you want to return. 

.. code-block:: Common

    # No results.
    define foo() =>> enddefine

    # One result - a number.
    define foo() =>> 99 enddefine

    # Two results - a number and a boolean. Simply list them.
    define foo() =>> 99, false enddefine

    # Three results - a number, a boolean and a string.
    define foo() =>> 99, false, "OK" enddefine


For comparison, here's how it looks in Java. 

.. code-block:: Java

    // No results. Use void to declare no values are returned.
    void foo() {}
    
    // One result. Use return and declare the result.
    int foo() { return 99; }

    // Two results. Use the built-in but obscure Pair class.
    import java.javafx.util.Pair;
    Pair< Integer, Boolean > foo() { 
        // But this won't generalise to three values of different types.
        return new Pair<>( 99, false ); 
    }

    // Three results, even clumsier.
    import java.javafx.util.Pair;
    Pair< Integer, Pair< Boolean, String > > foo() {
        return new Pair<>( 99, new Pair<>( false, "OK" ) );
    }    

Swapping Two Variables
----------------------
The idea that an expression can return more than one value comes in handy in 
lots of different ways. Swapping variables is especially easy.

.. code-block:: Common

    # Assignment uses the '<-' symbol, not equals.
    ( y, x ) <- ( x, y )

This avoid the nuisance of having to introduce an intermediate variable of
the same type, as you would in Java.

.. code-block:: Java

    int tmp = x;
    x = y;
    y = tmp;


