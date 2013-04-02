One Logical Instruction Set, Multiple Implementations
=====================================================

The virtual machine has a single CISC-style instruction set. Each instruction consists of an instruction-word followed by zero-or-more data words (words are the size of a long int). However there are three quite different implementations of the core engine with differing performance/portability tradeoffs. Adding new implementations is relatively simple e.g. the planned debugger will be implemented by an engine which allows hooks to be inserted into the code. 

