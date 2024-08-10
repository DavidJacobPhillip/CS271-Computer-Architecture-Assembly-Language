TITLE Random Array  (Proj5_933674448.asm)

; Author: Santosh Ramesh
; Last Modified: 3-1-21
; OSU email address: rameshsa@oregonstate.edu
; Course number/section:   CS271 Section 400 Winter ECAMPUS
; Project Number:  5               Due Date: 2-28-21
; Description: Generates a list of 200 random numbers in a given range [10,29], display that original list, sort it, then display
;				the median value, display list in ascending order, then finally display number of instances of each generated value

INCLUDE Irvine32.inc

HI			=	29
LO			=	10
ARRAYSIZE	=	200
RANGE		=	HI - LO

.data

intro_1			BYTE	"Generating, Sorting, and Counting Random integers! Programmed by Santosh Ramesh", 13, 10, 13, 10, 0
intro_2			BYTE	"This program generates 200 random numbers in the range [10 ... 29], displays the", 13, 10, 
						"original list, sorts the list, displays the median value of the list, displays the ", 13, 10,
						"list sorted in ascending order, then displays the number of instances of each ", 13, 10,
						"generated value, starting with the number of 10s.", 13, 10, 13, 10, 0
unsrt_prompt	BYTE	13, 10, "Your unsorted random numbers:", 13, 10, 0
sort_prompt		BYTE	13, 10, "Your sorted random numbers:", 13, 10, 0
median_prompt	BYTE	13, 10, "The median value of the array: ", 0
count_prompt	BYTE	13, 10, 13, 10, "Your list of instances of each generated number, starting with the number of 10s:", 13, 10, 0
closing			BYTE	13, 10, 13, 10, "Goodbye, and thanks for using this program!", 13, 10, 13, 10, 0

rand_array		DWORD	ARRAYSIZE DUP(0)			; array of random integers
count_array		DWORD	RANGE DUP(0)				; array of random integers

.code
main PROC
	MOV		EAX, RANGE
	CALL	WriteDec
	; Seeding Randomizer
	CALL	Randomize

	; Introduction
	PUSH	OFFSET intro_1
	PUSH	OFFSET intro_2
	CALL	Introduction

	; Filling Array
	PUSH	ARRAYSIZE
	PUSH	HI
	PUSH	LO
	PUSH	OFFSET rand_array
	CALL	FillArray

	PUSH	ARRAYSIZE
	PUSH	OFFSET rand_array
	PUSH	OFFSET unsrt_prompt
	CALL	DisplayList

	; Sorting Array
	PUSH	OFFSET ARRAYSIZE
	PUSH	OFFSET rand_array
	CALL	SortList

	PUSH	ARRAYSIZE
	PUSH	OFFSET rand_array
	PUSH	OFFSET sort_prompt
	CALL	DisplayList

	; Calculating Median
	PUSH	ARRAYSIZE
	PUSH	OFFSET rand_array
	PUSH	OFFSET median_prompt
	CALL	DisplayMedian
	
	; Counting Integer Occurances
	PUSH	HI
	PUSH	LO
	PUSH	OFFSET count_array
	PUSH	ARRAYSIZE
	PUSH	OFFSET rand_array
	CALL	CountList

	PUSH	RANGE
	PUSH	OFFSET count_array
	PUSH	OFFSET count_prompt
	CALL	DisplayList

	; Closing & Farewell
	MOV		EDX, OFFSET closing
	CALL	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -------------------------------------------------------------------------------------------
; Name: Introduction
; Description: prints out the beginning greeting to the user
; Preconditions: "intro_#" are strings describing the program's functionality
; Postconditions: EDX changed
; Recieves: intro_1 (reference, input), intro_2 (reference, input)
; Returns: none
; -------------------------------------------------------------------------------------------
Introduction PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX

	; printing greeting
	MOV		EDX, [EBP + 12]		; moves the "intro_1" string into EDX to be printed
	CALL	WriteString
	MOV		EDX, [EBP + 8]		; moves the "intro_2" string into EDX to be printed
	CALL	WriteString
		
	POP		EDX
	POP		EBP

	RET		8
Introduction ENDP

