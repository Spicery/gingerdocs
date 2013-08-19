Packages and Imports
--------------------

TODO: Not up to date.

Overview
~~~~~~~~

The package element introduces a new package. Packages should be named uniquely via URIs. Items within the package are compiled with the new package as the default.

If a package attempts to introduce a pre-existing package, the action taken depends on whether or not appginger is in development-mode (reloaded allowed) or in run-mode (reloading forbidden).

The import element establishes a relationship between two packages. This relationship is used to make top-level variables visible from other packages. 

Syntax
~~~~~~

.. code-block:: text

	PACKAGE ::=
		<package url=PACKAGE_URL>
			IMPORT*
			STMNT*
		</package>
	
	IMPORT ::=
		<import 
			from=PACKAGE_URL
			( (match0|match1|...)=TAG_VALUE )*
			[ alias=ALIAS_NAME ]
			[ qualified=("true"|"false") ]
			[ protected=("true"|"false") ]
			( ( into0|into1|...)=TAG_VALUE )*
		/>
    
Package
~~~~~~~
The package element introduces a named package. Packages have to be uniquely named and we suggest URLs are used to achieve this. As always, this is advisory.

The top-level variables of the statements within that package are resolved with respect to that package. Resolution is the process of mapping a top-level name into a corresponding, anonymous runtime-record called a variable.

Package are essentially local maps from names to variables. Packages are chained together by imports, so that resolving a name in one package may yield a name in the local map or any imported package.

Imports
~~~~~~~
The import element is a named connection between two packages. Once an import is established, resolving a name in the importing package may continue into the imported package. 

The import utilizes tagging to restrict the variables that are searched. Variables that are searched due to an import are said to be exported. The match attributes specifies which variables are exported from the imported package, only those with matching tags may be exported.
The import is named by the alias attribute. Aliases must be unique within a package. The alias is used to qualify a variable reference e.g. myalias::myvariable. This is also affected by the qualified attribute which specifies whether or not a search in this import must use the alias. 

By default, imports are not qualified.

The protected attribute specifies whether or not the import may be masked by local declarations. If an import is protected then every declaration in the package must be checked to ensure it would not mask (or shadow) an imported variable. By default, imports are not protected.
The into attribute specifies whether or not the exported variables are re-exported by the importing package. If the into attribute is provided then it specifies which tag(s) they will be re-exported under. If it is not provided then there is no re-export.



