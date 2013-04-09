showMe: built-in function
=========================

The showMe function is a kind of printing function that's intended to help with debugging and program development. It aims to generate output that, if compiled, would yield an equivalent value to the original. As a consequence, the output exposes all the contents of the value being printed.

Example::

	>>> showMe( [ "One", 2, [% `three`, '4'%], { 5.0 => true } ] );
	["One", 2, [%`three`, '4'%], {5 => true}]

Limitations
-----------
Although showMe is accurate for the built-in types, it does not properly cover user-defined types at the time of writing. 