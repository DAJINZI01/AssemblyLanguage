ASSUME CS:CODE

CODE SEGMENT
	START:
	JMP NEAR PTR S
	DB 32768 DUP (0)
	S:
	MOV AX, 0FFFFH
	
	MOV AX, 4C00H
	INT 21H
CODE ENDS
	END START
