Ginger XML: Transport Syntax for Ginger
=======================================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Created, June 2010

Revised, August 2010, May 2011, Feb 2013, Apr 2013


.. note:: Reader, please note that this is very much a work-in-progress. It is being written up as we design the relevant sections in appginger.

Ginger XML Overview
-------------------

The idea behind Ginger XML (\*.gnx) is to provide a representation of Ginger code that is neutral. By neutral we mean that it should be both human-readable and machine-friendly. Hence it should be easy for people with some computing background to understand the logic behind it, and easy for people to review but not necessarily write. It must also be easy for them to create programs, in their programming language of choice, that can read, transform and generate GinX. And it should be reasonably inexpensive to process, without that being an overriding consideration.

To balance these opposed concerns we borrowed from Lisp, especially Scheme. We selected a simplified subset of XML, called Minimal XML or MinX for short. MinX is loosely based on s-expressions, which made programming very straightforward. We then designed the elements around Lisp-style primitives. This gave us a very clean design because we did not have to make concessions to programming convenience - because this is a representation that is essentially only read and written by machines, not people. 

There are disavantages to this approach, of course, such as it being relatively verbose and therefore slowing down compilation. Yet on the whole we believe Ginger XML balances the relevant factors and is both effective and pleasing to use.


Element and Meta-attributes
---------------------------

Comment Attribute
~~~~~~~~~~~~~~~~~
Any element may have the optional 'comment' attribute. It is a free-text 
string intended to provide human-readable text. Its context is the node and 
all nested nodes.

Source File Attribute
~~~~~~~~~~~~~~~~~~~~~
Any element may have the optional 'source' attribute that describes the source 
file (or other source) of the element. It is a free-text string. It is 
considered to apply to all nested nodes.

e.g.

.. code-block:: text

    <bind source="hello.common">
        <var name="helloWorld" protected="true/>
        <fn> ... </fn>
    </bind>

Span Attributes
~~~~~~~~~~~~~~~

Any element may have optional 'from' and 'to' attributes that describe the span 
of text of the source file that the element derives from. Each should have 
the format::
    
	(<digit>+)[.(<digit>+)] 
        
The first group specifies the row number and the second the column.
N.B. the column number is optional.

If the 'from' attribute is specified then the 'to' attribute will default
to the same line number as the 'from' attribute, although any column will
be ignored.

e.g.

.. code-block:: text

	<app from="23.8" to="23.64"> .... </app>
    
Context Attributes
~~~~~~~~~~~~~~~~~~
Any element _may_ have an optional context.* attribute which will be printed
out to provide additional context. It will typically be a truncated version
of the spanned text.

Context - Grammar Role
......................
Any element _may_ be decorated with the grammatical role assigned by the parser.

.. code-block:: text

	if test then x else y endif ### may be decorated as follows.

	<if context.role="Conditional">
		<id name="test" context.role="Predicate"/>
		<id name="x" context.role="Then-part of Conditional"/>
		<id name="y" context.role="Else-part of Conditional"/>
	</if>

Context - Parameter Position
............................

Any expression that is passed as a parameter to a function application _may_ be decorated with its positional value and the name of the function (or description of the function expression) that it is statically called by. 

Arguments on the left hand side of the function are numbered negatively, arguments on the right hand side are numbered positively.

.. code-block:: text

	x.f( y, z ) 	### Original expression.

	<app>
		<id name="f"/>
		<seq>
			<id name="x" context.posn="-1" arg.caller="f"/>
			<id name="x" context.posn="1" arg.caller="f"/>
			<id name="x" context.posn="2" arg.caller="f"/>
		</seq>
	</app>


Statements
----------

Syntax
~~~~~~

.. code-block:: text

	STMNT ::=
		DECLARATION
		EXPR

Expressions
-----------

Syntax
~~~~~~

.. code-block:: text

	EXPR ::=
		CONSTANT            ### any literal constant
		VARIABLE            ### reference to a variable
		ASSIGNMENT          ### assignment to a variable
		SEQ                 ### sequence of expressions (comma/semi separated)
		BLOCK               ### introduces a new scope
		FUNCTION            ### a function
		APP                 ### function application
		CONDITIONAL         ### if/unless
		LOOP                ### for loops
		LIST 				### list expressions
		VECTOR				### vector expressions
    

Constants
---------

Description
~~~~~~~~~~~

Constants are characterised by having element name 'constant' and 'type' 
and 'value' attributes. Constants always
represent a single IMMUTABLE value. N.B. The compiler is free to share 
instances of these constants which are equal to each other. 

