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

	#!/usr/local/bin/ginger-cgi
	
	print( "Content-type: text/html\r\n\r\n" );
	println( "Hello, World! ", cgiValue( "name" ) );

And here is the result:
::

	steve% ./hello_world.cgi 
	Enter querystring or type 'i' for interactive mode'
	name=Steve
	Content-type: text/html

	Hello, World! Steve


