div and mod: Built-in functions
===============================
TODO: Document divmod properly, in particular the adherence to C++11 rules:

::
	A footnote to 5.6/4 said:

	[C++03 footnote 74]: According to work underway toward the revision of ISO C, the preferred algorithm for integer division follows the rules defined in the ISO Fortran standard, ISO/IEC 1539:1991, in which the quotient is always rounded toward zero.
	In C++11 this behaviour is explicitly required rather than being "preferred"; the change is listed in the compatibility section:

	[C++11: C.2.2]: 
	Change: Specify rounding for results of integer / and %
	Rationale: Increase portability, C99 compatibility.
	Effect on original feature: Valid C++ 2003 code that uses integer division rounds the result toward 0 or toward negative infinity, whereas this International Standard always rounds the result toward 0.
