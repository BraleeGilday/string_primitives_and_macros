# string_primitives_and_macros
x86 Assembly-implementation of a program that obtains 10 valid integers from the user, stores them in an array, and then displays a list of the integers, their sum, and truncated average. 

The purpose of this assignment is to reinforce concepts related to string primitive instructions and macros.
1. Designing, implementing, and calling low-level I/O procedures
2. Implementing and using macros

## MASM Program for String and Integer Processing
This program implements two macros and two procedures to handle string inputs and signed integers, performing the following tasks:

## Macros
1. **mGetString**
   - Displays a prompt (passed by reference).
   - Captures user input from the keyboard into a memory location (passed by reference).

2. **mDisplayString**
   - Prints the string stored in a specified memory location (passed by reference).

## Procedures
1. **ReadVal**
   - Invokes the `mGetString` macro to get user input as a string of digits.
   - Converts the string of ASCII digits to its numeric representation (SDWORD) using string primitives.
   - Validates the input to ensure it contains only valid numeric digits (no letters, symbols, etc.).
   - Stores the resulting value in a memory variable (passed by reference).

2. **WriteVal**
   - Converts a numeric SDWORD value (passed by value) into a string of ASCII digits.
   - Invokes the `mDisplayString` macro to print the ASCII representation of the SDWORD value.

## Test Program
The `main` test program performs the following steps:

1. Prompts the user to input 10 valid integers and displays the running subtotal of valid inputs.
2. Stores these numeric values in an array.
3. Displays:
   - The 10 integers.
   - Their sum.
   - Their truncated average.

## Program Constraints
- This program does **not** use built-in functions like `ReadInt`, `ReadDec`, `WriteInt`, or `WriteDec`.
- Input is validated manually by reading the input as a string and converting it to numeric form.

## Dependencies
- [Irvine32 Library](http://www.asmirvine.com) is required to run this program.

## Important Note on Running the Code

It's important to note that this program operates at an architectural level, so there are a few complexities when it comes to sharing or running the code on different machines; it is not immediately portable to other systems without configuration. This program is written in x86 assembly and is designed to run on a Windows machine using the MASM assembler. The primary purpose of this code is to demonstrate the implementation of macros and procedures in x86 assembly, rather than to be used as a fully portable or production-ready program.


