Calling Built-in (a.k.a. System) Functions: SysApp
==================================================

N.B. TODO: NOT UP TO DATE. 

SysApp's are efficient variants of standard function calls. 
They typically place serious restrictions on the pre-conditions
and failing to satisfy those preconditions may corrupt the
system (i.e. is undefined behaviour). This is the place where 
it is necessary for users to read the small-print 
on what the restrictions for correct use. N.B. They play the same
role as Pop-11's fast operations.) 

In return for , the user entitled to assume the call do their 
job as efficiently as they can reasonably be made.

In support of this, the devteam is authorised to make reasonable 
assumptions to help performance e.g. the call may be inlined, 
computed at compile-time, overflow checking may be deferred 
until the end of the parent block, no debug information may
be available, the garbage collector may be blocked, and so on. 

For all the built-in sysfns there is a corresponding safe routine
(which appear in package 'std'). A correct program must work when
any 'sysapp' is replaced by an 'app' to the safe routine. e.g.

.. code-block:: text

	### Best performance but may be undefined if the 
	### preconditions are not met.
	<sysapp name="foo"> ... </sysapp> 
		
	### Has well-defined failure mode but will do the same
	### as the sysapp if the preconditions are met.
	<app><id name="foo" pkg="sys"/><seq>...</seq></app>

SysApp's are guaranteed to exist for every sysfn and vice
versa. Unlike sysapp's, sysfns are not guaranteed to be
efficient but may be implemented behind the scenes as
an function that invokes the sysapp.

.. code-block:: text

	### permitted possible implementation of sysfn called 'foo' 
	<fn title="foo">
		<explode><var name=”x”/></explode>
		<sysapp name="foo">
			<explode><id name=”x”/></explode>
		</sysapp>
	</fn>

This highlights that the entitlement to efficiency is only
assured for direct calls.
    

Such a form may silently be transformed into a relatively 
inefficient form such as the one below. 

.. code-block:: xml

	<fn>
		<explode><var name=”x”/></explode>
		<sysapp name="foo"><explode><id name=”x”/></explode></sysapp>
	</fn>

However it is guaranteed that direct calls of sysfns will
be as efficient as sysapps.

.. code-block:: text

	### This form will be treated as identical to
	### the one below. (The reverse is not true.)
	<app><sysfn value="foo"/> ... </app>

turns into

.. code-block:: text

	<sysapp name="foo"> ... </sysapp>

