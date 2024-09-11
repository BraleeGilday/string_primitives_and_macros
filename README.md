# string_primitives_and_macros
This x86 Assembly program prompts the user to input 10 valid integers, stores them in an array, and displays the integers, their sum, and truncated average. The purpose of this project was to practice designing, implementing, and calling low-level I/O procedures as well as implementing and using macros.
   
## Project Description
This program implements two macros and two procedures to handle string inputs and signed integers, performing the following tasks.

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

1. Prompts the user to input 10* valid integers and displays the running subtotal of valid inputs.
2. Stores these numeric values in an array.
3. Displays:
   - The 10* integers.
   - Their sum.
   - Their truncated average.
*The desired number of valid integers input by the user is a constant, VALID_INTEGERS. This allows the number of desired inputs, for example, 3 or 10 or 100, to be adjusted in a single line rather than needing to be changed throughout the code body. 

## Program Constraints
- This program does **not** use built-in functions like `ReadInt`, `ReadDec`, `WriteInt`, or `WriteDec`.
- Input is validated manually by reading the input as a string and converting it to numeric form.

## Dependencies
- [Irvine32 Library](http://www.asmirvine.com) is required to run this program.

## Usage
It's important to note that this program operates at an architectural level, so there are a few complexities when it comes to sharing or running the code on different machines; it is not immediately portable to other systems without configuration. This program is written in x86 assembly and is designed to run on a Windows machine using the MASM assembler. The primary purpose of this code is to demonstrate the implementation of macros and procedures in x86 assembly, rather than to be used as a fully portable or production-ready program.

## Example Execution
User input in this example is represented as \*\*input\*\*.

```plaintext
TITLE: Designing low-level I/O procedures      AUTHOR: Bralee Gilday
Welcome! Please provide 10 signed decimal integers.

Each number needs to be small enough to fit inside a 32-bit register.
After you have finished inputting the raw numbers, I will display a list of the integers, their sum, and their truncated average value.

1. Please enter a signed number: **568**
Subtotal of valid integers: 568

2. Please enter a signed number: **987ytghj**
ERROR: You did not enter a signed number or your number was too big. Please try again.

2. Please enter a signed number: **12**
Subtotal of valid integers: 580

3. Please enter a signed number: **-12345**
Subtotal of valid integers: -11765

4. Please enter a signed number: **98765432345678**
ERROR: You did not enter a signed number or your number was too big. Please try again.

4. Please enter a signed number: **34567**
Subtotal of valid integers: 22802

5. Please enter a signed number: **-21000**
Subtotal of valid integers: 1802

6. Please enter a signed number: **-102**
Subtotal of valid integers: 1700

7. Please enter a signed number: **+23**
Subtotal of valid integers: 1723

8. Please enter a signed number: **34**
Subtotal of valid integers: 1757

9. Please enter a signed number: **11**
Subtotal of valid integers: 1768

10. Please enter a signed number: **30**
Subtotal of valid integers: 1798

You entered the following numbers:
568, 12, -12345, 34567, -21000, -102, 23, 34, 11, 30

The sum of these numbers is: 1798

The truncated average is: 179

Thank you for participating!
```

### Project Status
This project is currently complete, with potential for future enhancements in further data validation. Currently, there is some range of values that are out of bounds but less than DWORD MAX that are not correctly rejected (ex. 3000000000, 4000000000, -3456789123). More work can be done to find the source of error and correct. 

### License
This project is licensed under the MIT License. See the LICENSE file for more information.

### Contact
Bralee Gilday - www.linkedin.com/in/bralee-gilday
