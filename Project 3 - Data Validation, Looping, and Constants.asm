TITLE Integer Accumulator    (Proj3_933674448.asm)

; Author: Santosh Ramesh
; Last Modified: 2-7-21
; OSU email address: rameshsa@oregonstate.edu
; Course number/section:   CS271 Section 400 WINTER Ecampus
; Project Number: 3                Due Date: 2-7-21
; Description: This program takes in negative integer inputs from the user between the range [-200, -100] or [-50, -1] to find the
;				maximum, minimum, sum, and rounded integer average of the numbers. The program stops asking the user for new valid
;				inputs once the user inputs a positive integer value (greater than or equal to 0).
;				EXTRA CREDIT: each line of the valid number input is numbered.

INCLUDE Irvine32.inc

LOW_BOUNDARY_1	= -200					; the lowest permissable value
HIGH_BOUNDARY_1 = -100
LOW_BOUNDARY_2	= -50
HIGH_BOUNDARY_2 = 1						; the highest permissable value

.data
greeting_1		BYTE	"Welcome to the Integer Accumulator by Santosh Ramesh", 13, 10, 0
extra_credit	BYTE	"EC: (1) the current valid number is displayed for each line", 13, 10, 0
greeting_2		BYTE	13, 10, "What is your name? ", 0
greeting_3		BYTE	"Hello there, ", 0
boundaries_1	BYTE	13, 10, "Please enter numbers in [-200, -100] or [-50, -1].", 13, 10, 0
boundaries_2	BYTE	"Enter a non-negative number when you are finished to see the results.", 13, 10, 0
enter_number	BYTE	". Enter number: ", 0
invalid_error	BYTE	"Number Invalid! ", 13, 10, 0
nums_entered_1	BYTE	13, 10, "You entered ",0
nums_entered_2	BYTE	" valid numbers", 13, 10 ,0
show_max		BYTE	13, 10, "The maximum valid number is: ", 0
show_min		BYTE	13, 10, "The minimum valid number is: ", 0
show_sum		BYTE	13, 10, "The sum of your valid numbers is: ", 0
show_r_avg		BYTE	13, 10, "The rounded average is: ", 0
special			BYTE	13, 10, "Since no valid numbers have been entered, no calculations can be performed.", 0
closing_1		BYTE	13, 10, 13, 10, "We have to stop meeting like this. Farewell, Santosh Ramesh", 13, 10, 13, 10, 0

user_name		BYTE	21 DUP(0)		; where user enters their name
potential		SDWORD	?				; where a possibly valid number is stored
valid			DWORD	0				; stores the number of valid numbers inputed
maximum			SDWORD	-200			
minimum			SDWORD	-1				
sum				SDWORD	0			
r_avg			SDWORD	?				; the rounded average of all numbers
avg				SDWORD	?				; this will be the non-rounded average of all numbers
reminder		SDWORD	?				; this represents the reminder of the divison

.code
main PROC
 ; INTRODUCTORY GREETINGS
 ; greeting the user 
 MOV	EDX, OFFSET greeting_1		
 CALL	WriteString						; "welcome to the integer accumulator..."
 MOV	EDX, OFFSET extra_credit			
 CALL	WriteString						; "EC: ..."

 ; getting user name
 MOV	EDX, OFFSET greeting_2
 CALL	WriteString						; "what is your name? "
 MOV	ECX, 20
 MOV	EDX, OFFSET user_name
 CALL	ReadString						; gets user_name

 ; displaying user name
 MOV	EDX, OFFSET greeting_3
 CALL	WriteString						; "Hello there, "
 MOV	EDX, OFFSET user_name
 CALL	WriteString						; displays user_name
 CALL	CrLf

 ; OBTAINING VALID INPUTS
 ; displaying boundaries of inputs
 MOV	EDX, OFFSET boundaries_1
 CALL	WriteString						; "Please enter numbers in [-200, -100] or [-50, -1]."
 MOV	EDX, OFFSET boundaries_2
 CALL	WriteString						; "Enter a non-negative number when you are finished to see results."

 ; obtaining number to be checked if valid
