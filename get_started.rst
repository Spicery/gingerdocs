==========================
Get Started with Ginger
==========================

Download, compile and install Ginger
------------------------------------
.. code-block:: bash

    $ git clone git@github.com:Spicery/ginger.git
    $ cd ginger 
    $ APPGINGER=`pwd`
    $ ./configure
    $ sudo make && make install

Install RudeCGI library
-----------------------
.. code-block:: bash

    $ cd /tmp
    $ wget http://rudeserver.com/cgiparser/download/rudecgi-5.0.0.tar.gz
    $ tar zxf rudecgi-5.0.0.tar.gz
    $ pushd rudecgi-5.0.0; ./configure; sudo make && make install; popd

Install optional extras
-----------------------
.. code-block:: bash

    $ sudo apt-get install guile-1.8 guile-1.8-dev guile-1.8-doc doxygen

Run a Ginger program
--------------------
.. code-block:: bash

    $ cd examples
    $ common2gnx hello.cmn


A slightly more extensive worked example
----------------------------------------

Given that the content of "upto.common" is:

.. literalinclude:: src/upto.common
   :linenos:
   :language: common

Then piping the Ginger Common syntax source through ``common2gnx`` and then ``appginger``:

.. code-block:: bash

    $ cat upto.common | common2gnx | appginger 

produces the following console output:

.. code-block:: text

    Ginger: 0.7, Copyright (c) 2010  Stephen Leach
      +----------------------------------------------------------------------+
      | This program comes with ABSOLUTELY NO WARRANTY. It is free software, |
      | and you are welcome to redistribute it under certain conditions.     |
      | Use option --help=license for details.                               |
      +----------------------------------------------------------------------+
    There are 0 results (0s)

    There are 0 results (0s)

    There are 0 results (0s)

    There is 1 result   (0s)
    1.  [10,9,8,7,6,5,4,3,2,1]

Try increasing the ``10.upto.rev`` to ``1000.upto.rev`` and feel the breeze::

    Ginger: 0.7, Copyright (c) 2010  Stephen Leach
      +----------------------------------------------------------------------+
      | This program comes with ABSOLUTELY NO WARRANTY. It is free software, |
      | and you are welcome to redistribute it under certain conditions.     |
      | Use option --help=license for details.                               |
      +----------------------------------------------------------------------+
    There are 0 results (0s)

    There are 0 results (0s)

    There are 0 results (0s)

    There is 1 result   (0.41s)
    1.  [1000,999, ... 1]

(to avoid tedium, the output has been elided)

