Hello World, using the Common Syntax
------------------------------------

Here's the 'Hello World' program written in Ginger, along with some commentary
highlighting some interesting things. We have added line numbers for easy reference.

.. code::

    Line 1      # Prints a cheery message to the console.
    Line 2      define hello() =>>
    Line 3          println( "Hello, world!" )
    Line 4      enddefine

On Line 1 we write an end-of-line comment which is introduced with a hash symbol followed by a space. 
The hash-character is used for all the different ways of annotating code that don't change the 
meaning of code.

On Line 2 we introduce a function called 'hello'. Function definitions start with the keyword 'define' and are closed with the matching keyword 'enddefine'. This pairing of opening and closing keywords is a feature of the Common syntax. 

The function head is separated from the function body by an '=>>'. There are several places where this double-headed arrow is used in Common and it always signals that a function is being defined. 

On Line 3 we define the function body as calling the 'println' function on a literal string. The name 'println' is a contraction of 'PRINT then add a LiNe' and the function is part of the standard library (ginger.std) . Programmers do not have to import the standard library because it is available by default. 

String literals use double-quotes, just like C/C++/C#, Java, Javascript and so on. Single quotes are reserved for character literals.

On Line 4 we close the function with the 'enddefine' keyword. If you are working interactively you can abbreviate any keyword that starts with the prefix 'end' to just 'end'. This includes 'enddefine', 'endfn', 'endif', 'endfor'.

Lastly, Ginger supports more than one programming language syntax - this version of Hello, World is
written in the Common syntax. We designed Common to be a neat modern language that is easy to remember and accident-resistant. But you don't have to use it. We also designed a Javascript-inspired syntax too, if you prefer. 

.. code::

	Line 1		// This is the way you write the end-of-line comment with JS style syntax.
	Line 2      function hello() {
	Line 3      	println( "Hello, world!" )  // The library functions are the same though.
	Line 4      }

In future versions of Ginger we will add more syntaxes. It's quite easy to add new ones if 
would like to try. (Why did we make Ginger so flexible? Because one of the things we wanted to get away from was the idea that there was a single right answer.)