; -------------------------------------------------------------------------------------------
; Name: FillArray
; Description: takes in an empty "rand_array" and fills it with random values between a given range of "LO" and "HI"
; Preconditions: rand_array should be empty, initialized to the size "ARRAYSIZE"
; Postconditions: EBP, EAX, EDI, and ECX are all modified and restored to pre-procedure state
; Recieves: rand_array (reference, output), LO (value, input), HI (value, input), ARRAYSIZE (value, input)
; Returns: each element in the "rand_array" is filled with random values within the range
; -------------------------------------------------------------------------------------------
FillArray PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EDI
	PUSH	ECX

	; randomly inputting values within array
	MOV		EDI, [EBP + 8]		; moving rand array into EDX
	MOV		ECX, [EBP + 20]		; moving ARRAYSIZE into ECX

_RandInput:
	; generating the random integer value
	MOV		EAX, [EBP + 16]		; moving upper limit into EAX as the "high" value
	SUB		EAX, [EBP + 12]		; subtracting the "low" value from high to provide a range starting from 0 of integer values
	INC		EAX
	CALL	RandomRange
	ADD		EAX, [EBP + 12]

	; moving random integer value into array
	MOV		[EDI], EAX
	ADD		EDI, 4
	LOOP	_RandInput

	POP		ECX
	POP		EDI
	POP		EAX
	POP		EBP

	RET 16
FillArray ENDP

; -------------------------------------------------------------------------------------------
; Name: SortList
; Description: The "rand_array" is sorted in ascending order, with elements reorganized through bubble-sort
; Preconditions: The "rand_array" filled with values within the range "HI" and "LO" 
; Postconditions: EBP, EAX, EDI, ESI, ECX, EBX are all modified and restored to pre-procedure state
; Recieves: rand_array (reference, input/output), ARRAYSIZE (value, input)
; Returns: modifies the "rand_array" to be sorted in ascending order
; -------------------------------------------------------------------------------------------
SortList PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EDI
	PUSH	ESI
	PUSH	ECX
	PUSH	EBX

	; bubble sort algorithm
	MOV		EBX, 0				; represents current index being examined
	MOV		EDI, [EBP + 8]		; moving the rand_array into EDI
	MOV		ESI, [EBP + 8]		; moving the rand_array into ESI
	MOV		ECX, [EBP + 12]		; moving ARRAYSIZE into the loop counter

_OuterLoop:						; goes through array list "ARRAYSIZE" times
	PUSH	ECX
	PUSH	ESI

_InnerLoop:
	PUSH	EDI
	PUSH	ESI
	CALL	ExchangeElements	; exchanging the elements
	ADD		ESI, 4
	LOOP	_InnerLoop

	POP		ESI
	POP		ECX
	ADD		ESI, 4
	ADD		EDI, 4
	LOOP	_OuterLoop

	POP		EBX
	POP		ECX
	POP		ESI
	POP		EDI
	POP		EAX
	POP		EBP

	RET
SortList ENDP

; -------------------------------------------------------------------------------------------
; Name: ExchangeElements
; Description: Two values within the same array are compared, and are switched if one is larger than the other to supplement the sorting program
; Preconditions: "rand_array" should be filled with integer values, along with the two values to be compared passed into stack frame
; Postconditions: EBP, EAX, EDI, EBX, and ESI are all modified and restored to pre-procedure state
; Recieves: source_array (reference, input) destination_array (reference, output)
; Returns: potentially switches two elements within "rand_array"
; -------------------------------------------------------------------------------------------
ExchangeElements PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	EDI
	PUSH	ESI
	
	MOV		EBX, [ESI]
	MOV		EAX, [EDI]

	CMP		EAX, EBX		; comparing elements to be exchanged
	JL		_NoExchange
	MOV		[ESI], EAX
	MOV		[EDI], EBX

_NoExchange:				; skipping exchange if the source not less than destination

	POP		ESI
	POP		EDI
	POP		EBX
	POP		EAX
	POP		EBP

	RET 8
ExchangeElements ENDP

; -------------------------------------------------------------------------------------------
; Name: DisplayMedian
; Description: Displays the median value for "rand_array" 's integers, rounded up
; Preconditions: The "rand_array" filled with values within the "HI" & "LO" ranges
; Postconditions: EBP, EDX, EDI, EAX, EBX, and ECX are all modified and restored to pre-procedure state
; Recieves: median_prompt (reference, input), rand_array (reference, input), ARRAYSIZE (value, input)
; Returns: none
; -------------------------------------------------------------------------------------------
DisplayMedian PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	PUSH	EDI
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX

	; printing median prompt
	MOV		EDX, [EBP + 8]
	CALL	WriteString

	; calculating where median is going to be
	XOR		EDX, EDX
	MOV		EAX, [EBP + 16]
	MOV		EBX, 2
	DIV		EBX

	; finding index at which median value resides
	MOV		EDI, [EBP + 12]
	MOV		ECX, EAX