Note that the "type" attribute doesn't correspond to the class name you may have expected. This is a hangover from early development before the class names were stablised.

Syntax
~~~~~~

.. code-block:: text

	CONSTANT ::=
		<constant type="absent" value="absent"/>              ### The absent singleton
		<constant type="bool" value=("true"|"false")/>        ### Booleans
		<constant type="indeterminate" value="indeterminate"> ### The indeterminate singleton
		<constant type="int" value=TEXT/>                     ### +/- arbitrary precision
		<constant type="float" value=TEXT/>                   ### We might unify numbers?
		<constant type="string" value=TEXT/>                  ### Immutable strings
		<constant type="symbol" value=TEXT/>                  ### Symbols
		<constant type="char" value=TEXT/>                    ### A single character
		<constant type="sysfn" value=TEXT/>                   ### Named procedure
		<constant type="sysclass" value=TEXT>                 ### Named class
		<constant type="undefined" value="undefined">         ### The undefined singleton

		
    
Examples
~~~~~~~~

.. code-block:: xml

	<constant type="int" value="123"/>
	<constant type="float" value="1.2"/>
	<constant type="string" value="qwertyuiop"/>    
	<constant type="char" value="A"/>
	<constant type="sysfn" value="+"/>
    
N.B. Character sequences are multi-valued constants. They are represented as
a sequence of characters.

.. code-block:: xml

	<seq>
		<constant type="char" value="a"/>
		<constant type="char" value="b"/>
		<constant type="char" value="c"/>
	</seq>
    

Available Named Procedures
~~~~~~~~~~~~~~~~~~~~~~~~~~

Note that these constants are not necessarily bound to identifiers in Ginger. 
These constants are intended as direct support for built-in operators (e.g.
arithmetic) and syntactic forms such as list construction, string interpolation, 
and so on. Here are some examples::

	<constant type="sysfn" value="+"/>                  ### }
	<constant type="sysfn" value="-"/>                  ### }
	<constant type="sysfn" value="*"/>                  ### }- standard arithmetic
	<constant type="sysfn" value="/"/>                  ### }
	<constant type="sysfn" value="head"/>
	<constant type="sysfn" value="newList"/>
	<constant type="sysfn" value="newVector"/>
	<constant type="sysfn" value="newMap"/>             
	<constant type="sysfn" value="not"/>                ### Boolean negation
	<constant type="sysfn" value="tail"/>
    
It is intended that all the members of this list are guaranteed to be
available from the "std" package. Hence they are functionally equivalent to

.. code-block:: xml

	<id name=NAME def.pkg="ginger.library"/>


Furthermore, it is important to note that these constants do not have to be implemented efficiently. Compiler writers are permitted to implement these as lambda forms. For example a system function 'foo' of 1 argument might be implemented like this:

.. code-block:: text

	### permitted possible implementation of unary sysfn called 'foo' 
	<fn title="foo">
		<var name=”x”/>
		<sysapp name="foo">
			<id name=”x”/>
		</sysapp>
	</fn>

In particular it is explicitly permitted that each use of a sysfn _may_ return a different object.

Available Named Classes
~~~~~~~~~~~~~~~~~~~~~~~

There is a built-in class for every type of built-in value, although they are
not necessarily bound to identifiers in Ginger. Examples::

	<constant type="sysclass" value="Absent"/>          ### class for absent
	<constant type="sysclass" value="Bool"/>            ### class for true & false
	<constant type="sysclass" value="Small"/>           ### class for 'small' integers
	<constant type="sysclass" value="Double"/>          ### class for doubles
	<constant type="sysclass" value="String"/>          ### class for strings
	<constant type="sysclass" value="Char"/>            ### class for characters
	<constant type="sysclass" value="Nil"/>             ### class for nil
	<constant type="sysclass" value="Pair"/>            ### class for list pairs
	<constant type="sysclass" value="Vector"/>          ### class for vectors
	<constant type="sysclass" value="Class"/>           ### class for classes

Note that classes are not exactly he same as types. All function objects share
the same class but may have entirely different types.

    
Variable Reference
------------------

Notes: We have to add in name qualification e.g. nicknames. We also should consider
a way of allocating local variables guaranteed never to clash with local
variables created by the programmer. Maybe have an extra hidden dimension on 
names??

Note: there are three ways by which a global variable might be referred by.
 1.	A qualified reference, using the alias attribute
 2.	An unqualified reference, using the enc.pkg (enclosing package) attribute
 3.	An absolute reference, using the def.pkg (defining package) attribute

