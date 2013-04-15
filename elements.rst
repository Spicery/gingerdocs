Elements
========

Start and End Tags
------------------
Elements are Ginger's deliberately simplified XML DOM model. These simplifications make elements very easy to use whilst keeping all the important functionality. Like lists and vectors, elements come in three different flavours: immutable, updateable (not implemented yet) and dynamic (not implemented yet).

Elements are objects that correspond to XML's elements. You usually create them with start and end tags, just like normal XML. For example::

	>>> mini_doc := <html><body><p> "Hello, world!" </p></body><html>;

One difference is that Ginger allows you to use the special close-anything tag '</>' to close any open tag. This is sometimes a small convenience when writing code but is actually provided to allow elements with dynamic names. So the above example could have been written like this::

	>>> mini_doc := <html><body><p> "Hello, world!" </></></>;

But the main difference from written XML, is that the start and end tags don't introduce a special 'CDATA' context. Instead they contain Ginger code! That's why the previous example contains a quoted string ("Hello, world!") rather than unquoted text. Although this means that they are less useful for writing the body text of an XHTML document, they are very handy for writing templates. (You can read more about this decision under the `design rationale for Element syntax`_.)

.. _`design rationale for Element syntax`: rationale_for_element_syntax.html

Start tags have a name and attributes, as you might example. So you can write expressions like this::

	<a href="http://github.com/Spicery/ginger.git"> "Ginger repo" </a>

However, you are not limited to string-valued attributes, any `atomic expression`_ for the attribute value will do. For example, numbers are legitimate values, as are symbols and characters::

	<table border=2> ... </table>

In what might look like a throwback to the early days of HTML, an unadorned variable will be treated as a literal symbol. If you want the value of the variable you should put it inside parentheses!::

	<table rules=rows frame=lhs> ... </table>

.. _`atomic expression`; atomic_expression.html

You can even dynamically determine the name of the start tag. This is another 'atomic' context which is normally literal but you can supply a general expression in parentheses. You will find the 'close-anything' end-tag useful in this case::

	<(if flag then `th` else `td` endif)> .... </>

N.B. Element names are normally symbols and the normal end-tag enforces that. If you use anything else, you will need the close-anything tag! 

XML-style Comments and Processing Directives
--------------------------------------------
Ginger allows XML-style comments and processing directives but discards them. This is to ease pasting large chunks of XML, so you don't need to go through by hand removing them::

	<!-- XML comments are allowed -->
	<p> "Thank goodness for that!" </p>


Printing as XML
---------------
The most important use of elements is to generate XML and XHTML output. You can send an element to a stream using print or println or convert it to a string using stringPrint. 

N.B. When you are typing at the command line, elements (and all other values too) are shown rather than printed. So what you see on the command line is similar but different to how they will print.


Template Example
----------------

Here's an example that turns a list into a table with a configurable border width::

	define asTable( list, border_width ) =>>
		<table border=(border_width)>
			for x in list do
				<tr><td> x </td></tr>
			endfor
		</table>
	enddefine;

And here's how it might be used::

	<html>
		<head> "Result List" </head>
		<body>
			computeResults().asTable( 1 )
		</body>
	</html>.println;


Functions for Building and Manipulating Elements
------------------------------------------------

N.B. the function newElement is deliberately not documented at the time
of writing since we'd like a chance to consider how the API is exposed before committing to it.

isElement( OBJECT ) -> BOOL
	Returns true if the OBJECT is an element, otherwise false.

nameElement( E ) -> OBJECT
	Return the name of the element. This is normally a `symbol`_ but
	could in fact be any value.

.. _`symbol`: symbols.html

for i in E do .... endfor
	Iterates over the children of an element in turn.

E[ N ] -> X
index( N, E ) -> X
	Returns the Nth child of an element.

E.attribute( KEY ) -> VALUE
	Returns the attribute of an element associated with a KEY. If not
	present then it return `absent`_.

.. _`absent`: absent.html

length( E ) -> N
	Returns the number of children of an element.

