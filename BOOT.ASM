

ASSUME CS:CODE

CODE SEGMENT
		ORG 07C00H
		START:
        JMP SHORT CODE_START
        MSG     DB 'hello turb, this is your first operating system.', '$'
        CODE_START:

        MOV AX, CS
        MOV DS, AX
        MOV DX, 07C00H + 0002H
        MOV AH, 09H
        INT 21H
        
        REMAIN DB (510 - ($ - START)) DUP (0)
        DW 0AA55H
        
CODE ENDS
        END START
