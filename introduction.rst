[1] Chapter 1: About Ginger

[1.1] What is Ginger

Ginger is a modern programming system that is built on top of a general purpose virtual machine. It comes with a modern programming language and library so that you can use to  write your own applications. But the whole system is designed to be open, so you can extend or replace almost every part of the system. 

Why did we create Ginger when there are so many programming systems already? Because we love programming and love making neat, effective programs. But other systems have all kind of conveniences that end up being confusing; strange corner cases that are supposed to be convenient but just make things ugly; or reasonable looking compromises that cause lots of problems later on. So we designed Ginger to be a language that gets out of your way and lets you enjoy the experience of writing a program. 

It took us a long time, more than ten years, to figure out what we thought that meant. Gradually we distilled our design goals into some key rules. One rule, for example, is "the programmer is in charge (not the language designer)". That affects the design of visibility declarations such as private/public; it requires that a programmer can get access to private variables for, say, debugging or writing unit tests. You may wonder how this can make sense - in which case turn to the chapter on packages.

Another key rule is "if one, why not many?". This rule means that anywhere in the language where there is a restriction to one item, consider making it many items. So in Ginger expressions don't return just one value, they may return any number from 0, 1, ... and so on. And methods don't just dispatch on one special 'this' argument, they may dispatch on 0, 1, 2 ... of their arguments. In fact a function is just a special kind of method that dispatches on 0 arguments. 

To understand how we interpreted our design rules you need to know a little about Ginger. 


[1.2] Hello World in Common

In this introduction to Ginger, we will write our examples in what we call 'Common'. Ginger supports more than one programming language syntax. But we designed Common to be a neat modern language that is easy to remember and accident-resistant. But you don't have to use it. We also designed a Javascript-inspired syntax too, if you prefer. And in future versions of Ginger we will add more - it's quite easy to add new ones. (Why did we make Ginger so flexible? Because one of the things we wanted to get away from was the idea that there was a single right answer.)

So what does Common look like? Here's a simple 'hello, world!' example. It shows quite a few useful features. I have added line numbers for easy reference.

	Line 1		# Prints a cheery message to the console.
	Line 2		define hello() =>>
	Line 3			println( "Hello, world!" )
	Line 4		enddefine

On Line 1 we write an end-of-line comment which is introduced with a hash symbol followed by a space. 

On Line 2 we introduce a function called 'hello'. Function definitions start with the keyword 'define' and are closed with the matching keyword 'enddefine'. This pairing of opening and closing keywords is used in many places in Common. 

The function head is separated from the function body by an '=>>'. There are several places where this double-headed arrow is used in Common and it always signals that a function is being defined. 

On Line 3 we define the function body as calling the 'println' function on a literal string. The name 'println' is a contraction of 'PRINT then add a LiNe' and the function is part of the standard library (ginger.std) . Programmers do not usually import the standard library because it is available by default. 

String literals use double-quotes, just like C/C++/C#, Java, Javascript and so on. Single quotes are reserved for symbol literals, which you will meet later on, but for now you can think of as a different kind of string.

On Line 4 we close the function with the 'enddefine' keyword. If you are working interactively you can abbreviate any keyword that starts with the prefix 'end' to just 'end'. This includes 'enddefine', 'endfn', 'endif', 'endfor'.

