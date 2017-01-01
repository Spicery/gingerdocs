Ginger Version 0.9.2
--------------------

Ubuntu SNAP Packaging
~~~~~~~~~~~~~~~~~~~~~
Canonical have a new 'universal' package format they call Snap. Ginger has been
rewritten to be Snap compliant. This is the fastest and simplest way to
install, update and remove Ginger, at least on Ubuntu. (There are other 
competing formats, such as Flatpak, that would also be possible.)

    % sudo snap install --devmode https://github.com/Spicery/ginger/releases/download/v0.9.2/ginger_0.9.2_amd64.snap

Command-Line Interface
~~~~~~~~~~~~~~~~~~~~~~
The command-line interface has been substantially rewritten to make GNU readline
part of the core functionality. This eliminates the dependency on rlwrap, although
that remains a useful tool for developers e.g. for gvmtest. This simplifies the
delivery and setup and the ginger executable is now a genuine executable and not
a shebang script - the latter unfortunately being more limited in terms of 
scripting.

The ginger executable now takes a 'command' argument that selects the actual
program::

    % ginger <COMMAND> <OPTIONS>

The program is selected by the very simple strategy of prefixing the command 
with "ginger-". Hence, as an example, the following two command-line are identical::

    % ginger admin 
    % ginger-admin

If omitted the command defaults to "cli", and invokes "ginger-cli". This is an abbreviation for "command line interface".

Refactorings
~~~~~~~~~~~~
* The old appginger executable, which has been without any real use for several
  years, has been properly retired. The few places it was used have been 
  properly replace by ginger-script.
* Reduction in the use of old-style C-macros in favour of C++ constants.
* System-functions have been re-organised to make it possible to manage them
  in a modular way. This functionality has not been used as yet.
* The system-functions table has been renamed to something more sensible.

