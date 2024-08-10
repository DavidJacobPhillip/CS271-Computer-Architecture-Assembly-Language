TITLE Prime Numbers    (Proj4_933674448.asm)

; Author: Santosh Ramesh
; Last Modified: 2-20-21
; OSU email address: rameshsa@oregonstate.edu
; Course number/section:   CS271 Section 400 WINTER Ecampus
; Project Number: 4                Due Date: 2-20-21
; Description: This program calculates and displays all of the prime numbers below an input value between the range [1, 200]. 
;				Ten primes are listed per line, in asecnding order. Extra credit is impleneted, wherein the columns of each
;				number's first digit are all lined up. 

INCLUDE Irvine32.inc

MAX_RANGE	=	200
MIN_RANGE	=	1

.data

greeting	BYTE	"Prime Numbers Programmed by Santosh Ramesh", 13, 10, 0
prompt_1	BYTE	"Enter the number of prime numbers you would like to see.", 13, 10, 13, 10, 0
prompt_2	BYTE	"I'll accept orders for up to 200 primes.", 13, 10, 13, 10, 0
prompt_3	BYTE	"Enter the number of primes to display [1 ... 200]: ", 0
error		BYTE	13, 10, "No primes for you! Number out of range. Try again.", 13, 10, 0
closing		BYTE	13, 10, 13, 10, "Results certified by Santosh. Goodbye.", 13, 10, 0
extra		BYTE	"EC: The columns are aligned, with first digit matching the row above", 13, 10, 0
five_space	BYTE	"    ", 0
four_space	BYTE	"   ", 0
three_space	BYTE	"  ", 0

input		DWORD	?		; the value the user enters
current		DWORD	1	
line_nums	DWORD	0		; the number of numbers per line
divider		DWORD	1		; used to divide the value in question to determine if it is a prime
counter		DWORD	0

.code
main PROC
	CALL Introduction
	CALL GetUserData
	CALL ShowPrimes
	CALL Farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------
; Name: Introduction
; Description: prints out the beginning greeting to the user
; Preconditions: greeting and extra are strings describing the program's functionality
; Postconditions: EDX changed
; Recieves: none
; Returns: none
; -------------------------------------------------------------------------------------------
Introduction PROC
	MOV		EDX, OFFSET greeting			
	CALL	WriteString
	MOV		EDX, OFFSET extra
	CALL	WriteString

	RET
Introduction ENDP

; -------------------------------------------------------------------------------------------
; Name: GetUserData
; Description: Displays prompt describing what the user needs to input, and additional descriptions. 
; Preconditions: prompt_2 and prompt_2 are strings describing the user's tasks in inputting a number.
; Postconditions: EDX is changed
; Recieves: none
; Returns: user input values for the global variable "input" through the called "Validate" procedure
; -------------------------------------------------------------------------------------------
GetUserData PROC
	MOV		EDX, OFFSET prompt_1	
	CALL	WriteString
	MOV		EDX, OFFSET prompt_2
	CALL	WriteString
	CALL Validate

	RET
GetUserData ENDP

; -------------------------------------------------------------------------------------------
; Name: Validate
; Description: gets a value from the user within the range [1,200]
; Preconditions: the value inputed must be an unsigned integer DWORD, constants MIN_RANGE & MAX_RANGE must have range boundaries, prompt 3
;				and error are strings used to determine if input value is within range
; Postconditions: EDX, EAX changed
; Recieves: none
; Returns: user input values for the global variable "input"
; -------------------------------------------------------------------------------------------
Validate PROC
_RepeatValidation:
	MOV		EDX, OFFSET prompt_3
	CALL	WriteString

	; retrieving input & checking if between range values
	CALL	ReadInt
	CMP		EAX, MIN_RANGE
	JL		_ErrorValidation
	CMP		EAX, MAX_RANGE
	JG		_ErrorValidation
	JMP		_EndValidation

_ErrorValidation:					; determines if input isn't within range
	MOV		EDX, OFFSET error
	CALL	WriteString
	JMP		_RepeatValidation
	
_EndValidation:
	MOV		input, EAX

	RET
Validate ENDP

; -------------------------------------------------------------------------------------------
; Name: ShowPrimes
; Description: Determines if all positive integer values below the inputted user value are primes or not, and displays them through a loop.
; Preconditions: "input" variable with a number between [1, 200]
; Postconditions: ECX is modified directly within this procedure, although the called procedure "IsPrime" modifies additional registers
; Recieves: global variable input and current
; Returns: none
; -------------------------------------------------------------------------------------------
ShowPrimes PROC
	MOV		ECX, input

_CheckingPrimes:					; going through and checking if the values below the input are prime
	CALL	IsPrime
	INC		current
	LOOP _CheckingPrimes

	RET
ShowPrimes ENDP

; -------------------------------------------------------------------------------------------
; Name: IsPrime
; Description: Prints out a number if it is deemed to be a prime value by determining if it has 2 or more factors. 
; Preconditions: the "current" variable containing the value to be examined for 'primeness'
; Postconditions: EDX, EAX, ECX, and EDX are all modified
; Recieves: current, divider, and counter as global variables
; Returns: none
; -------------------------------------------------------------------------------------------
IsPrime PROC
	; determining if there is enough space on the line (less than 10 numbers)
	CMP		line_nums, 10
	JNZ		_CheckingPrime
	CALL	CrLf
	MOV		line_nums, 0
	
_CheckingPrime:						; begins the process for checking the reminder by saving ECX into stack
	PUSH	ECX
	MOV		ECX, current

_CheckingReminders:					; checking if the number is actually prime by determining the number's factors via reminder divison
	XOR		EDX, EDX
	MOV		EBX, divider
	MOV		EAX, current
	DIV		EBX
	CMP		EDX, 0
	JZ		_IsFactor
	JMP		_NotFactor
	
_IsFactor:
	INC		counter

_NotFactor:
	INC		divider
	LOOP	_CheckingReminders

	MOV		divider, 1
	POP		ECX
	CMP		counter, 2				; if the number has 2 factors, consider it as a prime number or jump
	JNE		_NotPrime

_SpaceAvailable:					; printing the number if prime
	MOV		EAX, current
	INC		line_nums
	MOV		EAX, current
	CALL	WriteDec

	; determines how many digits each prime number takes up
	CMP		current, 100
	JGE		_ThreeDigit
	CMP		current, 10
	JGE		_TwoDigit
	JMP		_OneDigit

	; EXTRA CREDIT
_OneDigit:							; prints different spacing based on the number of digits the prime number takes up
	MOV		EDX, OFFSET five_space
	JMP		_PrintPrime
_TwoDigit:
	MOV		EDX, OFFSET four_space
	JMP		_PrintPrime
_ThreeDigit:
	MOV		EDX, OFFSET three_space

_PrintPrime:
	CALL	WriteString

_NotPrime:
	MOV		counter, 0

	RET
IsPrime ENDP

; -------------------------------------------------------------------------------------------
; Name: Farewell
; Description: prints the closing statement, saying goodbye to the user
; Preconditions: "closing" is a string with a farewell greeting
; Postconditions: EDX is changed
; Recieves: the BYTE string "closing"
; Returns: none
; -------------------------------------------------------------------------------------------
Farewell PROC
	MOV		EDX, OFFSET closing
	CALL	WriteString

	RET
Farewell ENDP


END main
