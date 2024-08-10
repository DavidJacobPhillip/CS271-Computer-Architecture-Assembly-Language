TITLE Elementary Arithmetic   (Proj1_933674448.asm)

; Author: Santosh Ramesh
; Last Modified: 1-24-21
; OSU email address: rameshsa@oregonstate.edu
; Course number/section:   CS271 Section 400 (E-CAMPUS WINTER 2020)
; Project Number: 1                Due Date: 1-24-21
; Description: This program calculates the sum and differences of three values "A", "B", and "C" which are prompted from the
;		user in descending order. The sum of A + B + C is also displayed at the end, along with greetings/goodbye messages.
;		This program also repeats itself, based on whether the user would like to. 

INCLUDE Irvine32.inc


.data
greeting_1		BYTE	"          Elementary Arithmetic      by Santosh Ramesh", 13, 10, 0
greeting_2		BYTE	"**EC: The program will repeat itself, based on user's choice", 13, 10, 0
greeting_3		BYTE	"Enter 3 numbers A > B > C, and I'll show you the sum and differences", 13, 10, 0
prompt_A		BYTE	"First number: ", 0
prompt_B		BYTE	"Second number: ", 0
prompt_C		BYTE	"Third number: ", 0
plus_sign		BYTE	" + ", 0
minus_sign		BYTE	" - ", 0
equals_sign		BYTE	" = ", 0
blank_space		BYTE	" ", 13, 10, 0
repeat_prompt_1	BYTE	"Would you like to repeat this program? Type '1' to repeat, or '0' to stop: ", 0
repeat_prompt_2	BYTE	"Repeating the program..."
closing_1		BYTE	"Thanks for using Elementary Arithmetic! Goodbye!", 0

A_number		DWORD	?
B_number		DWORD	?
C_number		DWORD	?
Sum_AB			DWORD	?
Diff_AB			DWORD	?
Sum_AC			DWORD	?
Diff_AC			DWORD	?
Sum_BC			DWORD	?
Diff_BC			DWORD	?
Sum_ABC			DWORD	?
repeat_value	DWORD	?

.code
main PROC
 ; greeting the user
 MOV	EDX, OFFSET greeting_1
 CALL	WriteString
 MOV	EDX, OFFSET greeting_2
 CALL	WriteString
 MOV	EDX, OFFSET greeting_3
 CALL	WriteString

_repeat:					; code-label to represent where the structure will repeat
 ; prompting the user for numbers A, B, & C
 ; number A
 MOV	EDX, OFFSET prompt_A
 CALL	WriteString
 CALL	ReadDec
 MOV	A_number, EAX

 ; number B
 MOV	EDX, OFFSET prompt_B
 CALL	WriteString
 CALL	ReadDec
 MOV	B_number, EAX

 ; number C
 MOV	EDX, OFFSET prompt_C
 CALL	WriteString
 CALL	ReadDec
 MOV	C_number, EAX
 CALL	CrLf

 COMMENT @
 ; printing A, B, and C for testing
 MOV	EAX, A_number
 CALL	WriteDec
 CALL	CrLF
 MOV	EAX, B_number
 CALL	WriteDec
 CALL	CrLF
 MOV	EAX, C_number
 CALL	WriteDec
 CALL	CrLF
 @

 ; calculating the sums & differences of A, B, & C
 ; between A & B
 ; calculating A + B
 MOV	EAX, A_number
 ADD	EAX, B_number
 MOV	Sum_AB, EAX			; stores result of A + B into the "result" variable

 ; printing "A + B = result"
 MOV	EAX, A_number
 CALL	WriteDec
 MOV	EDX, OFFSET plus_sign
 CALL	WriteString
 MOV	EAX, B_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Sum_AB
 CALL	WriteDec			; prints A + B result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; calculating A - B
 MOV	EAX, A_number
 SUB	EAX, B_number
 MOV	Diff_AB, EAX		; stores result of A - B into the "result" variable

 ; printing "A - B = result"
 MOV	EAX, A_number
 CALL	WriteDec
 MOV	EDX, OFFSET minus_sign
 CALL	WriteString
 MOV	EAX, B_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Diff_AB
 CALL	WriteDec			; prints A - B result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; between A & C
 ; Calculating A + C
 MOV	EAX, A_number
 ADD	EAX, C_number
 MOV	Sum_AC, EAX			; stores result of A + C into the "result" variable

 ; printing "A + C = result"
 MOV	EAX, A_number
 CALL	WriteDec
 MOV	EDX, OFFSET plus_sign
 CALL	WriteString
 MOV	EAX, C_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Sum_AC
 CALL	WriteDec			; prints A + C result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; calculating A - C
 MOV	EAX, A_number
 SUB	EAX, C_number
 MOV	Diff_AC, EAX		; stores result of A - C into the "result" variable

 ; printing "A - C = result"
 MOV	EAX, A_number
 CALL	WriteDec
 MOV	EDX, OFFSET minus_sign
 CALL	WriteString
 MOV	EAX, C_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Diff_AC
 CALL	WriteDec			; prints A - C result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; between B & C
 ; Calculating B + C
 MOV	EAX, B_number
 ADD	EAX, C_number
 MOV	Sum_BC, EAX			; stores result of B + C into the "result" variable

 ; printing "B + C = result"
 MOV	EAX, B_number
 CALL	WriteDec
 MOV	EDX, OFFSET plus_sign
 CALL	WriteString
 MOV	EAX, C_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Sum_BC
 CALL	WriteDec			; prints B + C result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; calculating B - C
 MOV	EAX, B_number
 SUB	EAX, C_number
 MOV	Diff_BC, EAX		; stores result of B - C into the "result" variable

 ; printing "B - C = result"
 MOV	EAX, B_number
 CALL	WriteDec
 MOV	EDX, OFFSET minus_sign
 CALL	WriteString
 MOV	EAX, C_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Diff_BC
 CALL	WriteDec			; prints B - C result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; calculating sums of A, B, & C
 ; calculating A + B + C
 MOV	EAX, A_number
 ADD	EAX, B_number
 ADD	EAX, C_number
 MOV	Sum_ABC, EAX		; stores result of A + B + C into the "result" variable

 ; printing "A + B + C = result"
 MOV	EAX, A_number
 CALL	WriteDec
 MOV	EDX, OFFSET plus_sign
 CALL	WriteString
 MOV	EAX, B_number
 CALL	WriteDec
 MOV	EDX, OFFSET plus_sign
 CALL	WriteString
 MOV	EAX, C_number
 CALL	WriteDec
 MOV	EDX, OFFSET equals_sign
 CALL	WriteString
 MOV	EAX, Sum_ABC
 CALL	WriteDec			; prints A + B + C result value after the equation

 ; shifting future calculations to new line
 MOV	EDX, OFFSET blank_space
 CALL	WriteString

 ; determing if the user wants to repeat the program
 CALL	CrLF
 MOV	EDX, OFFSET repeat_prompt_1
 CALL	WriteString
 CALL	ReadInt
 CMP	EAX, 1
 JZ		_repeat

 ; saying goodbye to user
 CALL	CrLf
 MOV	EDX, OFFSET closing_1
 CALL	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