Syntax
------

.. code-block:: text

	VARIABLE ::=
		<id name=NAME 
			[enc.pkg=PACKAGE_NAME ]
			[def.pkg=PACKAGE_NAME | alias=NICKNAME	 ]
		/>


Assignments
-----------

Description
~~~~~~~~~~~
N.B. Assignment runs from left-to-right, not following the usual convention. The destination expression may be a complex assignable expression.

Syntax
~~~~~~

.. code-block:: xml

	<set> SRC_EXPR DST_EXPR </set>

Sequences & Blocks
------------------

Overview
~~~~~~~~

Sequences are used to create a sequence of expressions. Blocks are sequences with the additional property that they introduce a new scope. 

Syntax
~~~~~~

.. code-block:: xml

	SEQ ::=
		<seq> EXPR* </seq>
	BLOCK ::=
		<block> EXPR* </block>

    
Function Applications
---------------------

Syntax
~~~~~~

.. code-block:: xml

	APP ::=
		<app> EXPR EXPR </app>       
		<sysapp name=NAME> EXPR* </sysapp> 
                                            

SysApps
~~~~~~~
SysApp's are invocations of the built-in functions. Each built-in function is named and can be referred to via

	* <sysapp name=NAME> EXPR* </sysapp>, which compiles into a function call
	* <constant type="sysfn" name=NAME/>, which will compile into a function object
	* <id def.pkg="ginger.library" name=NAME/>, which will compile into a variable
	  that references a function object.

Of these three methods, only the direct function call is guaranteed to be efficient. The other two forms are permitted to be relatively inefficient. In support of this, the compiler writer is allowed to make reasonable assumptions to help performance e.g. the call may be inlined, 
computed at compile-time, overflow checking may be deferred until the end of the parent block, no debug information may be available, the garbage collector may be blocked, and so on. 

Note that it is also guaranteed that direct calls of sysfns will be as efficient as sysapps.

.. code-block:: text

	### This form will be treated as a sysapp.
	<app><sysfn value="foo"/> ... </app>

Effectively it turns into

.. code-block:: text

	<sysapp name="foo"> ... </sysapp>

See `sysapps in detail`_ for more information.

.. _`sysapps in detail`: ../help/sysapp.html



Conditionals
------------

Notes: In progress - I am designing these as multi-part ``if/then/elseif/../else/endif``
forms. This means they are an easy target for compiling switches. Short
circuits need to be fleshed out.

Syntax
~~~~~~

.. code-block:: text

	CONDITIONAL ::=
		<if> ( IF_PART THEN_PART )*  [ELSE_PART] </if>
		<and> EXPR* </and>
		<or> EXPR* </or>
		<absand> EXPR* </absand>                          ### &&
		<absor> EXPR* </absor>                            ### ||
		
	IF_PART ::= EXPR
	THEN_PART ::= EXPR
	ELSE_PART ::= EXPR

.. code-block:: text

	SWITCH ::=
		<switch> VALUE_PART ( CASE_VALUE CASE_BODY )* [ ELSE_PART ] </switch>

	VALUE_PART ::= EXPR
	CASE_VALUE ::= EXPR 
	CASE_BODY  ::= EXPR
	ELSE_PART  ::= EXPR


For Loops
---------

Notes: This is work in progress. In time the STMNTS will be subsumed into the QUERY itself. That is a step too far at the time of writing. Similarly the plan is to permit top-level queries, whereas right now only bindings are permitted at top level, and if-then-else and switches will also be treated as query-solvers.

Syntax
~~~~~~

.. code-block:: text

	LOOP ::= <for> QUERY STMNTS </for>
		
	QUERY ::= 
		<bind> PATTERN EXPR </bind>
		<from> PATTERN FROM_EXPR [ BY_EXPR [ TO_EXPR ] ] </from>
		<in> PATTERN EXPR </in>


List Expressions
----------------

Description
~~~~~~~~~~~

Lists are implemented as singly linked chains. The list syntax is a shorthand for calling the 'newList' function. The lists that are constructed are guaranteed to be immutable and may or may not share. The empty list 'nil' is guaranteed to be unique.

Syntax
~~~~~~

.. code-block:: text

	LIST ::= <list> EXPR* </list>

Vector Expressions
------------------

Description
~~~~~~~~~~~

Vectors are implemented as contiguous arrays. The vector syntax is a shorthand for calling the 'newVector' function. The vectors that are constructed are guaranteed to be immutable and may or may not share. 

Syntax
~~~~~~

