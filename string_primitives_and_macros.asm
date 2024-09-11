TITLE Proj6_Gildayb.asm     (Proj6_Gildayb.asm)

; Author: Bralee Gilday
; Last Modified: 3/16/24
; OSU email address: Gildayb@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 3/17/24
; Description: The program includes two macros: mGetString retrieves user input from the keyboard, displaying a prompt and 
;	storing the input in memory, while mDisplayString prints a string stored in a specified memory location. Additionally, 
;	two procedures are implemented: ReadVal utilizes mGetString to convert user input into its numeric representation, 
;	ensuring validity, and stores the numeric value in memory; WriteVal converts a numeric value into a string of ASCII digits
;	and displays it. The main test program utilizes ReadVal in a loop to obtain 10 valid integers from the user, storing them 
;	in an array, and then displays a list of the integers, their sum, and truncated average. 

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays a prompt then gets the user's keyboard input into a memory location. 
;
; Receives:
;	promptAddress = address of prompt (a byte array)
;	userDataAddress = array address
;	count = array length
;	numBytesRead = address of DWORD data label 
;
; returns: 
;	userDataAddress = string of user input
;	numBytesRead = number of bytes in userDataAddress
; ---------------------------------------------------------------------------------

mGetString	MACRO	promptAddress:REQ, userDataAddress:REQ, count:REQ, numBytesRead:REQ
	
	; preserve all registers (push)
	PUSHAD

	; display prompt to user
	MOV		EDX, promptAddress
	CALL	WriteString

	; get user data
	MOV		EDX, userDataAddress
	MOV		ECX, count
	CALL	ReadString

	; save number of bytes entered by the user
	MOV		EBX, numBytesRead
	MOV		[EBX], EAX

	; preserve all registers (pop)
	POPAD

ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays the string which is stored in a specified memory location.
;
; Receives:
; stringAddress = address of a string to be printed 
;
; ---------------------------------------------------------------------------------
mDisplayString	MACRO	stringAddress:REQ

	PUSH	EDX

	MOV		EDX, stringAddress
	CALL	WriteString

	POP		EDX

ENDM


; -----------------------------------------------------------------------------------
; constants
; -----------------------------------------------------------------------------------

VALID_INTEGERS = 10										; the desired number of valid integers input by the user

ARRAYSIZE = 100											; length of the array for capturing user input 

MOSTSIGBIT = 80000000h									; corresponds to highest bit, used to check sign



; -----------------------------------------------------------------------------------
; data segment
; -----------------------------------------------------------------------------------
.data

	myTitle			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures		Bralee Gilday",13,10,
							"EC1: Program numbers each line of user input and displays a running subtotal of the user's valid numbers using WriteVal.",13,10,13,10,0
	instruction1	BYTE	"Welcome! Please provide ",0
	instruction2	BYTE	" signed decimal integers.",13,10,13,10,
							"Each number needs to be small enough to fit inside a 32-bit register. ",13,10,
							"After you have finished inputting the raw numbers, I will display a list of the integers, ",
							"their sum, and their truncated average value.",13,10,13,10,0

	userPrompt		BYTE	"Please enter a signed number: ",0
	errorMsg		BYTE	"ERROR: You did not enter a signed number or your number was too big. Please try again.",13,10,13,10,0

	period			BYTE	". ",0
	comma			BYTE	", ", 0
	newLine			BYTE	" ",13,10,0

	userString		BYTE	ARRAYSIZE DUP (0)
	byteCount		DWORD	?
	userNum			SDWORD	0							; value can be between -2^31 and 2^31-1 (-2,147,483,648 and 2,147,483,647)

	userInputArray	SDWORD	VALID_INTEGERS DUP (?)		; used to store the user numbers once they have been converted from string to SDWORD
	
	numberString	BYTE	12 DUP(0)					; holds the converted element from the userInputArray (SDWORD to string), used for displaying a number

	validNumber		DWORD	?							; a Boolean value (either 0 for invalid or 1 for valid)
	validNumCount	DWORD	1							; the count of valid integers input by the user, also used to number inputs (for EC 1)

	sum				SDWORD	0
	subTotalTitle	BYTE	"Subtotal of valid integers: ",0		; EC 1

	integerTitle	BYTE	13,10,"You entered the following numbers: ",13,10,0
	sumTitle		BYTE	13,10,"The sum of these numbers is: ",0
	averageTitle	BYTE	13,10,"The truncated average is: ",0

	goodbyeMsg		BYTE	"Thank you for participating!",13,10,0