_obtain:
 ; EXTRA CREDIT #1: displaying which valid number we are on to be collected
 INC	valid
 MOV	EAX, valid
 CALL	WriteDec						; displays the valid number's number
 DEC	valid

 ; getting user to input the value to be checked
 MOV	EDX, OFFSET	enter_number
 CALL	WriteString						; "Enter number: "
 CALL	ReadInt
 MOV	potential, EAX

 ; checking if potential number is positive
 MOV	EAX, potential
 CMP	EAX, 0
 JNS	_completed

 ; checking if potential number is between range [-200, -100]
 MOV	EAX, potential
 CMP	EAX, LOW_BOUNDARY_1
 JL		_error							; jumping to error if less than -200

 CMP	EAX, HIGH_BOUNDARY_1
 JLE	_valid							; jumping to "valid" section as the number is between [-200, -100]
					
 ; checking if potential number is between range [-50, -1]
 MOV	EAX, potential
 CMP	EAX, LOW_BOUNDARY_2
 JL		_error							; jumping to error if less than -50
 JGE	_valid							; jumping to "valid" section as the number is between [-50, -1]
										; we don't need to check for numbers greater than -1, as they fall under the "positive" range

 ; displaying error if number isn't within negative range
_error:
 MOV	EDX, OFFSET invalid_error
 CALL	WriteString						; "Invalid Number!"
 JMP	_obtain

 ; CALCULATIONS
_valid:									; calculates the sum, max, and min for all valid numbers during the input-phase
 ; incrementing the number of valid numbers
 MOV	EAX, valid
 INC	EAX
 MOV	valid, EAX

 ; adding sum of valid numbers
 MOV	EAX, potential
 ADD	sum, EAX						; summing the values together

 ; updating minimum value
 MOV	EAX, potential
 CMP	minimum, EAX
 JL		_maximum						; jumping to check if the value is a maximum, since it is greater than minimum
 MOV	minimum, EAX					; updating minimum value (if min)

 ; updating maximum value
_maximum:
 MOV	EAX, potential
 CMP	maximum, EAX
 JG		_repeat							; jumping to the repeat phase since the value is not a maximum
 MOV	maximum, EAX					; updating maximum value (if max)

 ; repeating input phase to gather more valid numbers
_repeat:
 JMP	_obtain

_completed:								; after postive value has been inputed, input phase is completed
 ; checking if 0 valid numbers have been inputed
 CMP	valid, 0
 JNZ	_average
 MOV	EDX, OFFSET special
 CALL	WriteString
 JMP	_concluding
 
 ; calculating average;
_average:
 MOV	EAX, sum
 MOV	EBX, valid
 CDQ
 IDIV	EBX								; divides the sum by the number of valid integers
 MOV	r_avg, EAX
 MOV	reminder, EDX

 ; checking if the average needs to be rounded up
 MOV	EAX, valid						; moving the number of valid numbers into EAX to be divided by 2
 MOV	EBX, 2
 CDQ	
 IDIV	EBX
 CMP	EBX, EDX						; checking if the quotient of the average is greater than 1/2 of the number of valid numbers
 JL		_calculations
 DEC	r_avg							; rounding the average if the reminder is greater than 0.5

 ; DISPLAYING CALCULATIONS
_calculations:
 ; displaying number of valid numbers inputed
 MOV	EDX, OFFSET nums_entered_1		
 CALL	WriteString						; "You entered "
 MOV	EAX, valid
 CALL	WriteDec						; displays valid numbers inputed
 MOV	EDX, OFFSET nums_entered_2
 CALL	WriteString						; "valid numbers"

 ; displaying maximum
 MOV	EDX, OFFSET	show_max
 CALL	WriteString						; "The maximum valid number is: "
 MOV	EAX, maximum
 CALL	WriteInt						; displays maximum

 ; displaying minimum
 MOV	EDX, OFFSET	show_min
 CALL	WriteString						; "The minimum valid number is: "
 MOV	EAX, minimum
 CALL	WriteInt						; displays minimum

 ; displaying sum of numbers
 MOV	EDX, OFFSET	show_sum
 CALL	WriteString						; "The sum of your valid numbers is: "
 MOV	EAX, sum
 CALL	WriteInt						; displays sum

 ; displaying rounded average of numbers
 MOV	EDX, OFFSET	show_r_avg
 CALL	WriteString						; "The rounded average is: "
 MOV	EAX, r_avg
 CALL	WriteInt						; displays r_avg (rounded average)

 ; CONCLUDING REMARKS
_concluding:
 ; saying bye to user
 MOV	EDX, OFFSET closing_1
 CALL	WriteString						; "We have to stop meeting like this. Farewell, Santosh"


	Invoke ExitProcess,0	; exit to operating system
main ENDP
 



END main
