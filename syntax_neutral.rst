Syntax Neutral
==============

TODO: Needs rewriting

Apart from performance, one of the interesting aspects of the Ginger virtual machine is that its input is an easy-to-generate subset of XML. For example the equivalent of Pop-11's ``if f( 0 ) then p else q endif( false )`` would be:

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

Being syntax neutral supports several goals of the project. Firstly it means that programmers can revise the syntax to meet their needs or personal preferences. And we provide several front-end syntaxes so that, right from the start, programmers aren't boxed into a particular design of syntax that they might find distasteful. Finally It supports domain-specific languages without the constraints of a parent language. 
