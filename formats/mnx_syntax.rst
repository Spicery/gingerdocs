﻿==============================================================
MinX: Minimal XML, the Neutral Syntax for the Ginger Toolchain
==============================================================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Created, July 2011

.. note:: Reader, please note that this is very much a work-in-progress.


Overview
--------

MinX stands for “Minimal XML" and that’s pretty much what it is. It is a deliberately cut down XML. It has start and end tags, comments and nothing else. 

So this is valid MinX

.. code-block:: xml

    <seq>
        <!-- Just the string -->
        <constant type="string" value="Hello, world!"/>
    </seq>


And this is not, with the offending elements highlighted.

.. code-block:: xml

    <?xml version="1.0"?>
    <!DOCTYPE PARTS SYSTEM "parts.dtd">
    <?xml-stylesheet type="text/css" href="xmlpartsstyle.css"?>
    <PARTS>
       <TITLE>Computer Parts</TITLE>
       <PART>
          <ITEM>Motherboard</ITEM>
          <MANUFACTURER>ASUS</MANUFACTURER>
          <MODEL>P3B-F</MODEL>
          <COST> 123.00</COST>
          <DESCRIPTION><![CDATA[[<to be done>]]></DESCRIPTION>
       </PART>
    </PARTS>


Just to give you a flavour of how MinX encourages you to structure data, the above example would probably be encoded more like this.

.. code-block:: xml

    <PARTS TITLE='Computer Parts' >
       <PART>
          <ITEM NAME='Motherboard' />
          <MANUFACTURER NAME='ASUS' />
          <MODEL NAME='P3B-F' />
          <COST VALUE='123.00' />
          <DESCRIPTION VALUE='&lt;to be done&gt;' />
       </PART>
    </PARTS>

Caveat
------
One aspect of XML that these examples don’t illustrate is namespaces. At present MinX does not permit namespaces but we might change our minds on that.

Namespaces complicate the API significantly without adding anything we need at the moment. But they are perfectly sensible feature and compatible with our design criteria. 

Motivation
----------
MinX is our realisation of syntax neutrality. By “syntax neutral" we mean that we have a no-frills data format that can be processed with reasonable ease in a very wide variety of programming languages, can be read by programmers and, at a pinch, written as well. We mean that it is free of features that strongly favour people from one particular background. In other words, we have aimed to make it accessible to a very wide range of people, without bias, to the best of our judgement.

So what was the motivation behind stripping XML down to create MinX? XML was a reasonable basic choice because it is designed to be machine processable, has become very widely known and there are a lot of languages providing XML support out of the box. There were two basic reasons that strongly pushed in the direction of no-frills.

Firstly, as soon as you start writing programs to process XML you realise it is a surprisingly complicated format. Not only do you have to worry about basic feature such as processing directives but also management issues such as validation against schemas (and what format will the schema be in?) When all you want to do is represent data, you become engaged in complexities that aren’t relevant - such as CDATA blocks.

Secondly, full XML has some quite undesirable properties. A good example is that you cannot safely indent XML because it is not safe to insert or remove whitespace between tags.  Another example is that entity processing means that you need to be able to dereference a DTD, which introduces a performance hit and extra fragility. MinX is designed to represent data and having the ability to add new entities is a human-friendly feature that adds dependencies. 

We stripped away everything we could do without, except for comments. We retained comments because the JSON experience shows that omitting them is too extreme. However, we mandate that MinX comments are discarded on reading - there are there as annotations for people, not machines - and we don’t want our programs cluttered up with the consideration of whether or not they should process comments.

Summary
-------
MinX is a no-frills subset of XML designed to represent hierarchical data.

