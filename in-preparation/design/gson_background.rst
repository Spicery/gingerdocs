The Background to GSON: Gingerised JSON
=======================================
Stephen Leach <stephen.leach@steelypip.com>
:Date: August 2011

[The role of GSON in Ginger is under review. Various statements in this article are out of date.]

How It Started
--------------

GSON began from an idle moment, looking at JSON and wondering whether or not there was a connection with GNX, which is the simplified XML we use as an abstract syntax tree for Ginger. After some experimentation, I decided that it was worth defining an extension to JSON; the alternative would be to define an encoding in JSON but that isn't very useful.

If you don't know JSON take a look at http://www.json.org/ which is a really nice one-page introduction to it. In essence, JSON is a kind of S-expression notation for languages with C-syntax. It support three kinds of atomic values: strings, numbers and named constants (true, false, null). And it supports two compound types: an array and "object", which is actually a map from strings to values.


.. code-block:: text

    EXPR ::= PRIMITIVE | COMPOUND 
    PRIMITIVE ::= STRING | NUMBER | NAMED_CONSTANT
    COMPOUND ::= ARRAY | OBJECT 
    ARRAY ::= [ EXPR,... ]
    OBJECT ::= { (STRING : EXPR) ,... }


It took me a while to come up with GSON - an extension to JSON that I felt worked. There are lots of possible choices and quite a few of them look viable. 


Goals
-----

There were two goals. Firstly I wanted to be able to map any JSON term easily into its GNX equivalent. Secondly I wanted to be able to naturally represent any GNX term in JSON + as few extensions as I could. The important word here is "natural", meaning that I wanted to avoid special encoding tricks.

My eventual design had several extensions. My starting place was actually JSON-C because that adds in comments. Plenty of developers regard the lack of comments as an omission. JSON-C is a backward-compatible extension to JSON whose sole purpose is adding comments to JSON.

Extensions to GNX
-----------------

Probably the most significant change, from a design viewpoint, was that I decided to add a couple of forms to GNX to more directly support JSON. Strictly speaking these forms are superfluous but after some deliberation I felt that JSON's syntactic support for lists and maps was a reflection of the genuinely special role of those datatypes.

As a consequence I added these forms to GNX.

.. code-block:: text

    <list> ... </list>      =^=     <sysapp name="manyToList"> ... </sysapp>
    <map> ... </map>        =^=     <sysapp name="manyToMap"> ... </sysapp>

It is worth noting that the intention is that these constructs correspond to the lists and maps produced by Common's ``[...]`` and ``{...}`` syntax and hence generate immutable lists and maps. They are 'factory methods' that have free rein over how to implement those maps and lists, including whether or not they share with other equal maps and lists. 

The planned macro extension to GNX will include this as part of the standard macro package. 


Extensions to JSON
------------------

My first addition was a MNX elements. This needed a new compound form in JSON. It would be an unescaped element name followed by key=value attributes in angle-brackets, rather like an HTML tag, followed by the children in brackets. Either of the attribute part and children part may be omitted (but not both).

.. code-block:: text

    ELEMENT_NAME< ( NAME = STRING ),... >[ EXPR,... ]
    ELEMENT_NAME< ( NAME = STRING ),... >               // No children.
    ELEMENT_NAME[ EXPR,... ]                            // No attributes.

Here's an example:

.. code-block:: text

    Ginger:     if x then 1 else 2 endif
    GSON:       if[ x, 1, 2 ]
    GNX:        <if><id name="x"/><constant type="int" value="1"/><constant type="int" value="2"/></if>

The second decision was to generalise the JSON Object to support arbitrary maps. This meant generalising the ":" syntax to support general expressions on both sides. 

Thirdly, I generalised the small set of JSON named constants into variables. This has the side-effect that that GSON references true, false and absent via variables rather than literals. i.e.

.. code-block:: text

    GSON:       true
    GNX:        <id name="true"/>
    and NOT:    <constant type="bool" value="true"/>

It may be a good idea to add in a way of writing literal constants in the future, perhaps by adding the '#' character to access GNX system constants and functions. e.g. ``#newList`` becomes ``<sysfn name="newList"/>``.

Fourthly I added parentheses for function applications. It is preferable to write ``f(x,y)`` as ``app[ f, seq[ x, y ] ]``. This also included prefix parentheses. These are simply shorthand for "seq" so that ``(x, y)`` is simply shorthand for

.. code-block:: text

    GSON:   ( x, y )
    GNX:    seq[ x, y ]

Lastly I added a shorthand for writing lambda functions. In GNX, a lambda function is written as ``fn< ATTRIBUTES >[ ARGS, BODY ]``. To make the body stand out a little more, and to bring it into line with JavaScript, we are allowed to write this as below.

.. code-block:: text

    fn< ATTRIBUTES >( ARG, ... ){ EXPR, ... }
    fn< ATTRIBUTES >{ EXPR, ... }                 // No arguments = ().

