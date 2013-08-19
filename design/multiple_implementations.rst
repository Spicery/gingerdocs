One Logical Instruction Set, Multiple Implementations
=====================================================

Overview
--------
The virtual machine has a single CISC-style instruction set. Each instruction consists of an instruction-word followed by zero-or-more data words (words are the size of a long int). However there are four quite different implementations of the core engine with differing performance/portability tradeoffs. Adding new implementations is relatively simple e.g. the planned debugger will be implemented by an engine which allows hooks to be inserted into the code. 

How the Engines are Constructed
-------------------------------
The instructions are written in C++ with heavy use of macros. Each implementation of the engine is built by a python script that weaves together these instructions into a large interpreter-loop method called execute. This method is embedded into a class (implementation and header) that derives from the MachineClass, together with appropriate macros definitions. 

Adding a new engine therefore involves making quite a few scattered changes, unfortunately. Over time we intend to make the process of adding new engines easier, and we have already made some progress, but it's not a high priority as we don't expect it to be a common activity!

Each engine has to define two virtual methods. 

.. code-block: C++

    const InstructionSet & instructionSet();
    void execute( Ref r, const bool clear_stack = true );

instructionSet()
~~~~~~~~~~~~~~~~
In all cases, this is simply a getter method for a private member. This is always an instance of a derived class of InstructionSet. So the idiom is:

.. code-block:: cpp

    class MachineN {
    private:
        InstructionSetN instruction_set;
    public:
        const InstructionSet & instructionSet() { return this->instruction_set; }
    }

execute( Ref r, const bool clear_stack = true )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The execute method is usually written as an outer loop which calls auto-generated functions. Here's the code for Machine1, the default engine.

.. code-block:: cpp

    void Machine1::execute( Ref initial_fn_obj, const bool clear_stack ) {
        Ref * PC = this->setUpPC( initial_fn_obj, clear_stack );
        for (;;) {          
            //sanity_check( this->func_of_program_counter ); // debug
            Special fn = reinterpret_cast< Special >( *PC );
            PC = fn( PC, this );
        }
    }

In this engine, each of the machine instructions is turned into a C++ function pointer called "Special". The setUpPC method is reponsible for returning the initial program counter (and optionally clearing the value stack). And in this engine (and only in this engine) the Special function will return the next value of the program counter.

Excluding Engines
-----------------
By default all the engines are compiled into the Ginger virtual machine but only one is selected at start up. Each engine contributes about 40-50KB each, when compiled with -O at the time of writing. So if you wanted to create a minimal executable image, you could reduce the overall size by around 15% by compiling only one engine.

To do this, simply define one or more of the following flags in the ${GINGER_DEV_SRC}/apps/appginger/cpp/Makefile file. You can do this simply by uncommenting the matching lines in the Makefile.

    * MACHINE1_EXCLUDED
    * MACHINE2_EXCLUDED
    * MACHINE3_EXCLUDED
    * MACHINE4_EXCLUDED


Engine #1
---------
As described above, this is the default engine for Ginger, offering reasonable performance and good portability. In this implementation an Instruction is a C++ function pointer with the following signature.

.. code-block:: cpp

    typedef Ref * SpecialFn( Ref * pc, Machine vm );
    typedef SpecialFn * Special;

These function pointers are employed in the obvious top-level loop.

.. code-block:: cpp

    void Machine1::execute( Ref initial_fn_obj, const bool clear_stack ) {
        Ref * PC = this->setUpPC( initial_fn_obj, clear_stack );
        for (;;) {          
            //sanity_check( this->func_of_program_counter ); // debug
            Special fn = reinterpret_cast< Special >( *PC );
            PC = fn( PC, this );
        }
    }

Engine #2
---------
On 32-bit Intel machines, it is often more efficient to use register globals than parameters (due to register starvation). This engine is similar to #1 but puts both the program counter and the machine in register globals. The C++ function pointers therefore have a different signature.

.. code-block:: cpp

    Ref *pc;
    Machine vm;
    typedef void SpecialFn( void );
    typedef SpecialFn *Special;

This slightly simplifies the main loop, at the expense of having to save/restore the register globals whenever a garbage collection might occur.

.. code-block:: cpp

    void Machine2::execute( Ref initial_fn_obj, const bool clear_stack ) {
        pc = this->setUpPC( initial_fn_obj, clear_stack );
        vm = this;
        for (;;) {      
            Special fn = (Special)( *pc );
            fn();
        }
    }


Engine #3
---------
This is a threaded interpreter, offering best performance but relying on a GCC extension; the ability to take the address of labels. It was the unexpectedly good performance of this technique that led to the original experimentation with this VM architecture.

Each instruction is the address of a label within the main execute loop. So the execute routine looks like this, where the "core" method is synthesized in its entirety by the Python script.

.. code-block:: cpp

    void Machine3::execute( Ref initial_fn_obj, const bool clear_stack ) {
        Ref * PC = this->setUpPC( initial_fn_obj, clear_stack );
        this->core( false, PC );
    }

The addresses of the labels needed to be populated at startup. So the core method takes an additional boolean parameter that determines whether to initialise a hidden array or enter the main interpreter loop.

The synthesized method is over 3.3KLOC in size. But the structure is easy to understand and looks roughly like this.

.. code-block:: cpp

    void Machine3::core( bool init_mode, Ref *pc ) {
        Ref *VMSP, *VMVP, *VMLINK;
        if ( init_mode ) goto Initialize;
        MELT;
        goto **pc;
        L_add: {
            .... CODE FOR ADD ...
        }
        L_decr: {
            .... CODE FOR DECR ...
        }
        Initialize: {
            InstructionSet & ins = vm->instruction_set;
            ins.spc_add = &&L_add;
            ins.spc_decr = &&L_decr;
            ... ADD ALL THE OTHER INSTRUCTIONS ...
            return;
        }
    }

Each instruction returns via the RETURN engine-macro and in this machine that macro is defined to goto the next label.

.. code-block:: cpp

    #define RETURN( e )     { pc = ( e ); goto **pc; }


Engine #4
---------
Each instruction has a unique integer identifier defined by an enumeration (enum Instruction). That enumeration is synthesized from the Python script but looks something like this:

.. code-block:: cpp

    enum Instruction {
        vmc_add,
        vmc_decr,
        vmc_div,
        vmc_eq,
        vmc_neq,
        .... ETC ....
    };

This engine uses these integer codes as the labels of a large switch statement. At the time of writing there are 87 cases. The body of the switch is automatically generated from the Python script.

.. code-block:: cpp

    void Machine4::execute( Ref r, const bool clear_stack ) {
        Ref * pc = this->setUpPC( r, clear_stack );
        execute_loop: {
            Special code = *reinterpret_cast< Special * >( pc );
            switch ( code ) {
                #include "machine4.cpp.auto"
                default: throw SystemError( "Invalid instruction" );
            }
            throw SystemError( "Instructions may not fall thru" );
        }
    }

This machine was implemented for research and measurement - it provides an experimental baseline, approximating the performance of a byte-coded interpreter.