; -----------------------------------------------------------------------------------
; code segment
; -----------------------------------------------------------------------------------

.code
main PROC

; display title, name, EC 1 info, and instructions.
mDisplayString	OFFSET	myTitle
mDisplayString	OFFSET	instruction1					; "Welcome! Please provide "

PUSH	OFFSET numberString
PUSH	VALID_INTEGERS
CALL	WriteVal										; the number stored in the constant VALID_INTEGERS

mDisplayString	OFFSET	instruction2					; " signed decimal integers..."


; set up for loop
MOV		ECX, VALID_INTEGERS
MOV		EDI, OFFSET userInputArray						; EDI holds the userInputArray which will be the destination for user input once converted to SDWORD

_readValLoop:
	; Display the numbering of user inputs
	PUSH	OFFSET numberString
	PUSH	validNumCount
	CALL	WriteVal
	mDisplayString	OFFSET period

	; Get user input (one number, saved as a string)
	PUSH	OFFSET	validNumber
	PUSH	OFFSET	errorMsg
	PUSH	OFFSET	userPrompt
	PUSH	OFFSET	userString
	PUSH	OFFSET	userNum	
	PUSH	OFFSET	byteCount
	CALL	ReadVal

	;check if the user input valid (based on the 
	CMP		validNumber,0								; if validNumber: is 0 then the user input was invalid, is 1 then the user input was valid
	JNZ		_valid										; jump to _valid if input was valid
	INC		ECX											; otherwise, input was invalid, so add 1 back to ECX to counteract automatic decremet when ending the loop
	JMP		_endLoop

	_valid:
		INC		validNumCount

		; save the value into an array
		MOV		EAX, userNum
		MOV		[EDI], EAX
		ADD		EDI, TYPE userInputArray				; move to the next element in the array (to be ready for the next user input number)
		ADD		sum, EAX								; add the number to the running subtotal 

		; display subtotal (EC 1)
		mDisplayString	OFFSET subTotalTitle
		PUSH	OFFSET numberString
		PUSH	sum
		CALL	WriteVal
	
		mDisplayString	OFFSET newLine					; new line without calling the Irvine Procedure CrLf
		mDisplayString	OFFSET newLine
	
	_endLoop:
		DEC		ECX										;destination (_readValLoop) out of range for LOOP, so DEC/JNZ used instead
		JNZ		_readValLoop


; display the title for DISPLAYING all numbers
mDisplayString	OFFSET integerTitle						; "You entered the following numbers:"

; set up registers and flag for _displayArray Loop
CLD	
MOV		ECX, LENGTHOF userInputArray
MOV		ESI, OFFSET userInputArray
MOV		EDI, OFFSET numberString

; display the list of numbers entered by the user
_displayArray:

	PUSH	EDI
	PUSH	[ESI]
	CALL	WriteVal

	; check if displaying the final number
	CMP		ECX, 1										; if it's the final number, don't diplay the comma
	JZ		_theEnd		
	mDisplayString	OFFSET comma						; otherwise, display a comma (and space) between each number string

	; Move to the next element of the userInputArray
	ADD		ESI, TYPE userInputArray

	_theEnd:
		LOOP	_displayArray

mDisplayString	OFFSET newLine

; display the title for SUM
mDisplayString	OFFSET sumTitle							; "The sum of these numbers is: "

; display the sum (calculated in _readValLoop)
PUSH	OFFSET numberString
PUSH	sum
CALL	WriteVal

mDisplayString	OFFSET newLine

; display the title for TRUNCATED AVERAGE
mDisplayString	OFFSET averageTitle						; "The truncated average is: "

; calculate the truncated average
MOV		EAX, sum
CDQ
MOV		EBX, LENGTHOF userInputArray
IDIV	EBX												; EAX now holds the truncated average

; display the truncated average
PUSH	OFFSET numberString
PUSH	EAX
CALL	WriteVal

mDisplayString	OFFSET newLine

; display farewell message
mDisplayString	OFFSET newLine
mDisplayString	OFFSET goodbyeMsg

	Invoke ExitProcess,0								; exit to operating system
main ENDP


;  ---------------------------------------------------------------------------------
; Name: ReadVal
;
; Invokes the mGetString macro to get user input in the form of a string of digits. 
; Then converts the string of ASCII digits to its numeric value representation using string primitives, 
; validating the user’s input is a valid number (no letters, symbols, or blanks and doesn't exceed 32-bit register).
; Finally, stores this one value in a memory variable.  
;
; Receives: 
;	[EBP + 8]  = address of the byteCount (where the count bytes in user input will be stored)
;	[EBP + 12] = address of userNum	(where decimal value will be stored)
;	[EBP + 16] = address of	userString array (where user input will be stored)
;	[EBP + 20] = address of	userPrompt string
;	[EBP + 24] = address of	errorMsg string
;	[EBP + 28] = address of	validNumber
;
; Returns: 
;	byteCount = number of bytes entered by the user
;	userNum	= the decimal value of the valid number entered by the user
;	userString = user input saved in the string
;	validNumber = boolean value; either a 1 if user input is valid or 0 is the user input is invalid
;
; ---------------------------------------------------------------------------------

ReadVal		PROC

	LOCAL	sign: DWORD

	; preserve registers (push)
	PUSHAD

_getStringLoop:
	; get user input in the form of a string of digits
	mGetString	[EBP+20], [EBP+16], ARRAYSIZE, [EBP+8]			

	; convert string to its numeric value represetnation

	CLD													; move forward through array
	
	MOV		EBX, [EBP + 8]
	MOV		ECX, [EBX]									; Set the counter equal to the number of bytes input by the user

	CMP		ECX, 0
	JZ		_errorMsg									; check to make sure the user entered something at all

	MOV		ESI, [EBP + 16]								; ESI now holds the memory address of the userString array
	MOV		EDI, [EBP + 12]								; EDI now holds the memory address of the userNum SDWORD
	MOV		EDX, 0
	MOV		[EDI], EDX									; clear the number from last time (if there is one)

	LODSB												; first character entered saved in AL register

	; check first character for sign
	CMP		AL, 45										; 45 is the ASCII code for '-'
	JZ		_negSign
	CMP		AL, 43										; 43 is the ASCII code for '+'
	JZ		_posSign
	MOV		sign, 0										; if there is no sign, assume value is positive, change sign variable accordingly
	JMP		_checkNumDigits								; then enter _checkNumDigits loop for initial validation

		; if the number has a negative sign
	_negSign:										
		MOV		sign, 1
		DEC		ECX										; since we use LODSB in this code label and move to the next character
		
		CMP		ECX, 0									; check to see if the user only entered a '-' sign.
		JZ		_errorMsg								; jump to not valid if the user entered just a negative sign.

		LODSB
		JMP		_checkNumDigits

		; if the number has a positive sign
	_posSign:
		MOV		sign, 0
		DEC		ECX
		CMP		ECX, 0									; check to see if the user only entered a '+' sign.
		JZ		_errorMsg

		LODSB

	_checkNumDigits:
		; check if too many digits were enter to fit into 32-bit register
		CMP		ECX, 10
		JG		_errorMsg

	_digitLoop:
		; check for valid digit (ASCII code between 48 and 57)
		CMP		AL, 48
		JL		_errorMsg
		CMP		AL, 57
		JG		_errorMsg

		; get numerical digit value
		MOV		BL, AL									; save AL to a new register since EAX will be used in MUL instruction
		MOV		EAX, [EDI]
		MOV		EDX, 10
		MUL		EDX										; Multiplies the previous total of userNum by 10 to accounT for placevalue
		JO		_possiblyValid								; check for overflow 

		SUB		BL, 48									; the actual decimal digit entered is now saved in BL
		MOVZX	EBX, BL  
		ADD		EAX, EBX								; add the current digit to the current total 
		JO		_possiblyValid								; check for overflow again

		MOV		[EDI], EAX

		; move to the next digit
		LODSB
		LOOP		_digitLoop

	; check sign
	CMP		sign, 0
	JZ		_valid
	MOV		EAX, [EDI]						
	NEG		EAX											; if the sign variable is set (eual to 1), then negate the decimal value
	MOV		[EDI], EAX									; re-save the value as negative

	; set validNumber to Boolean value 1 to indicate a valid number was saved 
	_valid:
		MOV		EDX, 1
		MOV		EBX, [EBP+28]							; [EBP + 28] is the address of validNumber, which holds a Boolenan value
		MOV		[EBX], EDX								; 1 is now the value for validNumber to indicate to main loop this was a valid entry
		JMP		_endReadVal

	; since our calculations are currently all positive, check to see if the number entered is -2^31
	_possiblyValid:							
		CMP		sign,1									; check to see if number is negative
		JNZ		_errorMsg
		CMP		EAX, 2147483648							; check to see if number is exactly 2147483648, which is equal to 2^31
		JNZ		_errorMsg

		; if the value entered is exactly -2^31, it is valid and will go through the same steps as any valid number
		MOV		[EDI], EAX								
		MOV		EDX, 1									
		MOV		EBX, [EBP+28]
		MOV		[EBX], EDX
		JMP		_endReadVal

	_errorMsg:
		; display error message
		mDisplayString	[EBP + 24]						; "ERROR: You did not enter a signed number or your number was too big. Please try again."
		
		; set validNumber to Boolean value 0 to indicate number was invalid
		MOV		EDX, 0
		MOV		EBX, [EBP+28]
		MOV		[EBX], EDX
	
_endReadVal:
	POPAD
	RET		24

ReadVal		ENDP


;  ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts a numeric SDWORD value to a string of ASCII digits. Then invokes the mDisplayString macro 
; to print the ASCII representation of the SDWORD value to the output.
;
; Preconditions: 
;	Array pushed is a byte array (string)
;	Decimal value pushed is type SDWORD and fits into 32-bit register. 
;
; Postconditions: 
;	Anything in the numberString pushed is cleared and saved over by the stringcreated within this procedure.
;
; Receives: 
;	[EBP + 8] = address of numberString
;	[EBP + 12] = SDWORD decimal value 
;
; Returns:
;	numberString = contains a string of the ASCII codes that represent the value pushed at [EBP + 12]
;
; ---------------------------------------------------------------------------------

WriteVal	PROC
	LOCAL	sign: DWORD

	PUSHAD

	; assign positive value (if value is negative, sign variable will be changed later)
	MOV		sign, 0


	; clear numberString array
	CLD													; move forward through the array
	MOV		EDI, [EBP + 12]								; EDI now holds the address to numberString array which will be the destination for the new string
	MOV		ECX, 12										; counter to 12 (the length of numberString) will ensure every element gets cleared
	MOV		AL, 0
	REP		STOSB

	; set up registers and flag
	MOV		EDI, [EBP + 12]								; set EDI back to referencing the first element of numberString
	MOV		EAX, [EBP + 8]								; decimal value passed by the stack saved to EAX

	CMP		EAX, 2147483648								; check to see if the number is the edge case value 2147483648 (no negative sign due to overflow)
	JNZ		_continue									; if not 2147483648, then _continue
	MOV		sign, 1										; if value is 2147483648, sign must be negative (which will be added as ASCII character at the end)

_continue:												; if not -2147483648
	MOV		ECX, 0
	STD													; Going backwards through the array

	; first check to see if the number is zero (no sign)
	CMP		EAX, 0										
	JZ		_numberOfDigits

	; check whether MSB, which indicates the sign of a signed double word (SDWORD) value, is set or not
	AND		EAX, MOSTSIGBIT								; MOSTSIGBIT is 1000 0000 0000 0000 0000 0000 0000 0000
	JNZ		_negativeValue								; if result of the AND operation is non-zero, the MSB is set, implying a negative value

	MOV		EAX, [EBP + 8]								; otherwise, restore EAX to the decimal value passed on stack
	JMP		_numberOfDigits								; positive value will jump to _numberOfDigits

		; if the value is negative
	_negativeValue:
		MOV		EAX, [EBP + 8]							; restore EAX to the decimal value passed on the stack (will be negative)
		CMP		EAX, 2147483648							; check to make sure the value is not -2147483648 which cannot be negated (due to overflow)
		JZ		_IncreaseEDI
		NEG		EAX										; turn posiive temporarily (for our conversion calculations, we only want the absolute value)
		MOV		sign, 1									; set sign to 1 to signal the value is a negative number
		_IncreaseEDI:
			INC		EDI									; leave 1 bit of space for the negative sign in the front of the array

	; get a count of the number of digits in the decimal value
	_numberOfDigits:
		CDQ
		MOV		EBX, 10
		IDIV	EBX
		CMP		EAX, 0
		JZ		_conversionSetup
		INC		ECX										; this count of digits will be used to find the address of last element of the numberString
		JMP		_numberOfDigits

	; preparation for _convertToString loop
	_conversionSetup:
		ADD		EDI, ECX								; since Direction Flag is set, EDI needs to be set to the address last value of the array		
		MOV		EAX, [EBP + 8]							; re-save the decimal value to EAX

		CMP		EAX, 2147483648							; check again to make sure the value is not -2147483648 which cannot be negated
		JZ		_decNumber	

		CMP		sign,1					
		JZ		_negative

		JMP		_convertToString
			
		_negative:										; if value is negative, re-save the value to EAX then negate to save as absolute value				
			NEG		EAX									; the sign is preserved through sign LOCAL variable and will be added back in later
			JMP		_convertToString

		_decNumber: 
			DEC		EAX									; if abs of decimal value is 2147483648, decrease by one to fit into 32-bit register for calculations (restored later)
			
; convert from decimal value to string
	_convertToString:
		CDQ					
		MOV		EBX, 10
		IDIV	EBX
		CMP		EAX, 10
		MOV		EBX, EAX								; save the quotient in EBX for later in the loop
		MOV		EAX, EDX								; move the remainder into EAX to prepare for STOSB
		ADD		EAX, 48									; add 48 to the digit to get the ASCII code
		STOSB

		CMP		EBX, 0
		JZ		_finishedDigits							; if the quotient is less than zero, the loop is finished
		MOV		EAX, EBX								; otherwise, move the stored quotient back to EAX
		JMP		_convertToString

	; confirm the sign
	_finishedDigits:
		CMP		sign,0									; check whether the original value was positive (sign set to 0) or negative (sign set to 1)
		JZ		_display								; if sign is 0, jump to _display

		MOV		AL, 45									; if sign is 1, move 45 (the ASCII code for '-' sign) to AL
		STOSB											; store the negative sign into the string

		MOV		EAX, [EBP + 8]
		CMP		EAX, 2147483648							; check to make sure the value is not -2147483648 which cannot be negated.
		JNZ		_display		
		ADD		EDI, 11									; if the value is - 2^31, then move to the last element of the array
		MOV		AL, 56									; change the final ASCII character to decimal 8 (code 56d)
		STOSB

; display the string value
	_display:
		mDisplayString	[EBP + 12]

	POPAD
	RET		8

WriteVal	ENDP

END main
