TITLE Low-Level Procedures     (Proj6_933674448.asm)

; Author: Santosh Ramesh
; Last Modified: 3-16-21
; OSU email address: rameshsa@oregonstate.edu
; Course number/section:   CS271 Section 400 Winter ECAMPUS
; Project Number: 6                Due Date: 3-14-21
; Description: Takes in 10 signed integers (less than 32 bits) from the user and stores it in an array to calculate their sum and average.
;				The elements are read in as strings for error-checking to make sure that the values are integers and that the integer entered
;				is less than 32 bits in size; if there is an error, the program will reprompt the user. The sum and average are also written
;				out to the console as a string. Each new integer is also numbered when prompted (EC).

INCLUDE Irvine32.inc


; -------------------------------------------------------------------------------------------
; Name: mGetString
; Description: takes in user input values for a string and places them into the "input" string array
; Preconditions: an empty "input" string array set to a max size
; Recieves: prompt (reference, input), input (reference, output) max_count (value, input), current_number (value, input), num_size (value, input)
; Returns: a filled "input" string array
; -------------------------------------------------------------------------------------------
mGetString MACRO prompt, input, max_count, current_number, num_size
	PUSH	EDX
	PUSH	EBX
	PUSH	EAX
	PUSH	ECX
	PUSH	EDI

	; initializing the array to have nothing
	MOV		ECX, max_count
	DEC		ECX
	MOV		EDI, input
	MOV		EAX, 0

_Reinitialize:
	MOV		[EDI], EAX
	MOV		AL, [EDI]
	INC		EDI
	LOOP	_Reinitialize

	; prompting user for integer
	MOV		EAX, current_number
	CALL	WriteChar
	MOV		EDX, prompt
	CALL	WriteString

	; taking in user input
	MOV		ECX, max_count
	DEC		ECX
	MOV		EDX, input
	CALL	ReadString

	MOV		num_size, EAX
	
	POP		EDI
	POP		ECX
	POP		EAX
	POP		EBX
	POP		EDX

ENDM

; -------------------------------------------------------------------------------------------
; Name: mDisplayString
; Description: This macro converts an integer and displays it as a string
; Preconditions: the "number_rep" containing an integer value
; Postconditions: EAX, EDX, and EBX all modified and restored to pre-macro conditions
; Recieves: number_rep (value, input)
; Returns: displays the integer value as a string
; -------------------------------------------------------------------------------------------
mDisplayString MACRO number_rep
	PUSH	EAX
	PUSH	EDX
	PUSH	EBX
	PUSH	ECX
	
	MOV		EAX, number_rep
	MOV		ECX, 0
	CMP		EAX, 0
	JL		_IsNegative

_IsPositive:
	MOV		EBX, 43					; adding the "+" sign to the integer
	JMP		_Displaying

_IsNegative:
	MOV		EBX, 45					; adding the "-" sign to the integer
	IMUL	EAX, -1

_Displaying:
	PUSH	EAX
	MOV		EAX, EBX
	CALL	WriteChar
	POP		EAX

_Divisions:
	CDQ

	MOV		EBX, 10
	DIV		EBX
	MOV		EBX, EAX
	MOV		EAX, EDX

	ADD		EAX, 48
	PUSH	EAX
	SUB		EAX, 48
	INC		ECX
	MOV		EAX, EBX

	CMP		EAX, 0
	JNZ		_Divisions				; continue dividing and printing for every digit

	
_Reverser:
	POP		EAX
	CALL	WriteChar
	
	LOOP	_Reverser


	POP		ECX
	POP		EBX
	POP		EDX
	POP		EAX

ENDM


MAX_NUMBERS		=	10
MAX_INPUT		=	13

.data
intro_1			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10, 0
intro_2			BYTE	"Written by: Santosh Ramesh", 13, 10, 13, 10, 0
intro_3			BYTE	"Please provide 10 signed decimal integers. ", 13, 10, 0
intro_4			BYTE	"Each number needs to be small enough to fit inside a 32 bit register. ", 13, 10, 
						"After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value. ", 13, 10, 0
extra_credit	BYTE	"EC: each of the lines are numbered", 13, 10, 13, 10, 0
input_prompt	BYTE	". Please enter a signed number: ", 0
error_prompt	BYTE	"ERROR: You did not enter a signed number or your number was too big.", 13, 10, "Please try again! ", 13, 10, 0

