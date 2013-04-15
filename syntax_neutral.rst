Syntax Neutral
==============
Ginger has been designed to be 'syntax neutral' from the outset. By this we mean that:

  * You can program Ginger in any of several human-friendly syntaxes.
  * The Ginger virtual machine doesn't prefer ANY human-friendly syntax over any other. There's not even a preferred default syntax.
  * The virtual machine itself consumes GNX, a minimal XML syntax reminiscent of Lisp, that is designed to be machine-friendly and not produced by humans.
  * You can easily add new human-friendly syntaxes by supplying a parser, written in any language you like, that generates GNX. _And_ it is practical to do that with a modest amount of effort.

Being syntax neutral supports several high level goals of the Ginger project. Firstly it means that programmers can revise the syntax to meet their needs or personal preferences. And we provide several front-end syntaxes so that, right from the start, programmers aren't boxed into a particular design of syntax that they might find distasteful. Finally It supports domain-specific languages without the constraints of a parent language. 


About GNX, GiNger XML
---------------------
GNX is an easy-to-generate subset of XML. For example the equivalent of Pop-11's ``if f( 0 ) then p else q endif( false )`` would be:

.. code-block:: xml

    <app>
       <if>
             <app>
                 <id name="f" />
                 <int value="0" />
            </app>
            <id name="p" />
            <id name="q" />
        </if>
        <constant type="bool" value="false" />
    </app>

