Record Classes
==============
In Ginger, records are store that used to define classes whose instances have a fixed set of fields. These are used for both simple records ("structs") whose fields are exposed and also for the implementation of objects.

User Defined Record Classes
---------------------------
At the time of writing we only support simple record definitions. Each record definition introduces a new class with any number of fields (including 0). But you can't make subclasses of the record.

Example::

	recordclass Choice 
		field mainChoice; 
		field altChoice;
	endrecordclass;

The above definition does the following:

	*	It introduces a new class 'Choice' for a record of 2 fields. 
		It is guaranteed to be distinct from any existing class.

	*	A constructor 'newChoice' that takes 2 arguments and return
		a new instance of Choice.

	* 	An exploder 'explodeChoice' that takes a Choice record and
		returns all the fields in order.

	* 	A recogniser 'isChoice' that returns true for instances of 
		Choice and false for everything else.

	*	Access functions 'mainChoice' and 'altChoice' that return the 
		corresponding fields of a Choice instance.


Future Expansion
----------------
The implementation of classes and methods utilises records. Most of the work for object-oriented programming has been done but has not been exposed to users.