_FindMedian:						; looping until at median value
	ADD		EDI, 4
	LOOP	_FindMedian

	; adding numbers above and below median
	MOV		EBX, 0
	ADD		EBX, [EDI]
	ADD		EDI, 4
	ADD		EBX, [EDI]

	; computing median value
	XOR		EDX, EDX
	MOV		EAX, EBX
	MOV		EBX, 2
	DIV		EBX

	; determining if median needs to be rounded up
	CMP		EDX, 1
	JNE		_NoRound
	INC		EAX		
_NoRound:							; if the median doesn't need to be rounded up

	; printing median value
	CALL	WriteDec

	POP		ECX
	POP		EBX
	POP		EAX
	POP		EDI
	POP		EDX
	POP		EBP

	RET		8
DisplayMedian ENDP

; -------------------------------------------------------------------------------------------
; Name: CountList
; Description: Counts the occurance of each integer within the "LO" & "HI" range present within the "rand_array", and places it into the "count_array"
; Preconditions: the "rand_array" must be initialized with random integer values within the range, and the "count_array" must be intialized to the range size.
; Postconditions: EBP, EDX, EDI, ESI, EAX, EBX, ECX, and EDX are all modified and restored to pre-procedure state
; Recieves: rand_array (reference input), ARRAYSIZE (value, input), count_array (reference, output), LO (value, input), HI (value, input)
; Returns: modifies "count_array" to hold the occurances of each integer within "rand_array"
; -------------------------------------------------------------------------------------------
CountList PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	PUSH	EDI
	PUSH	ESI
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX

	; counting instances of each integer
	MOV		EDI, [EBP + 16]		; moves count_array offset into destination register
	MOV		EBX, [EBP + 20]		; moves LO into EBX
	MOV		ECX, [EBP + 24]		; moves HI into ECX
	SUB		ECX, EBX
	MOV		EAX, 0

_GeneralInteger:				; looping through each count
	PUSH	ECX
	MOV		ECX, [EBP + 12]		; moves ARRAYSIZE into ECX for the loop
	MOV		ESI, [EBP + 8]		; moves rand_array offset into source register

_SpecificInteger:				; determining the count of each integer
	CMP		[ESI], EBX
	JNZ		_NotEqual
	INC		EAX
_NotEqual:						; if compared integers aren't equal
	ADD		ESI, 4
	LOOP	_SpecificInteger

	POP		ECX
	MOV		[EDI], EAX
	ADD		EDI, 4
	MOV		EAX, 0
	INC		EBX

	LOOP	_GeneralInteger

	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		ESI
	POP		EDI
	POP		EDX
	POP		EBP

	RET		20
CountList ENDP

; -------------------------------------------------------------------------------------------
; Name: DisplayList
; Description: This displays the array integer elements of a list in 20-number lines, along with a title describing that array through a string.
; Preconditions: An array with filled elements along with a string describing the array itself passed into stack
; Postconditions: EBP, EDX, ECX, ESI, and EBX are all modified and restored to pre-procedure state
; Recieves: someTitle (reference, input), rand_array (reference, input), ARRAYSIZE (value, input)
; Returns: none
; -------------------------------------------------------------------------------------------
DisplayList PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	PUSH	ECX
	PUSH	ESI
	PUSH	EBX

	; printing sorting type
	MOV		EDX, [EBP + 8]
	CALL	WriteString

	; printing the array to console
	MOV		ECX, [EBP + 16]		; setting loop to be equal to number of array elements
	MOV		EBX, 0				; setting counter for number of lines per loop
	MOV		ESI, [EBP + 12]		; moving array address offset into ESI

_PrintArr:
	MOV		EAX, [ESI]
	CALL	WriteDec
	MOV		EAX, 32				; printing a space
	CALL	WriteChar
	ADD		ESI, 4 

	INC		EBX
	CMP		EBX, 20				; determines if there are less than 20 integers per line
	JNE		_SpaceLeft		
	MOV		EBX, 0
	CALL	CrLf

_SpaceLeft:
	LOOP	_PrintArr

	POP		EBX
	POP		ESI
	POP		ECX
	POP		EDX
	POP		EBP

	RET		16
DisplayList ENDP

END main