.. code-block:: text

	VECTOR ::= <vector> EXPR* </vector>


Declarations and Patterns 
-------------------------

Overview
~~~~~~~~

Declarations match a pattern with an expression - patterns being limited 
expressions that contain pattern variables. N.B. The intention is to fit
this to the pattern/query proposal.

.. code-block:: text

	<bind>
		PATTERN
		EXPR
	</bind>

Syntax
~~~~~~

.. code-block:: text

	<bind>
		PATTERN
		EXPR
	</bind>

A PATTERN is any of the following

.. code-block:: text

	PATTERN ::= PATTERN_VAR | PATTERN_ANON | PATTERN_SEQ | PATTERN_APP | PATTERN_CONST
		
	PATTERN_VAR ::=
		<var 
			name=NAME 
			[(match|type)=TYPE_EXPR] 
			[protected=BOOL] 
			[enc.pkg=PACKAGE_NAME]
			[def.pkg=PACKAGE_NAME |
			 qualifier=ALIAS_NAME ]
			( (tag0|tag1|..)=TAG_VALUE )* 
		/>

	PATTERN_ANON ::=
		<var/>

.. note::  Qualifier or alias? We have some terminological confusion from different rounds of discussion being exposed.

.. code-block:: text

	PATTERN_SEQ ::=
		<seq> PATTERN* </seq>
			
	PATTERN_CONST ::=
		EXPR
	
	PATTERN_APP ::=
		<app> EXPR PATTERN </app>
        


.. note:: At the time of writing we have not implemented PATTERN_CONST or PATTERN_APP.

Pattern Variables
~~~~~~~~~~~~~~~~~
These are the most basic and familiar types of pattern. They introduce an optionally typed variable. The protected attribute plays the same role as in Pop-11, protecting the variable from assignment (n.b. this is shallow rather than deep protection.)

``name=NAME`` The "name" attribute is optional. If it is omitted then it is an anonymous variable.

``type=TYPE_EXPR`` The type-check will be made BEFORE assignment  and a failed type-check will generate an error.

``match=TYPE_EXPR`` The type-check is made BEFORE the assignment and failure will cause the matcher to backtrack.

``protected=BOOL`` If “true” variable is protected against subsequent  assignments. Generated by val and define declarations. If “false” the variable may be assigned to. If omitted the default is “true”. 

Top level variables may also be given tags and package qualifiers. 

``tagN=TAG_VALUE`` Tags the variable.

``qualifier=ALIAS`` The name is qualified by an import alias.

``pkg=PACKAGE_NAME`` The package name is an absolute reference to a package.

Comment! Qualifier or alias!

Note: we also need to cope with forward declarations.

As a Query
~~~~~~~~~~
A bind declaration is a type of query that either fails or succeeds once. 
In particular this loop would execute precisely once:

.. code-block:: text

	<for>
		<bind>
			<var name="foo"/>
			<absent value="absent"/>
		</bind>
		STATEMENTS
	</for>


Examples
~~~~~~~~

.. code-block:: text

	### Note that var/val introduces a query in Ginger. The '=' operator
	### is a query operator whose LHS is a pattern. Identifiers are
	### parsed as pattern-variables within a pattern, taking on the
	### default protection of the var/val.
	var x = 99;
	<bind><var name="x"/><constant type="int" value="99"/></bind>
		
	### The identifiers can given overrides for protection or type.
	val [ x, var y, z : bool ] = f();
	<bind>
		<app>
			<id name="newList">
			<seq>
				<var name="x" protected="true"/>
				<var name="y" protected="false"/>
				<var name="z" type="bool" protected="true"/>
			</seq>
		</app>
		<app><id name="f"/></app>
	</bind>
		
	### Ensure that p returns a single value which is an integer.
	val _ : int = p();      
	<bind>
		<var type="int" protected="true"/>
		<app><id name="p"/></app>       
	</bind>
		
	### The 'define' form also introduces an implicit PATTERN = EXPR
	### bindings where EXPR will be the arguments to the function.
	define K( x )( y ) => x enddefine;
	<bind><var name="K"/><fn name="K"><var name="x"/><fn><var name="y"/><id name="x"/></fn></fn></bind>
		

Packages and Imports
--------------------

.. note:: This section did not reflect the current implementation and needs further discussion. In practice the fetchgnx tool discharges the packages and imports before the Ginger Virtual Machine gets to see them. As a consequence it has been moved aside to `Packages and Imports`_.

.. _`Packages and Imports`: ../help/packages_and_imports.html
