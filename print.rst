print, println & stringPrint: Built-in functions
================================================

.. code-block:: common
	
	OUT.println( ITEM, ... )
	OUT.print( ITEM, ... )

Where
	* OUT = optional output stream.
	* ITEM = any value.

Basic Functionality
-------------------
The print and println functions are used to generate readable plain text. If an output stream is supplied as the first argument, the plain text is sent to there; otherwise it is sent to the standard output. The stringPrint function generates the same plain text but instead of sending to a stream, builds a string containing that text.

It is important to appreciate that these functions are different from the `showMe functions`_, which provide a textual representation that reveals the structure of a datum. These functions are about writing human friendly text.

.. _`showMe functions`: show.html

As a consequence, the way an item is printed is determined by a 'natural' mapping to text. Strings, symbols and characters have their contents printed without quotes. Lists & vectors have their contents treated as as unordered & ordered lists respectively, maps as description lists - the precise format depending on context (see below). Elements are treated as XHTML expressions and printed accordingly (also see below). 

Other values that don't have a natural text interpretation are printed in a short form to assist with debugging.

Printing Lists and Vectors 
--------------------------
Lists and vectors are used to represent lists of values. These are output with bullets or numbers respectively and indented in a natural way.

Examples::

	>>> println( [ "apples", "bananas", "free range eggs" ] );
	[1] apples
	[2] bananas
	[3] free range eggs
	>>> println( [ "Fruit", [% "apples", "bananas" %], "Others", [% "biscuits", "washing powder", "free range eggs" %] ] );
	[1] Fruit
	      * apples
	      * bananas
	[2] Others
	      * biscuits
	      * washing powder
	      * free range eggs

This is intended for quickly laying out nested lists of items. When occurring inside an Ginger element, lists and vectors are printed as XHTML. They turn into <ul> & <ol> elements respectively.

Printing Maps
-------------
Maps generate a different kind of list, usually called a description list. These consist of a sequence of 'bullet' points where each bullet is a keyword.

Example::

	>>> println( { "left" => "right", "black" => "white" } );
	  * black: white
	  * left: right

When occurring inside an Ginger element, maps are printed as XHTML. They turn into <dl> elements.

Printing Elements
-----------------
Ginger elements are used for generating XML output, typically XHTML. The children are printed out recursively in a form that is natural for XHTML. The values that are printed differently are:

	* 	Strings, symbols and characters are printed witout quotes and 
		XHTML escaping rules are applied to <, >, ", &.

	*	Lists are printed as <ul> elements.

	* 	Vectors are printed as <ol> elements.

	*	Maps are printed as <dl> elements with the keys being used for 
		the description title (<dt>) and the values for the description 
		data (<dd>).