numbers_prompt	BYTE	13, 10, "You entered the following numbers: ", 13, 10, 0
spacer			BYTE	", ", 0
sum_prompt		BYTE	"The sum of these numbers is: ", 0
average_prompt	BYTE	"The rounded average is: ", 0
closing_1		BYTE	"Thanks for playing! ", 13, 10, 0

numbers_array	SDWORD	MAX_NUMBERS DUP (0)				; array to hold 10 signed integers
input_array		BYTE	MAX_INPUT DUP (0)				; array to hold input for each integer

current			SDWORD	48
number			SDWORD	0
total			SDWORD	0								; tracks the number of correct signed integers
average			SDWORD	?
sum				SDWORD	?
bytes_read		SDWORD	?
numbers			SDWORD	0

.code
main PROC
	; INTRODUCTION
	; name + title of program
	MOV		EDX, OFFSET intro_1
	CALL	WriteString
	MOV		EDX, OFFSET intro_2
	CALL	WriteString

	; program description
	MOV		EDX, OFFSET intro_3
	CALL	WriteString
	MOV		EDX, OFFSET intro_4
	CALL	WriteString

	MOV		EDX, OFFSET extra_credit
	CALL	WriteString

	; PROMPTING INTEGER INPUTS
	PUSH	numbers
	PUSH	bytes_read
	PUSH	OFFSET error_prompt
	PUSH	OFFSET numbers_array
	PUSH	number
	PUSH	MAX_NUMBERS
	PUSH	current
	PUSH	MAX_INPUT
	PUSH	OFFSET input_array
	PUSH	OFFSET input_prompt
	CALL	ReadVal

	; DISPLAYING & CALCULATIONS
	; displaying array values
	MOV		EDX, OFFSET numbers_prompt
	CALL	WriteString
	MOV		ECX, MAX_NUMBERS
	MOV		ESI, OFFSET numbers_array

_PrintNumbers:							; printing all of the numbers in the array
	PUSH	ESI
	MOV		EAX, [ESI]
	ADD		sum, EAX					; calculating the sum while printing the array
	CALL	WriteVal
	
	ADD		ESI, 4

	MOV		EDX, OFFSET spacer
	CALL	WriteString
	LOOP	_PrintNumbers

	; displaying sum
	CALL	CrLf
	MOV		EDX, OFFSET sum_prompt
	CALL	WriteString
	PUSH	OFFSET sum
	CALL	WriteVal
	CALL	CrLf

	; displaying average
	CDQ
	MOV		EBX, MAX_NUMBERS
	MOV		EAX, sum
	IDIV	EBX
	MOV		average, EAX

	MOV		EDX, OFFSET average_prompt
	CALL	WriteString
	PUSH	OFFSET average
	CALL	WriteVal
	CALL	CrLf

	; CLOSING
	MOV		EDX, OFFSET closing_1
	CALL	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------
; Name: ReadVal
; Description: This procedure takes in values from the user, error-checks them for size and validity, then places 10 values in another array
; Preconditions: empty "numbers_array" and "input_array"
; Postconditions: EBP, EAX, EBX, ECX, EDI, & EDX modified and restored to pre-procedure states
; Recieves: input_prompt (reference, input), input_array (reference, input/output), MAX_INPUT (value, input), current (value, input), MAX_NUMBERS (value, input), 
;			number (value, input/output), numbers_array (reference, input/output), error_prompt (reference, input), bytes_read (value, input/output), numbers (value, input)
; Returns: fills in both the arrays of "number_array" and "input_array" with string inputs of itnegers
; -------------------------------------------------------------------------------------------
ReadVal PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
	PUSH	EDX

	MOV		ECX, [EBP + 24]
	MOV		EBX, [EBP + 20]

	; getting all user input values
_InputLoop:
	CALL	CrLf
	mGetString [EBP + 8], [EBP + 12], [EBP + 16], EBX, [EBP + 40]
	MOV		EAX, [EBP + 40]

	JMP		_ValidCheck
	JMP		_StringConverter				
	JMP		_Finished

_Error:
	MOV		EDX, [EBP + 36]
	CALL	WriteString
	JMP		_InputLoop

