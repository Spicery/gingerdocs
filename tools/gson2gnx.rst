================================
Converting GSON to GNX: gson2gnx
================================
:Author:    Stephen Leach
:Email:     stephen.leach@steelypip.com

Created, July 2011

Introduction
------------

This filter converts `GSON expressions`_ on the standard input into `GNX expressions`_ on the standard output.

.. _`GSON expressions`: ../formats/gson.html
.. _`GNX expressions`: ../formats/gnx_syntax.html


Usage
-----

    Usage:  gson2gnx OPTIONS < GSON_IN > GNX_OUT

Options -H, --help[=TOPIC]
~~~~~~~~~~~~~~~~~~~~~~~~~~

Provides short help on topics.

* --help=help           this short help
* --help=licence        help on displaying license information

Options -V, --version
~~~~~~~~~~~~~~~~~~~~~

Prints out the version of gson2gnx and which release of AppGinger it is part of. For example:

.. code-block:: bash

    % gson2gnx -V
    gson2gnx: version 0.1 (Jul 22 2011 13:01:34) part of AppGinger version 0.7.0


Options -L --license[=PART]
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prints out the GNU Public License or specific subparts.

* By default displays the GNU Public License.
* --license=warranty, Shows the warranty part.
* --license=conditions,  Shows terms and conditions part of the license.


Examples
--------

.. code-block:: bash

    % echo 'if[ true, 1, f(x) ]' | gson2gnx | tidymnx
    <if>
        <id name="true"/>
        <constant type="int" value="1"/>
        <app>
            <id name="f"/>
            <seq>
                <id name="x"/>
            </seq>
        </app>
    </if>

