Ginger Version 0.8.2
--------------------

Curry'd Function Definitions Supported
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO:
    define K( x )( y ) =>> x enddefine;

Binding to Multiple Variables Implemented
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO:
    ( x, y ) := 'ab';

Common and C-Style Syntax get literal percentages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO:
    steve% ginger
    Ginger: 0.8.2-dev, 2013-04-02, Copyright (c) 2010  Stephen Leach
    +----------------------------------------------------------------------+
    | This program comes with ABSOLUTELY NO WARRANTY. It is free software, |
    | and you are welcome to redistribute it under certain conditions.     |
    | Use option --help=license for details.                               |
    +----------------------------------------------------------------------+
    >>> 50%;
    There is one result.
    1.  0.5



Anonymous Variable Syntax Now Supported
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO:
    Q: do we support dummy names?
    Q: does it work as an update target?
        Q: in multiple assignment
    Q: can it be used to push absent?

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

gingerInfo() built-in function (cf phpInfo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: gingerInfo


The Erase and Dup family of built-in functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: 

EXPR.dupAll
EXPR.dupFirst()
EXPR.dupAllButFirst()
EXPR.dupLast()
EXPR.dupAllButLast()
EXPR.dupLeading( N )
EXPR.dupAllButLeading( N )
EXPR.dupTrailing( N )
EXPR.dupAllButTrailing( N )

EXPR.eraseAll, 
EXPR.eraseFirst( N ), 
EXPR.eraseLast( N ), 
EXPR.eraseAllButFirst( N ), 
EXPR.eraseAllButLast( N )
EXPR.eraseLeading( N )
EXPR.eraseTrailing( N )
EXPR.eraseAllButLeading( N )
EXPR.eraseAllButTrailing( N )

gvmtest: New Virtual Machine Test Tool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: stack inspection, heap inspection, low level code generation, GNX evaluation. Working towards C++ API & Python module.

All Major Features documented
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the features listed on the overview.rst page are now expanded in their own articles.

TODO:
    Add new features:   
        Coroutines
        First class VMs
        Default parameters
        Bags
        Priority queues
        Variadic parameters
        Partial application
        Autolocation
        Autoimports
        Updaters
        Alternative returns
        Rollbacks, Failovers, Panics
        Lisp Syntax
        CGI Integration
        Full Unicode integration
        Regular expressions


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