_Finished:
	INC		EBX
	JMP		_StringConverter

_Stored:							; when the number has been stored in the array
	LOOP	_InputLoop				; looping through to get all user integer inputs
	JMP		_Completed

	; checking if number is valid
_ValidCheck:
	PUSH	ECX
	MOV		ECX, [EBP + 16]
	DEC		ECX

	; SIGN-BIT CHECK
	MOV		EDI, [EBP + 12]

	MOV		EAX, 0
	MOV		AL, [EDI]

	MOV		AL, [EDI]
	CMP		AL, 43					; checking if the sign-bit is "+"
	JZ		_SignOkay
	CMP		AL, 45
	JZ		_SignOkay				; checking if the sign-bit is "-"
	JMP		_IsInteger

_SignOkay:							; if the sign-bit is a valid input
	INC		EDI
	DEC		ECX

	; ASCII VALUE CHECK
_IsInteger:
	
_CheckingASCII:
	MOV		AL, 48
	SCASB
	JG		_Invalid
	DEC		EDI

	MOV		AL, 57
	SCASB
	JL		_Invalid

	LOOP	_CheckingASCII
	POP		ECX
	JMP		_SizeCheck

_Invalid:							; if there is a possible invalid ASCII character
	POP		ECX	

	DEC		EDI
	MOV		AL, 0
	SCASB
	JZ		_NullValue				; if there was actually a "null" value that got flagged as invalid, when it is valid
	JMP		_Error

_NullValue:
	JMP		_SizeCheck

	; SIZE CHECK
_SizeCheck:
	MOV		EDI, [EBP + 12]
	ADD		EDI, 10					; checking if there are too many digits entered by checking the 11th spot
	MOV		DL, [EDI]
	MOV		AL, 0
	SCASB
	JNZ		_Error
	
	JMP		_Finished

	; converting the string to integer & storing in array
_StringConverter:
	PUSH	ECX
	PUSH	EBX						; EBX used to store the positive/negative multiplier
	PUSH	EDX
	MOV		ECX, [EBP + 40]

	; checking first bit if sign
	MOV		EDI, [EBP + 12]

	MOV		AL, [EDI]
	CMP		AL, 43					; checking if the sign-bit is "+"
	JZ		_Positive
	CMP		AL, 45					; checking if the sign-bit is "-"
	JZ		_Negative
	MOV		EAX, 0
	MOV		EBX, 1
	JMP		_Conversion

_Positive:
	MOV		EBX, 1
	INC		EDI
	DEC		ECX
	MOV		EAX, 0
	JMP		_Conversion

_Negative:
	MOV		EBX, -1
	INC		EDI
	DEC		ECX
	MOV		EAX, 0
	JMP		_Conversion

_Conversion:
	MOV		EDX, 0
	IMUL	EAX, 10
	MOV		DL, [EDI]
	ADD		EAX, EDX
	SUB		EAX, 48
	INC		EDI

	LOOP	_Conversion
	IMUL	EAX, EBX				; changing sign of integer to match input

	POP		EDX
	POP		EBX
	POP		ECX

	; storing the value in the numbers array
	MOV		EDI, [EBP + 32]
	MOV		EDX, [EBP + 44]
	ADD		EDI, EDX
	MOV		[EDI], EAX

	ADD		EDX, 4
	MOV		[EBP + 44], EDX

	;INC		SDWORD PTR [EDX]

	JMP		_Stored

_Completed:							; after completing the loop

	POP		EDX
	POP		EDI
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP

	RET		40
ReadVal ENDP

; -------------------------------------------------------------------------------------------
; Name: WriteVal
; Description: This procedure takes in a signed integer value and converts it to be displayed as a series of ASCII characters
; Preconditions: A location referenced with a signed integer value within it
; Postconditions: EBP, EAX, EBX, ESI, are modified and restored to pre-procedure states
; Recieves:  numbers_array (reference, input) - specific address
; Returns: writes the string as integers
; -------------------------------------------------------------------------------------------
WriteVal PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ESI

	MOV		ESI, [EBP + 8]
	mDisplayString [ESI]

	POP		ESI
	POP		EBX
	POP		EAX
	POP		EBP

	RET		4
WriteVal ENDP

END main
