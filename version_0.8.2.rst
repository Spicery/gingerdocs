Ginger Version 0.8.2
--------------------

Curry'd Function Definitions Supported
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Both Common syntax and C-style syntax support "Currying", which means writing a definitions as a chain of function applications like this:

    # Common.
    define K( x )( y ) =>> x enddefine;

    //  C-style.
    function K( x )( y ) { return x; }

This will be very familiar to people used to functional programming, where it is the normal way of writing multiple arguments. It can be employed to write very compact and elegant code.


Binding/Assigning to Multiple Variables Implemented
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Common and C-style syntax now support binding of multiple variables at the same time. For example:

    # Common.
    ( x, y ) := 'ab';

    # C-style
    val ( x, y ) = 'ab';

The same applies to assignment e.g.

    var p := _;
    var q := _;
    ( p, q ) ::= ( false, true );

Common and C-Style Syntax get literal percentages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A double may be written with a terminating "%". This has the meaning of multiplying the value by 0.01. 

    >>> 50%;
    There is one result.
    1.  0.5


Dummy Variable Syntax Now Supported
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Both Common and C-style syntax now support anonymous/dummy variables. Any variable whose name begins with an underscore (e.g. _dummy) acts like never-to-be-reused reference to a variable. 

The main purpose of a dummy variable is primarily to silently discard some unwanted values. The name of a dummy variable is insignificant at runtime but only allowed to assist writing self-commenting code and debugging.

The secondary purpose is that, when used for its value, all dummy variables evaluate to absent. 

Example:

        >>> ( alpha, _, beta, _, gamma ) := 'uvwxy';
        >>> alpha, beta, gamma;
        There are 3 results.
        1.  'u'
        2.  'w'
        3.  'y'


Simple stream i/o
~~~~~~~~~~~~~~~~~

TODO: newInputStream, newOutStream

showMe, renaming and bug fixes of show function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two basic ways of formatting Ginger values into a stream: via the print family or the showMe family. The showMe functions try to format the object as if it was a literal expression in the source programming syntax.

Ideally showMe will generate output that can be fed back into the (current) compiler to re-generate the value. As a consequence, each language should have its own definition of this.

The showMe function has an alias (showln). It is implemented in terms of the
underlying sysPrint function (previously show).

The showMe function has become the default way of printing results.

Configurable Result Printing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
It is now possible to configure the way results are printed via a new
user settings file:

    ~/.config/ginger/settings.gson

The strings exploit the new, basic formatted print functions.

The format of that file is a limited version of the planned GSON (Ginger Simple Object Notation) format, which is a strict superset of JSON (see http://json.org/).

A default settings.gson file can be generated using 

    ginger-admin --settings


Basic formatted printing via printfln, printfln, stringf
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO:

showMeRuntimeInfo() built-in function (cf phpInfo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The system function "showMeRuntimeInfo" is designed to conveniently print contextual information about the Ginger running environment, working rather like PHP's phpInfo command. It's a blunt instrument that is occasionally just what is needed.


    >>> showMeRuntimeInfo();
    Application Environment
    -----------------------
    * Startup mode: Shell

    Main
    ----
    * Ginger version: 0.8.2-dev
    * VM Implementation ID: 1
    * Garbage collection tracing: disabled
    * Code generation tracing: disabled
    * Reading standard input: 0
    * Level of print detail: 3
    * Showing welcome banner: disabled
    * Interactive package: ginger.interactive
    * Default syntax: cmn

    .... (deleted) ...


The Erase and Dup family of built-in functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Two families of 'stack manipulation' functions have been added. The dup-family are useful for duplicating all or some of the arguments they are passed. The erase-family are useful for discarding all or some of the arguments they are passed.

    dupAll( V1, ..., Vn ) returns ( V1, ... Vn, V1, ... Vn )
    dupFirst( V1, ..., Vn ) returns ( V1, ... Vn, V1 )
    dupAllButFirst( V1, ..., Vn ) returns ( V1, ... Vn, V2, ... Vn )
    dupLast( V1, ..., Vn ) returns ( V1, ... Vn, Vn )
    dupAllButLast( V1, ..., Vn ) returns ( V1, ... Vn, V1, ... Vn-1 )
    dupLeading( V1, ..., Vn, k ) returns ( V1, ..., Vn, V1, ... Vk )
    dupAllButLeading( V1, ..., Vn, k ) returns ( V1, .. Vn, Vk+1 ... Vn )
    dupTrailing( V1, ..., Vn, k ) returns ( V1, ... Vn, Vn-k+1, ... Vn)
    dupAllButTrailing( V1, ... Vn, k ) returns ( V1, ... Vn, V1, ... Vn-k )

    eraseAll( V1, ..., Vn ) returns ()
    eraseFirst( V1, ..., Vn ) returns ( V2, ..., Vn )
    eraseLast( V1, ..., Vn ) returns ( V1, ..., Vn-1 )
    eraseAllButFirst( V1, ..., Vn ) returns ( V1 )
    eraseAllButLast( V1, ..., Vn ) returns ( Vn )
    eraseLeading( V1, ..., Vn, k ) returns ( Vk+1, ... Vn )
    eraseTrailing( V1, ..., Vn, k ) returns ( V1, ..., Vn-k )
    eraseAllButLeading( V1, ..., Vn, k ) returns ( V1, ... Vk )
    eraseAllButTrailing( V1, ..., Vn, k ) returns ( Vn-k+1, ... Vn )

gvmtest: New Virtual Machine Test Tool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The gvmtest tool is only intended for testing the implementation of the 
C++ API to first class GVMs. It allows stack inspection, heap inspection,
manual code generation and compilation. 

The available commands are listed below:

    <registers/>                     <help topic="registers"/>
    <peek/>                          <help topic="peek"/>
    <stack.clear/>                   <help topic="stack.clear"/>
    <stack.length/>                  <help topic="stack.length"/>
    <stack/>                         <help topic="stack"/>
    <heap.crawl/>                    <help topic="heap.crawl"/>
    <gc/>                            <help topic="gc"/>
    <compile> GNX </compile>         <help topic="compile"/>
    <code> INSTRUCTION* </code>      <help topic="code"/>

It is intended that this work contributes usefully towards the C++ API & integration with a Python module.

All Major Features documented
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the features listed on the overview.rst page are now expanded in their own short articles. 

Under the hood
~~~~~~~~~~~~~~

Numerous refactorings & bug fixes.
    
    *   Refactoring: Eliminating the use of C's printf and related functions 
        in favour of C++ stream i/o.
    *   Removed some badly out of date documentation (README.rst for example)
    *   Fixed linker issue that was cutting out self-registering built-ins.
    *   Improved error messages in some VM instructions.
    *   Calling local variables generated incorrect code, fixed.
    *   Renamed some VM instructions so they are more obvious what they do.
    *   Added new and more efficient VM call instructions.
    *   Fixed defect in --debug=showcode arising from the data-pool change.
    *   ginger-cli errors in exception catching fixed.
