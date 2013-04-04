Serving Web Pages: CGI Integration
==================================

The ginger-cgi executable runs the GVM as a `CGI`_ script. You use it just like the ginger-script tool, except that the HTTP parameters are automatically read in and can be processed by the script.

.. _`CGI`: http://en.wikipedia.org/wiki/Common_Gateway_Interface

CGI scripts access their environment in two ways: 

	*	Via environment variables. Use the ${variable} syntax to do that.
	*	Via the request parameters. Use the cgiValue system function to request these.

Example script
--------------

Here's a very simple "hello_world.cgi" script:
::

	#!/usr/local/bin/ginger-cgi -gcommon
	
	print( "Content-type: text/html\r\n\r\n" );
	println( "Hello, %p!", cgiValue( "name" ) );

And here is the result:
::

	steve% ./hello_world.cgi 
	Enter querystring or type 'i' for interactive mode'
	name=Steve
	Content-type: text/html

	Hello, Steve!

Using Elements
--------------
One of the main uses of `elements`_ is generating XHTML output. For example, an HTML version of Hello World would look like this.
::

	#!/usr/local/bin/ginger-cgi -gcommon
	
	print( "Content-type: text/html\r\n\r\n" );
	<html>
		<body>
			"Hello, %p!".stringf( cgiValue( "name" ) )
		</body>
	</html>

Notice how the character data is represented by a string. In fact you can use any item, which will be printed out using XHTML escaping.

And here is the result:
::

	steve% ./hello.cgi 
	Enter querystring or type 'i' for interactive mode'
	name=Steve
	Content-type: text/html

	<html><body>Hello, Steve!</body></html>

Note that applying the `print functions`_ to an element will generate proper XHTML output with correctly escaped characters.

.. _`elements`: elements.html
.. _`print functions`: print.html


Future Enhancements
-------------------
The CGI support is minimal at the time of writing. This is because our plans for enhancing this facility depend on a GVM feature that isn't stable as yet, called 

