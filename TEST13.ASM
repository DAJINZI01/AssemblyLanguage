; 分别在屏幕的第2/4/6/8行像是4句英文是，补全程序

ASSUME CS:CODE

CODE SEGMENT
	S1	DB 'Good, better, best', '$'
	S2	DB 'Never let it rest,', '$'
	S3	DB 'Till good is better,', '$'
	S4	DB 'And better, best.', '$'
	S	DW OFFSET S1, OFFSET S2, OFFSET S3, OFFSET S4
	ROW	DB 2, 4, 6, 8

	START:
	MOV AX, CS
	MOV DS, AX
	MOV BX, OFFSET S
	MOV SI, OFFSET ROW
	MOV CX, 0004H

	_S:
	MOV BH, 00H
	MOV DH, [SI]
	MOV DL, 00H
	MOV AH, 02H
	INT 10H

	MOV DX, [BX]
	MOV AH, 09H
	INT 21H

	INC SI
	ADD BX, 0002H
	LOOP _S

	MOV AX, 4C00H
	INT 21H
CODE ENDS
	END START
